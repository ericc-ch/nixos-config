"""DuckDuckGo web search via the ddgs library.

Run through uv so no system Python or virtualenv is required:

    uv run --with ddgs python scripts/search.py "query"
    uv run --with ddgs python scripts/search.py nixos flake --max 8 --news
    echo "query" | uv run --with ddgs python scripts/search.py

NOTE: does not work on Termux/Android — ddgs depends on primp, which cannot
build there. Use scripts/search-brave.py instead (see SKILL.md).
"""
import argparse
import sys

from ddgs import DDGS


def main() -> int:
    p = argparse.ArgumentParser(description="DuckDuckGo search via ddgs.")
    p.add_argument("query", nargs="*", help="search query (or read from stdin)")
    p.add_argument("--max", type=int, default=5, dest="max_results", help="max results (default 5)")
    p.add_argument("--news", action="store_true", help="search news instead of web")
    args = p.parse_args()

    query = " ".join(args.query).strip()
    if not query:
        query = sys.stdin.read().strip()
    if not query:
        p.error("query required")

    with DDGS() as ddgs:
        if args.news:
            results = ddgs.news(query, max_results=args.max_results)
            url_key = "url"
        else:
            results = ddgs.text(query, max_results=args.max_results)
            url_key = "href"

    for r in results:
        print(r.get("title", ""))
        print(r.get(url_key, ""))
        print((r.get("body") or "")[:200])
        print("---")
    return 0


if __name__ == "__main__":
    sys.exit(main())
