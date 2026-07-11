# Operating-system data

Supported agents: Debian 12, Debian 13, and Ubuntu 24.04 LTS. Supported central
server/PuppetDB bootstrap hosts: Debian 12 and Ubuntu 24.04 amd64. Family data
holds common package differences; release data documents tested package lines.

## Milestone 7 family mappings

Package names are complete per-family contracts:

- `family/Debian.yaml` covers Debian 12/13 and Ubuntu 24.04;
- `family/RedHat.yaml` covers AlmaLinux 9 and Rocky Linux 9.

Do not place cross-family package names in `data/common.yaml`. Exact OS files may
contain narrow overrides, but they must not silently enable EPEL or another
third-party repository.

## Milestone 10 .NET repository strategies

Exact OS data sets `profile::dotnet_sdk::repository_strategy`: `microsoft` for Debian 12/13 and `distribution` for Ubuntu 24.04, AlmaLinux 9, and Rocky Linux 9. Package names remain in family mappings.
