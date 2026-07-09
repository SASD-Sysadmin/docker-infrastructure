#!/usr/bin/env python3
"""Reject private keys and likely plaintext credentials in tracked content."""
from __future__ import annotations
import pathlib,re,subprocess,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
try:
    files=subprocess.check_output(['git','-C',str(ROOT),'ls-files','-z']).split(b'\0')
    paths=[ROOT/pathlib.Path(x.decode()) for x in files if x]
except Exception:
    paths=[p for p in ROOT.rglob('*') if p.is_file() and '.git' not in p.parts]
failures=[]
private_markers=tuple(('BEGIN'+((' '+kind) if kind else '')+' PRIVATE KEY').encode() for kind in ('','RSA','OPENSSH','EC'))
credential_key=re.compile(r'(?im)^\s*[^#\n]*(password|passwd|api[_-]?key|secret|token)\s*:\s*["\']?([^\s"\'][^\n]*)$')
allowed_placeholder=('REPLACE_WITH_REAL_ENCRYPTED_VALUE','ENC[PKCS7,')
for path in paths:
    rel=path.relative_to(ROOT)
    if any(part in {'vendor','modules','dist'} for part in rel.parts): continue
    try: raw=path.read_bytes()
    except OSError: continue
    if any(marker in raw for marker in private_markers): failures.append(f'{rel}: private key material')
    if path.suffix.lower() in {'.pem','.key','.p12','.pfx','.jks','.keystore'}: failures.append(f'{rel}: forbidden secret-bearing extension')
    if b'\0' in raw: continue
    text=raw.decode('utf-8','replace')
    for m in credential_key.finditer(text):
        value=m.group(2).strip()
        line=m.group(0)
        if any(token in line for token in allowed_placeholder): continue
        if value in {'','null','~','REDACTED','CHANGEME'}: continue
        failures.append(f'{rel}: likely plaintext credential key {m.group(1)}')
if failures:
    print('\n'.join('ERROR: '+x for x in sorted(set(failures))),file=sys.stderr); raise SystemExit(1)
print(f'Secret policy passed for {len(paths)} tracked file(s).')
