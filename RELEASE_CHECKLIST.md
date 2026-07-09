# Release checklist

## Code and policy

- [ ] `VERSION`, module metadata, baseline marker, changelog, and documentation match.
- [ ] Package groups are sorted, unique, available, and owned by one profile.
- [ ] Role catalog matches `site.pp` and role manifests.
- [ ] No credentials, private keys, certificates, backups, database dumps, or generated modules are committed.
- [ ] Resource boundary and exact `exec` allowlist pass.

## Tests

- [ ] Puppet 7.23 and Puppet 8 CI jobs pass.
- [ ] RSpec-Puppet profile and role catalogs pass.
- [ ] Relevant disposable-container installation reaches an unchanged second run.
- [ ] Representative signed-node no-op has been reviewed.
- [ ] Test-environment apply and report health are successful.
- [ ] Backup verification and rollback preparation are current.

## Release

- [ ] `release-readiness.sh --strict --require-branch main` passes.
- [ ] Release file manifest is generated and verified.
- [ ] Annotated `v<VERSION>` tag points to the approved commit.
- [ ] `main -> test -> production` promotion is fast-forward only.
- [ ] Production deployment is performed manually with r10k.
- [ ] Post-deployment health, reports, agent convergence, and backup are confirmed.
