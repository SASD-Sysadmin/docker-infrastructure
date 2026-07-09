#!/usr/bin/env python3
"""Check the Milestone 4 structural, version, and security contract."""
from __future__ import annotations
import json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
REQUIRED=(
 'README.md','README.de.md','LICENSE','VERSION','Puppetfile','environment.conf','hiera.yaml','manifests/site.pp',
 'site-modules/profile/metadata.json','site-modules/profile/manifests/baseline.pp','site-modules/profile/manifests/agent_service.pp','site-modules/profile/manifests/server_operations.pp',
 'site-modules/role/metadata.json','site-modules/role/manifests/baseline.pp','site-modules/role/manifests/managed_agent.pp','site-modules/role/manifests/puppet_server.pp',
 'site-modules/sasd_reporting/metadata.json','site-modules/sasd_reporting/lib/puppet/reports/sasd_json.rb',
 'scripts/configure-agent-service.sh','scripts/configure-reporting.sh','scripts/server-health.sh','scripts/report-status.py',
 'scripts/promote-environment.sh','scripts/prepare-rollback.sh','scripts/backup-control-plane.sh','scripts/verify-backup.sh',
 'scripts/bootstrap-puppetdb.sh','scripts/status-puppetdb.sh','scripts/check_milestone4_scope.py',
 'docs/en/milestone-4.md','docs/de/milestone-4.md','docs/en/operational-model.md','docs/de/operational-model.md',
 'tests/smoke/operations-dry-run.sh','tests/smoke/report-status.sh','tests/smoke/promotion-guards.sh','tests/smoke/backup-verification.sh',
)
EXECUTABLE=tuple(x for x in REQUIRED if x.startswith('scripts/') or x.startswith('tests/'))

def fail(msg: str) -> None: print(f'ERROR: {msg}',file=sys.stderr)
def main() -> int:
    failures=0
    for rel in REQUIRED:
        if not (ROOT/rel).is_file(): fail(f'missing required file: {rel}'); failures+=1
    version=(ROOT/'VERSION').read_text().strip()
    if version!='0.4.0': fail('VERSION must be 0.4.0 for Milestone 4'); failures+=1
    for rel in ('site-modules/profile/metadata.json','site-modules/role/metadata.json','site-modules/sasd_reporting/metadata.json'):
        try:
            d=json.loads((ROOT/rel).read_text())
            if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
            if not d.get('name','').startswith('sasd-'): fail(f'{rel}: module name must use sasd namespace'); failures+=1
        except Exception as exc: fail(f'{rel}: {exc}'); failures+=1
    common=(ROOT/'data/common.yaml').read_text()
    for token in ("sasd::role: baseline",f"profile::baseline::baseline_version: '{version}'",'profile::agent_service::service_name'):
        if token not in common: fail(f'data/common.yaml missing {token}'); failures+=1
    site=(ROOT/'manifests/site.pp').read_text()
    for token in ("'baseline'","'managed_agent'","'puppet_server'",'include role::managed_agent','include role::puppet_server'):
        if token not in site: fail(f'site.pp missing classification token: {token}'); failures+=1
    for rel in EXECUTABLE:
        p=ROOT/rel
        if p.exists() and not (p.stat().st_mode & 0o111): fail(f'required script is not executable: {rel}'); failures+=1
    forbidden_suffix={'.pem','.key','.p12','.pfx','.jks','.keystore','.dump'}
    forbidden_names=('puppet-control-plane-','.tar.gz','.api-key')
    for p in ROOT.rglob('*'):
        if '.git' in p.parts or not p.is_file(): continue
        rel=str(p.relative_to(ROOT))
        if p.suffix.lower() in forbidden_suffix: fail(f'potential secret material: {rel}'); failures+=1
        if any(token in p.name for token in forbidden_names): fail(f'backup/credential-like file committed: {rel}'); failures+=1
    processor=(ROOT/'site-modules/sasd_reporting/lib/puppet/reports/sasd_json.rb').read_text()
    for forbidden in ('self.to_yaml','logs:', 'facts:'):
        if forbidden in processor: fail(f'report processor contains forbidden full-report field/serialization: {forbidden}'); failures+=1
    if failures: print(f'Repository validation failed with {failures} error(s).',file=sys.stderr); return 1
    print('Milestone 4 repository structure validation passed.'); return 0
if __name__=='__main__': raise SystemExit(main())
