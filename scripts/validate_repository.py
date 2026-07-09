#!/usr/bin/env python3
"""Check the Milestone 6 structural, version, lifecycle, and security contract."""
from __future__ import annotations
import json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
REQUIRED=(
 'README.md','README.de.md','LICENSE','VERSION','Puppetfile','environment.conf','hiera.yaml','manifests/site.pp',
 'config/role-catalog.json','config/node-data-contract.json','config/hiera-eyaml.yaml.example',
 'data/common.yaml','data/nodes/README.md','data/retired/README.md','secrets/README.md','secrets/.gitignore',
 'site-modules/profile/metadata.json','site-modules/profile/manifests/lifecycle_state.pp','site-modules/profile/templates/lifecycle.conf.epp',
 'site-modules/profile/manifests/agent_service.pp','site-modules/role/metadata.json','site-modules/sasd_reporting/metadata.json',
 'scripts/manage-node.rb','scripts/check_node_data.rb','scripts/node-inventory.rb','scripts/fleet-compliance.rb','scripts/decommission-node.sh',
 'scripts/setup-hiera-eyaml.sh','scripts/prepare-hiera-eyaml.sh','scripts/check_secret_policy.py','scripts/check_milestone6_scope.py',
 'docs/en/milestone-6.md','docs/de/milestone-6.md','docs/en/node-lifecycle.md','docs/de/node-lifecycle.md',
 'docs/en/inventory-and-compliance.md','docs/de/inventory-and-compliance.md','docs/en/maintenance-windows.md','docs/de/maintenance-windows.md',
 'docs/en/decommissioning.md','docs/de/decommissioning.md','docs/en/secure-data-foundation.md','docs/de/secure-data-foundation.md',
 'docs/en/milestone-6-runbook.md','docs/de/milestone-6-runbook.md',
 'tests/smoke/node-lifecycle.sh','tests/smoke/inventory-compliance.sh','tests/smoke/secret-policy.sh','tests/smoke/decommission-guards.sh',
)
EXECUTABLE=tuple(x for x in REQUIRED if x.startswith('scripts/') or x.startswith('tests/'))
def fail(msg): print(f'ERROR: {msg}',file=sys.stderr)
def main():
    failures=0
    for rel in REQUIRED:
        if not (ROOT/rel).is_file(): fail(f'missing required file: {rel}'); failures+=1
    version=(ROOT/'VERSION').read_text().strip()
    if version!='0.6.0': fail('VERSION must be 0.6.0 for Milestone 6'); failures+=1
    for rel in ('site-modules/profile/metadata.json','site-modules/role/metadata.json','site-modules/sasd_reporting/metadata.json'):
        try:
            d=json.loads((ROOT/rel).read_text())
            if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
            if not d.get('name','').startswith('sasd-'): fail(f'{rel}: module name must use sasd namespace'); failures+=1
        except Exception as exc: fail(f'{rel}: {exc}'); failures+=1
    for rel in ('config/role-catalog.json','config/node-data-contract.json'):
        d=json.loads((ROOT/rel).read_text())
        if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
    common=(ROOT/'data/common.yaml').read_text()
    for token in ("sasd::role: baseline","sasd::lifecycle_state: active",f"profile::baseline::baseline_version: '{version}'"):
        if token not in common: fail(f'data/common.yaml missing {token}'); failures+=1
    site=(ROOT/'manifests/site.pp').read_text()
    for state in ('active','maintenance','retired'):
        if f"'{state}'" not in site: fail(f'site.pp missing lifecycle state {state}'); failures+=1
    if 'No catalog is compiled' not in site: fail('site.pp lacks explicit retired-node compilation stop'); failures+=1
    for rel in EXECUTABLE:
        p=ROOT/rel
        if p.exists() and not (p.stat().st_mode & 0o111): fail(f'required script not executable: {rel}'); failures+=1
    forbidden_suffix={'.pem','.key','.p12','.pfx','.jks','.keystore','.dump'}
    for p in ROOT.rglob('*'):
        if '.git' in p.parts or not p.is_file(): continue
        rel=str(p.relative_to(ROOT))
        if p.suffix.lower() in forbidden_suffix: fail(f'potential secret material: {rel}'); failures+=1
    if failures: print(f'Repository validation failed with {failures} error(s).',file=sys.stderr); return 1
    print('Milestone 6 repository structure validation passed.'); return 0
if __name__=='__main__': raise SystemExit(main())
