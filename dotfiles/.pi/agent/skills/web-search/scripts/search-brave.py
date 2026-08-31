"""Web search via curl_cffi with browser TLS impersonation.

Termux-safe alternative to scripts/search.py (ddgs). Use this when ddgs
cannot install (Termux/Android: primp has no usable wheel and its sdist
needs a Rust target rustup refuses to provide) or when DuckDuckGo is
captcha-challenging non-browser TLS. Backends:

  1. Brave Search HTML  (server-rendered, works from most IPs, no JS needed)
  2. Bing RSS           (fallback; clean XML but unreliable on non-US IPs)

Usage:
    uv run --with curl_cffi python scripts/search-brave.py "query"
    uv run --with curl_cffi python scripts/search-brave.py nixos flake --max 8
    echo "query" | uv run --with curl_cffi python scripts/search-brave.py
    uv run --with curl_cffi python scripts/search-brave.py --fetch https://example.com
"""
import argparse
import html
import re
import sys

from curl_cffi import requests

UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"


def _strip(s: str) -> str:
    return html.unescape(re.sub(r"\s+", " ", re.sub(r"<[^>]+>", " ", s))).strip()


def brave_search(q: str, n: int) -> list[dict]:
    r = requests.get("https://search.brave.com/search", params={"q": q},
                     impersonate="chrome", headers={"User-Agent": UA}, timeout=25)
    t = r.text
    anchors = list(re.finditer(
        r'<a href="(https?://[^"]+)"[^>]*class="svelte-14r20fy l1">', t))
    out = []
    for i, m in enumerate(anchors):
        end = anchors[i + 1].start() if i + 1 < len(anchors) else m.end() + 3000
        seg = t[m.end():end]

        def grab(pat: str) -> str:
            mm = re.search(pat, seg, re.S)
            return _strip(mm.group(1)) if mm else ""

        title = grab(r'class="title[^"]*"[^>]*>(.*?)</div>')
        desc = grab(r'class="content[^"]*"[^>]*>(.*?)</div>')
        href = m.group(1)
        if title and "search.brave.com" not in href:
            out.append({"title": title, "href": href, "body": desc})
        if len(out) >= n:
            break
    return out


def bing_search(q: str, n: int) -> list[dict]:
    r = requests.get("https://www.bing.com/search",
                     params={"q": q, "format": "rss", "count": n, "mkt": "en-US"},
                     impersonate="chrome", headers={"User-Agent": UA}, timeout=25)
    out = []
    for it in re.findall(r"<item>(.*?)</item>", r.text, re.S)[:n]:

        def gt(tag: str) -> str:
            mm = re.search(rf"<{tag}>(.*?)</{tag}>", it, re.S)
            return _strip(mm.group(1)) if mm else ""

        out.append({"title": gt("title"), "href": gt("link"), "body": gt("description")})
    return out


def fetch(url: str) -> str:
    r = requests.get(url, impersonate="chrome", headers={"User-Agent": UA},
                     timeout=30, follow_redirects=True)
    t = re.sub(r"<(script|style|svg|noscript)[^>]*>.*?</\1>", " ", r.text, flags=re.S)
    t = html.unescape(re.sub(r"<[^>]+>", "\n", t))
    lines = [ln.strip() for ln in t.splitlines()]
    return re.sub(r"\n{3,}", "\n\n", "\n".join(ln for ln in lines if ln))


def main() -> int:
    p = argparse.ArgumentParser(description="Web search via curl_cffi (Brave, Bing fallback).")
    p.add_argument("query", nargs="*", help="search query (or read from stdin)")
    p.add_argument("--max", type=int, default=5, help="max results (default 5)")
    p.add_argument("--fetch", metavar="URL", help="fetch a page and print readable text")
    p.add_argument("--backend", choices=["auto", "brave", "bing"], default="auto")
    a = p.parse_args()

    if a.fetch:
        print(fetch(a.fetch))
        return 0

    q = " ".join(a.query).strip() or sys.stdin.read().strip()
    if not q:
        p.error("query required")

    results = []
    if a.backend in ("auto", "brave"):
        try:
            results = brave_search(q, a.max)
        except Exception as e:
            print(f"[brave failed: {e}]", file=sys.stderr)
    if not results and a.backend in ("auto", "bing"):
        results = bing_search(q, a.max)

    if not results:
        print("no results (all backends empty/blocked)", file=sys.stderr)
        return 1
    for r in results:
        print(r["title"])
        print(r["href"])
        print(r["body"][:200])
        print("---")
    return 0


if __name__ == "__main__":
    sys.exit(main())
