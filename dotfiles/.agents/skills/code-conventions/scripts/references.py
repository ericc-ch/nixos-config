#!/usr/bin/env python3
"""Sync external reference repositories into /tmp/references/.

This file is meant as a template. Copy this file, fill in REPOSITORIES below,
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path
from typing import NamedTuple

REFERENCES_DIR = Path("/tmp/references")


class Repository(NamedTuple):
    name: str
    url: str
    directory: str
    branch: str | None = None


# Replace with the repositories this project needs as reference material.
REPOSITORIES: list[Repository] = [
    Repository(
        name="Effect",
        url="https://github.com/Effect-TS/effect.git",
        directory="effect",
    ),
    # Repository(name="...", url="...", directory="...", branch="..."),
]


def run_git(args: list[str], cwd: Path) -> None:
    result = subprocess.run(["git", *args], cwd=cwd)
    if result.returncode != 0:
        sys.exit(result.returncode)


def sync(repo: Repository) -> None:
    repo_path = REFERENCES_DIR / repo.directory
    if repo_path.exists():
        print(f"Pulling {repo.name} updates...")
        run_git(["pull", "--ff-only"], cwd=repo_path)
        return

    print(f"Cloning {repo.name}...")
    args = ["clone", "--depth", "1"]
    if repo.branch:
        args += ["--branch", repo.branch]
    args += [repo.url, repo.directory]
    run_git(args, cwd=REFERENCES_DIR)


def main() -> None:
    print(f"Setting up {REFERENCES_DIR}/ directory...")
    REFERENCES_DIR.mkdir(parents=True, exist_ok=True)

    for repo in REPOSITORIES:
        sync(repo)

    print("\nAll reference repositories are up to date!\n\nRepositories:")
    for entry in sorted(path.name for path in REFERENCES_DIR.iterdir()):
        print(entry)


if __name__ == "__main__":
    main()
