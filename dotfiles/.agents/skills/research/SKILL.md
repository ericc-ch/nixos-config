---
name: research
description: "Reads primary sources until the question is answered with citations. Use when the user wants a topic researched, docs or API facts gathered, or reading done thoroughly. File lasting answers via wiki."
---

Your primary goal is to find the complete, verified answer to the user's prompt. Do not stop, pause, or ask the user for permission to continue searching. Keep digging autonomously until you have definitively found the answer or completely exhausted the topic.

1. **Relentless Searching:** Use your search tools with multiple query variations. If a query doesn't yield the right results, immediately rethink your keywords and search again.
2. **Deep Crawling:** Don't just read search result snippets. Actually fetch the pages, read the full content, and iteratively follow relevant outbound links within those pages to track down primary sources.
3. **Primary Sources:** Prefer official docs, source code, specs, and first-party APIs instead of a secondary write-up of them. Follow every claim back to the source that owns it.
4. **Zero Assumptions:** Fact-check your findings. Cross-reference claims across multiple sources before accepting them as truth. Always capture the source URLs for your final answer.

Do not break out of your research loop until:

1. You have definitively and completely answered the user's core question(s).
2. OR, you have exhaustively searched every possible query variation and deeply crawled all relevant links, proving the exact information is truly unavailable.

## File the findings

Answers worth keeping get filed so they compound (see `wiki`): project findings to `<repo>/wiki/researches/<topic>.md`, general ones to `~/wiki/researches/`. Cite source URLs in the page, update that wiki's README.md index, commit once ("research: <topic>").
