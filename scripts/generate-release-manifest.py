#!/usr/bin/env python3
"""Generate a deterministic SHA-256 manifest for Git-tracked release files."""
from __future__ import annotations
import argparse, hashlib, json, pathlib, subprocess
ROOT=pathlib.Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(); p.add_argument('--output',default='dist/release-manifest.json'); args=p.parse_args()
out=(ROOT/args.output).resolve(); out.parent.mkdir(parents=True,exist_ok=True)
tracked=subprocess.check_output(['git','-C',str(ROOT),'ls-files','-z']).split(b'\0')
files=[]
for raw in sorted(x for x in tracked if x):
    rel=raw.decode(); path=ROOT/rel
    if path.resolve()==out: continue
    data=path.read_bytes(); files.append({'path':rel,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()})
commit=subprocess.check_output(['git','-C',str(ROOT),'rev-parse','HEAD'],text=True).strip()
payload={'schema_version':1,'version':(ROOT/'VERSION').read_text().strip(),'commit':commit,'file_count':len(files),'files':files}
out.write_text(json.dumps(payload,indent=2)+"\n")
print(f'Wrote {out} with {len(files)} files.')
