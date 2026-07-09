#!/usr/bin/env python3
"""Enforce Milestone 7 boundaries: agent expansion, not security policy mutation."""
from __future__ import annotations
import pathlib,re,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
fail=[]
for path in list((ROOT/'manifests').rglob('*.pp'))+list((ROOT/'site-modules').rglob('*.pp')):
    text=path.read_text()
    for token in ('firewall {','selinux::','selboolean {','selmodule {'):
        if token.lower() in text.lower(): fail.append(f'{path.relative_to(ROOT)} contains forbidden Milestone 7 security-policy resource {token}')
for path in (ROOT/'scripts').rglob('*.sh'):
    text=path.read_text().lower()
    if re.search(r'\b(setenforce|semanage|setsebool|firewall-cmd)\b',text):
        fail.append(f'{path.relative_to(ROOT)} mutates SELinux/firewall state')
redhat=(ROOT/'data/os/family/RedHat.yaml').read_text().lower()
if 'epel' in '\n'.join(line for line in redhat.splitlines() if not line.lstrip().startswith('#')):
    fail.append('RedHat package data enables or installs EPEL')
server=(ROOT/'scripts/lib/common.sh').read_text()
server_case=re.search(r'is_supported_server_platform\(\).*?\n}',server,re.S)
if server_case and any(x in server_case.group(0) for x in ('rocky','almalinux')):
    fail.append('Milestone 7 must not add a RedHat-family Puppet Server')
if fail:
    print('\n'.join('ERROR: '+x for x in fail),file=sys.stderr); raise SystemExit(1)
print('Milestone 7 boundary passed: RedHat-family agents only; no EPEL, firewall, SELinux, or server expansion.')
