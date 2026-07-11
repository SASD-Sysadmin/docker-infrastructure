# Milestone 7 — Red Hat-family agents and cross-platform package data

Milestone 7 extends the central-agent fleet to AlmaLinux 9 and Rocky Linux 9 while preserving the repository's conservative trust boundaries. Puppet Server remains on Debian 12 or Ubuntu 24.04. Red Hat-family nodes are agents only.

## Delivered

- central-agent bootstrap for AlmaLinux 9 and Rocky Linux 9 on x86_64 and aarch64;
- authenticated Puppet Core RPM-repository setup with root-only credentials;
- full Debian-family and RedHat-family package maps in Hiera;
- a machine-readable platform catalog and parity checks;
- a non-secret `/etc/sasd/platform.d/current.conf` platform marker;
- fixture catalogs, RSpec coverage, package-availability integration tests, CI, ADRs, and runbooks;
- explicit boundaries excluding EPEL, SELinux mutation, firewall mutation, and a Red Hat-family Puppet Server.

## Trust boundary

The release RPM is downloaded over HTTPS from the public Puppet Core endpoint. Package downloads require a Puppet Forge API key stored in a root-owned file. The bootstrap writes credentials only to the generated Puppet repository file and changes its mode to `0600`. The key is never accepted as a command-line value and must never be committed.

## Supported central agents

| Platform | Architectures | Distribution packages | Puppet Core |
|---|---|---:|---:|
| Debian 12 | x86_64, aarch64 | yes | yes |
| Debian 13 | x86_64, aarch64 | yes | yes |
| Ubuntu 24.04 | x86_64, aarch64 | yes | yes |
| AlmaLinux 9 | x86_64, aarch64 | no | required |
| Rocky Linux 9 | x86_64, aarch64 | no | required |

Standalone local `puppet apply` bootstrap remains limited to Debian and Ubuntu. This avoids pretending that a credential-free EL9 agent source exists.

## Out of scope

- Puppet Server on AlmaLinux or Rocky Linux;
- RHEL, Oracle Linux, CentOS Stream, Amazon Linux, or EL10;
- EPEL or third-party application repositories;
- SELinux policy modules, booleans, permissive mode, or exceptions;
- firewalld rules or network policy;
- automatic API-key rotation.
