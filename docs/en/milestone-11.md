# Milestone 11 — active encrypted Hiera data

Milestone 11 activates the previously prepared Hiera-eyaml layer and introduces
one deliberately narrow consumer: a machine-scoped, read-only APT repository
credential on Debian-family central agents.

## Delivered

- active per-node `eyaml_lookup_key` hierarchy;
- pinned `hiera-eyaml` 5.0.1 installation and key verification;
- `profile::apt_repository_credentials` and `role::apt_repository_client`;
- `Sensitive` automatic conversion and Sensitive EPP rendering;
- fixed root-only APT auth destination with `show_diff => false`;
- policy, encryption, key-staging, roundtrip, RSpec, smoke, and CI tests;
- key custody, rotation, recovery, and residual-risk runbooks.

## Boundary

The profile does not add repositories, import signing keys, install packages,
or accept an arbitrary file path. It is Debian-family-only and requires a
centrally authenticated agent. Private keys, CA keys, signing keys, human
passwords, and database master keys are prohibited.

Hiera-eyaml protects values in Git. `Sensitive` redacts logs and reports, but it
does not encrypt Puppet cached catalogs. The initial consumer is therefore
limited to a replaceable, machine-scoped, read-only package credential.
