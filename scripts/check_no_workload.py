#!/usr/bin/env python3
"""Enforce the workload-free Milestone 1 safety boundary."""
from __future__ import annotations

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SEARCH_ROOTS = (ROOT / 'manifests', ROOT / 'site-modules')
RESOURCE = re.compile(
    r'^\s*(package|file|service|user|group|exec|mount|schedule|cron|host|notify)\s*\{',
    re.IGNORECASE,
)


def strip_comments(text: str) -> str:
    lines: list[str] = []
    in_block = False
    for raw in text.splitlines():
        line = raw
        if in_block:
            if '*/' in line:
                line = line.split('*/', 1)[1]
                in_block = False
            else:
                continue
        while '/*' in line:
            before, after = line.split('/*', 1)
            if '*/' in after:
                line = before + after.split('*/', 1)[1]
            else:
                line = before
                in_block = True
                break
        lines.append(line.split('#', 1)[0])
    return '\n'.join(lines)


def main() -> int:
    failures = 0
    checked = 0
    for base in SEARCH_ROOTS:
        for path in sorted(base.rglob('*.pp')):
            checked += 1
            for number, line in enumerate(strip_comments(path.read_text(encoding='utf-8')).splitlines(), 1):
                match = RESOURCE.search(line)
                if match:
                    print(
                        f'ERROR: {path.relative_to(ROOT)}:{number}: '
                        f'{match.group(1)} resource violates Milestone 1 workload-free boundary',
                        file=sys.stderr,
                    )
                    failures += 1
    if failures:
        print(f'Workload boundary validation failed with {failures} error(s).', file=sys.stderr)
        return 1
    print(f'Workload-free boundary passed for {checked} manifest file(s).')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
