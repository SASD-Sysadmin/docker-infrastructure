#!/usr/bin/env python3
"""Validate repository-local links in Markdown documents."""
from __future__ import annotations

import pathlib
import re
import sys
from urllib.parse import unquote

ROOT = pathlib.Path(__file__).resolve().parents[1]
EXCLUDED_PARTS = {'.git', 'vendor', 'modules'}
LINK = re.compile(r'(?<!!)\[[^\]]*\]\(([^)]+)\)')


def markdown_files() -> list[pathlib.Path]:
    return sorted(
        path for path in ROOT.rglob('*.md')
        if not EXCLUDED_PARTS.intersection(path.relative_to(ROOT).parts)
    )


def main() -> int:
    failures = 0
    checked = 0
    for document in markdown_files():
        text = document.read_text(encoding='utf-8')
        for raw_target in LINK.findall(text):
            target = raw_target.strip().split(maxsplit=1)[0].strip('<>')
            if not target or target.startswith(('#', 'http://', 'https://', 'mailto:')):
                continue
            target = unquote(target.split('#', 1)[0])
            if not target:
                continue
            checked += 1
            resolved = (document.parent / target).resolve()
            try:
                resolved.relative_to(ROOT.resolve())
            except ValueError:
                print(f'ERROR: {document.relative_to(ROOT)}: link leaves repository: {raw_target}', file=sys.stderr)
                failures += 1
                continue
            if not resolved.exists():
                print(f'ERROR: {document.relative_to(ROOT)}: missing link target: {raw_target}', file=sys.stderr)
                failures += 1
    if failures:
        print(f'Markdown link validation failed with {failures} error(s).', file=sys.stderr)
        return 1
    print(f'Markdown link validation passed for {checked} local link(s).')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
