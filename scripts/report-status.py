#!/usr/bin/env python3
"""Summarize compact sasd_json Puppet reports without reading full reports."""
from __future__ import annotations
import argparse, datetime as dt, json, pathlib, sys

def parse_time(value: str | None) -> dt.datetime | None:
    if not value: return None
    try: return dt.datetime.fromisoformat(value.replace('Z','+00:00'))
    except ValueError: return None

def main() -> int:
    p=argparse.ArgumentParser(); p.add_argument('--directory',default='/var/lib/sasd-puppet/reports'); p.add_argument('--stale-after',type=int,default=7200); p.add_argument('--json',action='store_true'); a=p.parse_args()
    root=pathlib.Path(a.directory); now=dt.datetime.now(dt.timezone.utc); rows=[]; errors=[]
    if not root.is_dir(): print(f'ERROR: report directory not found: {root}',file=sys.stderr); return 2
    for path in sorted(root.glob('*.json')):
        try:
            data=json.loads(path.read_text(encoding='utf-8')); timestamp=parse_time(data.get('end_time') or data.get('time'))
            age=int((now-timestamp).total_seconds()) if timestamp else None
            rows.append({'certname':data.get('certname',path.stem),'status':data.get('status','unknown'),'environment':data.get('environment',''),'age_seconds':age,'stale':age is None or age>a.stale_after,'noop':bool(data.get('noop'))})
        except (OSError,json.JSONDecodeError) as exc: errors.append(f'{path}: {exc}')
    if a.json: print(json.dumps({'reports':rows,'errors':errors},indent=2))
    else:
        print(f"{'CERTNAME':40} {'STATUS':10} {'ENVIRONMENT':14} {'AGE(s)':>10} FLAGS")
        for r in rows: print(f"{r['certname'][:40]:40} {r['status'][:10]:10} {r['environment'][:14]:14} {str(r['age_seconds']):>10} {'stale ' if r['stale'] else ''}{'noop' if r['noop'] else ''}")
        for e in errors: print(f'ERROR {e}',file=sys.stderr)
    return 2 if errors else (1 if any(r['stale'] or r['status']=='failed' for r in rows) else 0)
if __name__=='__main__': raise SystemExit(main())
