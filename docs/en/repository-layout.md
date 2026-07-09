# Repository layout

Important Milestone 3 paths:

```text
manifests/site.pp                  allowlisted classification
data/                              Hiera policy and node data
site-modules/{role,profile}/       SASD-owned Puppet code
modules/                           r10k-generated dependencies (ignored)
scripts/bootstrap-server.sh       fresh central server bootstrap
scripts/deploy-environment.sh      manual locked r10k deployment
scripts/bootstrap-central-agent.sh CSR submission and agent configuration
scripts/activate-central-agent.sh  signed-certificate activation
scripts/*certificate.sh            CA operator wrappers
examples/{server,agent}/           non-secret configuration examples
systemd/                           optional reviewed unit example
tests/                             unit, fixture, dry-run, integration tests
docs/{en,de}/                      bilingual operations documentation
docs/adr/                          architecture decisions
```
