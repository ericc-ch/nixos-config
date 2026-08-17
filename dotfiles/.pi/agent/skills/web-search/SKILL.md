---
name: web-search
description: Run web searches via DuckDuckGo using the ddgs Python library through uv, with no system Python or venv required. Use when you need to look something up, verify facts, find docs, or gather current information from the web.
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
