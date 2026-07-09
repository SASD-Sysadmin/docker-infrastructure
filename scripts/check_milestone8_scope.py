#!/usr/bin/env python3
"""Enforce Milestone 8 operational assurance boundaries."""
from pathlib import Path
import re,sys
ROOT=Path(__file__).resolve().parents[1]; errors=[]
for p in list((ROOT/'scripts').glob('*'))+list((ROOT/'site-modules/profile').rglob('*')):
    if not p.is_file(): continue
    text=p.read_text(errors='ignore').lower()
    if p.name != 'check_milestone8_scope.py' and re.search(r'puppet\s+node\s+(delete|purge)|/pdb/admin/.+delete',text): errors.append(f'{p.relative_to(ROOT)} contains an immediate PuppetDB deletion command')
for p in (ROOT/'scripts').glob('*restore*'):
    if p.name!='prepare-rollback.sh': errors.append(f'unreviewed live restore script present: {p.name}')
if 'include_certname_labels' not in (ROOT/'config/operations-policy.json').read_text(): errors.append('monitoring contract lacks certname-label prohibition')
profile=(ROOT/'site-modules/profile/manifests/monitoring_bridge.pp').read_text()
for token in ('prometheus','grafana','node_exporter','firewall'):
    if re.search(rf"package\s*\{{[^}}]*{token}|service\s*\{{[^}}]*{token}",profile,re.S|re.I): errors.append(f'monitoring profile installs forbidden external component {token}')
if errors: print('\n'.join('ERROR: '+e for e in errors),file=sys.stderr); raise SystemExit(1)
print('Milestone 8 boundary passed: export and rehearsal only; no live restore, immediate history deletion, or monitoring-platform installation.')
