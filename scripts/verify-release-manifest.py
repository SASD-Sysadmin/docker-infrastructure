#!/usr/bin/env python3
"""Verify files listed in a release manifest against the current tree."""
from __future__ import annotations
import argparse, hashlib, json, pathlib, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(); p.add_argument('manifest'); args=p.parse_args()
manifest=pathlib.Path(args.manifest); manifest=manifest if manifest.is_absolute() else ROOT/manifest
data=json.loads(manifest.read_text()); failures=[]
for item in data.get('files',[]):
    path=ROOT/item['path']
    if not path.is_file(): failures.append(f"missing {item['path']}"); continue
    raw=path.read_bytes()
    if len(raw)!=item['bytes']: failures.append(f"size mismatch {item['path']}")
    if hashlib.sha256(raw).hexdigest()!=item['sha256']: failures.append(f"hash mismatch {item['path']}")
if data.get('file_count')!=len(data.get('files',[])): failures.append('file_count does not match files array')
if failures:
    print('\n'.join('ERROR: '+x for x in failures),file=sys.stderr); raise SystemExit(1)
print(f"Verified {len(data['files'])} release files for version {data.get('version')}.")
