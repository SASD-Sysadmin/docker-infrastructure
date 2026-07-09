#!/usr/bin/env python3
"""Enforce the deliberately narrow Milestone 2 resource boundary."""
from __future__ import annotations
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
MANIFESTS = (ROOT / 'manifests', ROOT / 'site-modules')
RESOURCE = re.compile(r'^\s*([a-z][a-z0-9_]*)\s*\{', re.I)
ALLOWED = {'package', 'file'}
FORBIDDEN = {'exec', 'service', 'user', 'group', 'mount', 'schedule', 'cron', 'host'}

def strip_comments(text: str) -> str:
    out=[]; block=False
    for raw in text.splitlines():
        line=raw
        if block:
            if '*/' not in line: continue
            line=line.split('*/',1)[1]; block=False
        while '/*' in line:
            before, after=line.split('/*',1)
            if '*/' in after: line=before+after.split('*/',1)[1]
            else: line=before; block=True; break
        out.append(line.split('#',1)[0])
    return '\n'.join(out)

def main() -> int:
    failures=0; found=[]
    for base in MANIFESTS:
        for path in sorted(base.rglob('*.pp')):
            for number,line in enumerate(strip_comments(path.read_text()).splitlines(),1):
                m=RESOURCE.search(line)
                if not m: continue
                kind=m.group(1).lower(); found.append(kind)
                if kind in FORBIDDEN or kind not in ALLOWED:
                    print(f'ERROR: {path.relative_to(ROOT)}:{number}: resource type {kind} is outside Milestone 2 scope', file=sys.stderr)
                    failures += 1
    if 'package' not in found or 'file' not in found:
        print('ERROR: Milestone 2 must exercise both package and file resources', file=sys.stderr); failures += 1
    if failures: return 1
    print('Milestone 2 resource boundary passed: only package and file resources are declared.')
    return 0
if __name__ == '__main__': raise SystemExit(main())
