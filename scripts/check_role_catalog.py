#!/usr/bin/env python3
"""Verify that the machine-readable role catalog matches Puppet code."""
from __future__ import annotations
import json, pathlib, re, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
CATALOG=json.loads((ROOT/'config/role-catalog.json').read_text())
failures=[]
if CATALOG.get('version') != (ROOT/'VERSION').read_text().strip(): failures.append('role catalog version differs from VERSION')
site=(ROOT/'manifests/site.pp').read_text()
for role,meta in CATALOG.get('roles',{}).items():
    if f"'{role}'" not in site: failures.append(f'site.pp does not allowlist {role}')
    path=ROOT/'site-modules/role/manifests'/f'{role}.pp'
    if not path.is_file(): failures.append(f'missing role manifest: {path.relative_to(ROOT)}'); continue
    text=path.read_text()
    for profile in meta.get('profiles',[]):
        if profile == 'application_state': token="profile::application_state"
        else: token=f"profile::{profile}"
        if token not in text: failures.append(f'role {role} does not compose {token}')
actual=set(re.findall(r"^class role::([a-z0-9_]+)", '\n'.join(p.read_text() for p in (ROOT/'site-modules/role/manifests').glob('*.pp')), re.M))
actual.discard('init')
expected=set(CATALOG.get('roles',{}))
if actual != expected: failures.append(f'role catalog mismatch: manifests={sorted(actual)}, catalog={sorted(expected)}')
if failures:
    print('\n'.join('ERROR: '+x for x in failures),file=sys.stderr); raise SystemExit(1)
print(f"Role catalog passed for {len(expected)} roles.")
