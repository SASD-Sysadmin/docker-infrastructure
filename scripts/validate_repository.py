#!/usr/bin/env python3
"""Check the Milestone 5 structural, version, and security contract."""
from __future__ import annotations
import json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
REQUIRED=(
 'README.md','README.de.md','LICENSE','VERSION','Puppetfile','environment.conf','hiera.yaml','manifests/site.pp','config/role-catalog.json',
 'site-modules/profile/metadata.json','site-modules/profile/manifests/baseline.pp','site-modules/profile/manifests/administration_tools.pp','site-modules/profile/manifests/development_tools.pp','site-modules/profile/manifests/container_tools.pp','site-modules/profile/manifests/application_state.pp','site-modules/profile/manifests/agent_service.pp','site-modules/profile/manifests/server_operations.pp',
 'site-modules/role/metadata.json','site-modules/role/manifests/baseline.pp','site-modules/role/manifests/managed_agent.pp','site-modules/role/manifests/server.pp','site-modules/role/manifests/development.pp','site-modules/role/manifests/container_host.pp','site-modules/role/manifests/puppet_server.pp',
 'site-modules/sasd_reporting/metadata.json','site-modules/sasd_reporting/lib/puppet/reports/sasd_json.rb',
 'scripts/check_package_policy.rb','scripts/check_role_catalog.py','scripts/generate-release-manifest.py','scripts/verify-release-manifest.py','scripts/release-readiness.sh','scripts/check_milestone5_scope.py',
 'docs/en/milestone-5.md','docs/de/milestone-5.md','docs/en/application-profiles.md','docs/de/application-profiles.md','docs/en/role-catalog.md','docs/de/role-catalog.md','docs/en/release-assurance.md','docs/de/release-assurance.md','docs/en/milestone-5-runbook.md','docs/de/milestone-5-runbook.md',
 'tests/smoke/application-policy.sh','tests/smoke/role-catalog.sh','tests/smoke/release-manifest.sh','tests/smoke/release-readiness.sh',
 '.github/workflows/release.yml','.github/workflows/application-profiles.yml','RELEASE_CHECKLIST.md',
)
EXECUTABLE=tuple(x for x in REQUIRED if x.startswith('scripts/') or x.startswith('tests/'))
def fail(msg): print(f'ERROR: {msg}',file=sys.stderr)
def main():
    failures=0
    for rel in REQUIRED:
        if not (ROOT/rel).is_file(): fail(f'missing required file: {rel}'); failures+=1
    version=(ROOT/'VERSION').read_text().strip()
    if version!='0.5.0': fail('VERSION must be 0.5.0 for Milestone 5'); failures+=1
    for rel in ('site-modules/profile/metadata.json','site-modules/role/metadata.json','site-modules/sasd_reporting/metadata.json'):
        try:
            d=json.loads((ROOT/rel).read_text())
            if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
            if not d.get('name','').startswith('sasd-'): fail(f'{rel}: module name must use sasd namespace'); failures+=1
        except Exception as exc: fail(f'{rel}: {exc}'); failures+=1
    common=(ROOT/'data/common.yaml').read_text()
    for token in ("sasd::role: baseline",f"profile::baseline::baseline_version: '{version}'",'profile::administration_tools::packages','profile::development_tools::packages','profile::container_tools::packages'):
        if token not in common: fail(f'data/common.yaml missing {token}'); failures+=1
    site=(ROOT/'manifests/site.pp').read_text()
    for role in ('baseline','managed_agent','server','development','container_host','puppet_server'):
        if f"'{role}'" not in site or f'include role::{role}' not in site: fail(f'site.pp missing role {role}'); failures+=1
    for rel in EXECUTABLE:
        p=ROOT/rel
        if p.exists() and not (p.stat().st_mode & 0o111): fail(f'required script not executable: {rel}'); failures+=1
    forbidden_suffix={'.pem','.key','.p12','.pfx','.jks','.keystore','.dump'}
    forbidden_names=('puppet-control-plane-','.tar.gz','.api-key')
    for p in ROOT.rglob('*'):
        if '.git' in p.parts or not p.is_file(): continue
        rel=str(p.relative_to(ROOT))
        if p.suffix.lower() in forbidden_suffix: fail(f'potential secret material: {rel}'); failures+=1
        if any(token in p.name for token in forbidden_names): fail(f'backup/credential-like file committed: {rel}'); failures+=1
    if failures: print(f'Repository validation failed with {failures} error(s).',file=sys.stderr); return 1
    print('Milestone 5 repository structure validation passed.'); return 0
if __name__=='__main__': raise SystemExit(main())
