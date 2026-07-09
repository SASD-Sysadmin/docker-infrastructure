#!/usr/bin/env python3
"""Enforce the reviewed Milestone 5 catalog resource boundary."""
from __future__ import annotations
import pathlib,re,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
RESOURCE=re.compile(r'^\s*([a-z][a-z0-9_]*)\s*\{',re.I)
ALLOWED={'package','file','service','exec'}
ALLOWED_EXEC_TITLE='reload systemd for SASD Puppet operations'
ALLOWED_EXEC_COMMAND='/bin/systemctl daemon-reload'
def clean(text):
    out=[]; block=False
    for raw in text.splitlines():
        line=raw
        if block:
            if '*/' not in line: continue
            line=line.split('*/',1)[1]; block=False
        while '/*' in line:
            before,after=line.split('/*',1)
            if '*/' in after: line=before+after.split('*/',1)[1]
            else: line=before; block=True; break
        out.append(line.split('#',1)[0])
    return '\n'.join(out)
def main():
    failures=0; found=[]
    for base in (ROOT/'manifests',ROOT/'site-modules'):
        for path in sorted(base.rglob('*.pp')):
            text=clean(path.read_text())
            for n,line in enumerate(text.splitlines(),1):
                m=RESOURCE.search(line)
                if not m: continue
                kind=m.group(1).lower()
                if kind == 'class':
                    continue
                found.append(kind)
                if kind not in ALLOWED:
                    print(f'ERROR: {path.relative_to(ROOT)}:{n}: {kind} outside Milestone 5 scope',file=sys.stderr); failures+=1
            if re.search(r'^\s*exec\s*\{',text,re.M):
                if ALLOWED_EXEC_TITLE not in text or ALLOWED_EXEC_COMMAND not in text or 'refreshonly => true' not in text:
                    print(f'ERROR: {path.relative_to(ROOT)} has a non-allowlisted exec',file=sys.stderr); failures+=1
    for kind in ALLOWED:
        if kind not in found: print(f'ERROR: required resource type not exercised: {kind}',file=sys.stderr); failures+=1
    if failures: return 1
    print('Milestone 5 catalog boundary passed: package, file, service, and one refresh-only systemd reload exec.')
    return 0
if __name__=='__main__': raise SystemExit(main())
