---
name: resolving-merge-conflicts
description: Resolve in-progress git merge or rebase conflicts.
---

# Resolving Merge Conflicts

Resolve git merge or rebase conflicts cleanly.

## Steps

1. **Check conflict status:** Run `git status` and inspect all files with conflict markers.
2. **Review branch intent:** Read commit messages and PR descriptions for both branches to understand why changes were made.
3. **Resolve conflict markers:** Edit each file to combine changes correctly. Preserve functionality from both branches whenever possible. Do not invent unrequested new behavior.
4. **Run automated checks:** Run typechecking and tests to verify that the resolved code works cleanly.
5. **Complete the merge/rebase:** Stage resolved files (`git add`) and complete the merge or rebase commit (`git merge --continue` or `git rebase --continue`).
