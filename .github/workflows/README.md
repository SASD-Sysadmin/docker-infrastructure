# GitHub Actions

`validate.yml` tests Puppet 7.23 and 8.10 on `main`, `test`, and `production`.
`integration.yml` applies the baseline twice in disposable Debian 12, Debian 13,
and Ubuntu 24.04 containers to detect non-idempotent changes.

Production deployment remains a manual, authenticated r10k operation; workflows
do not deploy directly to the Puppet Server.
