#!/usr/bin/env python3
"""Inspect a sensitive control-plane backup without restoring live paths."""
from __future__ import annotations
import argparse,hashlib,json,tarfile,time
from pathlib import Path
p=argparse.ArgumentParser(); p.add_argument('archive',type=Path); p.add_argument('--output',type=Path); a=p.parse_args()
errors=[]; warnings=[]; names=[]
if not a.archive.is_file(): errors.append('archive does not exist')
else:
  try:
    with tarfile.open(a.archive,'r:gz') as t:
      for m in t.getmembers():
        n=m.name.lstrip('./'); names.append(n)
        if m.name.startswith('/') or '..' in Path(m.name).parts: errors.append(f'unsafe path: {m.name}')
      required=['metadata/SHA256SUMS','metadata/README.txt']
      for r in required:
        if r not in names: errors.append(f'missing {r}')
      if 'metadata/SHA256SUMS' in names:
        manifest=t.extractfile(next(m for m in t.getmembers() if m.name.lstrip('./')=='metadata/SHA256SUMS'))
        if manifest is None: errors.append('cannot read metadata/SHA256SUMS')
        else:
          for line in manifest.read().decode('utf-8').splitlines():
            digest,rel=line.split(None,1); rel=rel.lstrip('*').lstrip('./')
            member=next((m for m in t.getmembers() if m.name.lstrip('./')==rel),None)
            if member is None: errors.append(f'checksum member missing: {rel}'); continue
            fh=t.extractfile(member)
            if fh is None or hashlib.sha256(fh.read()).hexdigest()!=digest: errors.append(f'checksum mismatch: {rel}')
      if not any('/ca/' in n or n.endswith('/ca_crt.pem') or '/puppetserver/ca/' in n for n in names): errors.append('CA material not found')
      if not any(n.endswith('/puppet.conf') for n in names): warnings.append('puppet.conf not found')
      if not any('/environments/' in n for n in names): warnings.append('deployed environments not found')
      if not any('/etc/sasd-puppet/eyaml/' in n for n in names): warnings.append('eyaml keys not present; acceptable when eyaml is disabled')
  except Exception as exc: errors.append(str(exc))
result={'schema_version':1,'checked_at_epoch':int(time.time()),'archive':str(a.archive),'ready':not errors,'errors':errors,'warnings':warnings,'member_count':len(names)}
text=json.dumps(result,indent=2,sort_keys=True)+'\n'
if a.output: a.output.write_text(text)
else: print(text,end='')
raise SystemExit(0 if not errors else 3)
