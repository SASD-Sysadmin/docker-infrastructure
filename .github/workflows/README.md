# GitHub Actions

`validate.yml` tests Puppet 7.23 and 8.10 on `main`, `test`, and `production`.
`integration.yml` applies the baseline twice in disposable Debian 12, Debian 13,
and Ubuntu 24.04 containers to detect non-idempotent changes.

Production deployment remains a manual, authenticated r10k operation; workflows
do not deploy directly to the Puppet Server.

## Milestone 6

`node-lifecycle.yml` validates the node-data contract, lifecycle transition
helper, inventory/compliance correlation, secret policy, eyaml preparation, and
decommission guards on pull requests and the three managed branches.

## Red Hat-family workflow

`redhat-family.yml` verifies the EL9 platform contract and installs all reviewed
application packages in Rocky Linux 9 and AlmaLinux 9 containers. It never uses
a Puppet Core API key and therefore does not install the Puppet agent itself.
Agent catalog compilation is covered by the normal Puppet/RSpec workflow.
