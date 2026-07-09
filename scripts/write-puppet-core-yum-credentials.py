#!/usr/bin/env python3
"""Atomically inject Puppet Core credentials into a generated Yum repo file."""
from __future__ import annotations
import argparse, os, pathlib, re, tempfile


def parse_args() -> argparse.Namespace:
    parser=argparse.ArgumentParser()
    parser.add_argument('--api-key-file',required=True,type=pathlib.Path)
    parser.add_argument('--repository-file',required=True,type=pathlib.Path)
    return parser.parse_args()


def main() -> int:
    args=parse_args()
    key=args.api_key_file.read_text(encoding='utf-8').strip()
    if not key or any(ch.isspace() for ch in key):
        raise SystemExit('API key must be one non-empty token without whitespace')
    text=args.repository_file.read_text(encoding='utf-8')
    text,user_count=re.subn(r'(?m)^\s*#?username\s*=.*$', 'username=forge-key', text)
    text,password_count=re.subn(r'(?m)^\s*#?password\s*=.*$', 'password='+key, text)
    if user_count < 1 or password_count < 1:
        raise SystemExit('release repository file has no username/password credential placeholders')
    fd,tmp=tempfile.mkstemp(prefix=args.repository_file.name+'.',dir=args.repository_file.parent)
    try:
        with os.fdopen(fd,'w',encoding='utf-8') as handle:
            handle.write(text)
            handle.flush(); os.fsync(handle.fileno())
        os.chmod(tmp,0o600)
        os.replace(tmp,args.repository_file)
    finally:
        if os.path.exists(tmp): os.unlink(tmp)
    print(f'Updated Puppet Core repository credentials in {args.repository_file}')
    return 0

if __name__=='__main__':
    raise SystemExit(main())
