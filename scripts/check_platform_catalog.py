#!/usr/bin/env python3
"""Verify the Milestone 7 platform matrix, Hiera mappings, and code parity."""
from __future__ import annotations
import json,pathlib,re,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
CAT=json.loads((ROOT/'config/platform-catalog.json').read_text())
VERSION=(ROOT/'VERSION').read_text().strip()
fail=[]
if CAT.get('version')!=VERSION: fail.append('platform catalog version differs from VERSION')
expected={'debian-12','debian-13','ubuntu-24.04','almalinux-9','rocky-9'}
actual=set(CAT.get('platforms',{}))
if actual!=expected: fail.append(f'platform keys differ: {sorted(actual)}')
for key,meta in CAT.get('platforms',{}).items():
    path=ROOT/meta.get('hiera_data','')
    if not path.is_file(): fail.append(f'{key}: missing Hiera file {meta.get("hiera_data")}')
    if not meta.get('architectures'): fail.append(f'{key}: no architectures')
    if meta.get('os_family')=='RedHat':
        if meta.get('package_sources')!=['puppet-core']: fail.append(f'{key}: RedHat agents must require puppet-core')
        if meta.get('standalone_local'): fail.append(f'{key}: standalone local mode must be false')
common=(ROOT/'scripts/lib/common.sh').read_text()
for token in ('almalinux:9','rocky:9'):
    if token not in common: fail.append(f'common.sh missing {token}')
bootstrap=(ROOT/'scripts/bootstrap-central-agent.sh').read_text()
for marker in ('configure_puppet_core_yum','dnf --assumeyes install puppet-agent','require --package-source puppet-core'):
    if marker not in bootstrap: fail.append(f'central bootstrap missing required marker {marker}')
for rel in ('data/os/family/Debian.yaml','data/os/family/RedHat.yaml'):
    text=(ROOT/rel).read_text()
    for key in ('profile::baseline::packages','profile::administration_tools::packages','profile::development_tools::packages','profile::container_tools::packages'):
        if key not in text: fail.append(f'{rel} missing {key}')

server_role=(ROOT/'site-modules/role/manifests/puppet_server.pp').read_text()
for marker in ("$os_name == 'Debian'", "$os_name == 'Ubuntu'", 'Debian 12 and Ubuntu 24.04 only'):
    if marker not in server_role: fail.append(f'puppet_server role missing platform guard {marker}')

for rel in ('baseline.pp','administration_tools.pp','development_tools.pp','container_tools.pp'):
    text=(ROOT/'site-modules/profile/manifests'/rel).read_text()
    for token in ("'AlmaLinux'", "'Rocky'"):
        if token not in text: fail.append(f'{rel} missing {token}')
if fail:
    print('\n'.join('ERROR: '+x for x in fail),file=sys.stderr); raise SystemExit(1)
print(f'Platform catalog passed for {len(actual)} platforms and two OS-family package maps.')
