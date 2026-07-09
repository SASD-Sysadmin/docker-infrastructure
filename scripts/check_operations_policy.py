#!/usr/bin/env python3
"""Validate the Milestone 8 operational assurance policy."""
from __future__ import annotations
import json,re,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
path=ROOT/'config/operations-policy.json'
errors=[]
try: data=json.loads(path.read_text())
except Exception as exc: print(f'ERROR: {path}: {exc}',file=sys.stderr); raise SystemExit(1)
if data.get('schema_version')!=1: errors.append('schema_version must be 1')
if data.get('version')!=(ROOT/'VERSION').read_text().strip(): errors.append('policy version must match VERSION')
mon=data.get('monitoring',{})
if mon.get('include_certname_labels') is not False: errors.append('monitoring must not expose certname labels')
for section,key in [('monitoring','max_report_age_seconds'),('backup','maximum_age_seconds'),('upgrade','minimum_free_mib'),('upgrade','maximum_backup_age_seconds')]:
    if not isinstance(data.get(section,{}).get(key),int) or data[section][key]<=0: errors.append(f'{section}.{key} must be a positive integer')
ttl=re.compile(r'^[1-9][0-9]*(ms|s|m|h|d)$')
for key in ('node_ttl','node_purge_ttl','report_ttl','resource_events_ttl'):
    if not ttl.fullmatch(str(data.get('puppetdb',{}).get(key,''))): errors.append(f'puppetdb.{key} has invalid TTL')
if data.get('puppetdb',{}).get('immediate_delete') is not False: errors.append('immediate PuppetDB deletion must remain disabled')
if data.get('audit',{}).get('include_private_keys') is not False or data.get('audit',{}).get('include_secret_values') is not False: errors.append('audit bundle must exclude private keys and secret values')
if errors:
    print('\n'.join('ERROR: '+e for e in errors),file=sys.stderr); raise SystemExit(1)
print('Milestone 8 operations policy validation passed.')
