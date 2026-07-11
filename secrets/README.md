# Encrypted Hiera data

Milestone 11 activates the per-node Hiera-eyaml hierarchy. Private PKCS7 keys
remain outside Git under `/etc/sasd-puppet/eyaml`; only encrypted `.eyaml`
values may be committed under `secrets/nodes/` after review.

The initial consumer is deliberately narrow: one machine-scoped, read-only APT
repository password for `role::apt_repository_client`. Hiera-eyaml protects the
repository copy, while Puppet `Sensitive` redacts logs and reports. The clear
value can still exist in cached catalogs, so compiler and agent state remains
root-only and high-value keys are prohibited.

See `docs/en/hiera-eyaml-operations.md` or the German counterpart.
