---
name: web-search
description: Run web searches via DuckDuckGo using the ddgs Python library through uv, with no system Python or venv required. On Termux/Android ddgs cannot install — use the bundled scripts/search-brave.py (Brave via curl_cffi) instead. Use when you need to look something up, verify facts, find docs, or gather current information from the web.
---

# Web Search

Search the web with DuckDuckGo using `ddgs`, run through `uv`. `uv` fetches a managed Python and the package on the fly, so no system Python or virtualenv is needed. First run installs ~16 packages (~9s); later runs are cached.

`ddgs` is the maintained successor to `duckduckgo_search`. It searches **DuckDuckGo, not Google** — DuckDuckGo aggregates Bing and others, so results often overlap with Google but are not identical.

## Run a search

```bash
uv run --with ddgs python ./scripts/search.py "your query"
uv run --with ddgs python ./scripts/search.py nixos flake tutorial --max 8
uv run --with ddgs python ./scripts/search.py "release notes" --news
```

Or inline, with no script:

```bash
uv run --with ddgs python -c "
from ddgs import DDGS
with DDGS() as ddgs:
    for r in ddgs.text('your query', max_results=5):
        print(r['title']); print(r['href']); print(r['body'][:160]); print('---')
"
```

Import is always `from ddgs import DDGS`.

## Result keys

- `text()` returns a **list** (not a generator) of `{title, href, body}`.
- `news()` returns a **list** of `{date, title, body, url, image, source}`.
- Gotcha: `text` uses `href`, `news` uses `url`. Both return lists.

## Useful kwargs

`max_results` (int), `region` (e.g. `us-en`), `safesearch` (`on` / `moderate` / `off`), `backend` (`lite` / `html` / `api` — switch if one endpoint gets rate-limited).

Other result types: `images()`, `videos()`, `books()`, `threads()`, and `extract(url)` to fetch a page's text.

## Verify

```bash
uv run --with ddgs python -c "from ddgs import DDGS; print(len(DDGS().text('nixos', max_results=3)))"
```

Prints `3` when the skill is working.

## Termux / Android: use `search-brave.py` instead

`ddgs` **cannot install on Termux**: its `primp` dependency has no wheel uv accepts there, and building from source needs Rust for the `aarch64-unknown-linux-android` target, which rustup refuses. DuckDuckGo also returns a 202 captcha to non-browser TLS from many IPs (even with impersonation). Use the bundled Brave-backed script — `curl_cffi` impersonates Chrome's TLS fingerprint, backends: **Brave HTML** primary, **Bing RSS** fallback:

```bash
uv run --with curl_cffi python ./scripts/search-brave.py "your query"
uv run --with curl_cffi python ./scripts/search-brave.py nixos flake tutorial --max 8
echo "query" | uv run --with curl_cffi python ./scripts/search-brave.py
```

Fetch a page as readable text (ddgs' `extract()` equivalent):

```bash
uv run --with curl_cffi python ./scripts/search-brave.py --fetch https://example.com/page
```

Options: `--max N`, `--backend auto|brave|bing`, `--fetch URL`. Output format: title / URL / ~200-char snippet / `---` per result (same as the ddgs script).

Gotchas:

- Bing RSS is a last resort on non-US IPs — it may geo-mangle queries or return unrelated results. Prefer Brave; if Brave fails, retry once before falling back.
- News search is not supported; for tech topics `hn.algolia.com/api/v1/search?query=...` (no auth) works well.
- For finding apps/tools, unauthenticated GitHub search is precise: `curl -s "https://api.github.com/search/repositories?q=...&sort=stars&per_page=10"` (10 req/min limit).
- Reddit returns 403 to curl; Startpage/Ecosia/Mojeek block bot TLS. Don't bother.
