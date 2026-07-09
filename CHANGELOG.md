# Changelog

## [0.9.0] - 2026-07-09

### Added

- OpenJDK 17/Maven and distribution PHP SDK profiles;
- Java, PHP, and polyglot development roles;
- machine-readable SDK catalog and local SDK status command;
- cross-platform package availability workflow, RSpec, smoke tests, ADRs, and bilingual runbooks.

### Changed

- repository and module versions are 0.9.0;
- package policy now validates Java and PHP SDK groups for both OS families;
- role catalog and classification allowlist include three explicit SDK roles.

### Security

- SDK profiles use configured distribution repositories only;
- Composer remains Debian-family-only;
- .NET, EPEL, SDKMAN, upstream installers, PHP web services, alternatives, and EL9 module-stream changes remain out of scope.

## [0.8.0] - 2026-07-09

### Added

- low-cardinality monitoring bridge with Prometheus, JSON, and Nagios-compatible output;
- no-secret audit evidence bundles with internal and external SHA-256 verification;
- backup metadata, recovery readiness inspection, and isolated recovery rehearsal;
- read-only upgrade preflight and machine-readable operations policy;
- reviewed PuppetDB retention candidate and guarded node deactivation;
- Milestone 8 Puppet profile, RSpec, smoke tests, CI, ADRs, and bilingual runbooks.

### Changed

- repository and module versions are 0.8.0;
- Puppet Server role now includes the monitoring bridge;
- control-plane backups include `/etc/sasd-puppet` when present and structured backup metadata.

### Security

- monitoring metrics exclude certname labels;
- audit bundles exclude private keys and secret values;
- recovery tooling cannot restore live paths;
- PuppetDB immediate deletion and automatic upgrades remain disabled.

## [0.7.0] - 2026-07-09

### Added

- AlmaLinux 9 and Rocky Linux 9 central-agent support on x86_64 and aarch64;
- authenticated Puppet Core RPM repository setup with protected credentials;
- complete Debian-family and RedHat-family Hiera package mappings;
- machine-readable platform catalog and cross-code parity checker;
- non-secret platform-state marker and profile;
- EL9 facts/os-release fixtures, RSpec coverage, package availability workflow, ADRs, and bilingual runbooks.

### Changed

- repository and module versions are 0.7.0;
- application package names moved from common data to OS-family data;
- central roles now include `profile::platform_state`;
- validation now enforces platform, package-source, SELinux/firewall, and agent-only EL9 boundaries.

### Security

- EL9 agents require a root-owned Puppet Core API-key file and a mode-0600 repository file;
- EPEL, SELinux changes, firewall changes, and RedHat-family Puppet Server installation remain out of scope.

## [0.6.0] - 2026-07-09

### Added

- reviewed active, maintenance, and retired node lifecycle states;
- lifecycle-aware agent service and local lifecycle marker;
- node registration, inventory, compliance, and guarded decommission tools;
- machine-readable node-data contract and validation;
- opt-in Hiera eyaml 5.0.1 setup and hierarchy candidate;
- tracked-file secret policy scanning;
- Milestone 6 RSpec, smoke, CI, ADR, English, and German documentation.

### Changed

- all central roles now compose `profile::lifecycle_state`;
- repository and module versions are 0.6.0;
- Python bytecode is no longer shipped in release archives.

All notable changes to this repository are documented here.

## [0.5.0] - 2026-07-09

### Added

- administration, development, and daemonless OCI application profiles;
- explicit server, development, and container-host roles;
- non-secret application-assignment marker;
- machine-readable role catalog and parity checker;
- deterministic package-policy checker;
- release readiness, file-manifest generation, and manifest verification;
- application-profile container workflow and tag release-artifact workflow;
- expanded RSpec-Puppet tests, smoke tests, ADRs, and bilingual runbooks.

### Changed

- baseline and site-module versions to `0.5.0`;
- Puppet Server role now includes administration tools;
- managed central roles record intended application profiles;
- repository validation now enforces the Milestone 5 application/release contract.

### Security

- package groups use only configured distribution repositories and do not pin arbitrary upstream versions;
- role data cannot dynamically include Puppet classes;
- release manifests provide per-file SHA-256 integrity evidence;
- secrets and arbitrary repair commands remain outside scope.

## [0.4.0] - 2026-07-09

- Central promotion, regular agents, compact reporting, health, verified backups, rollback preparation, and optional PuppetDB.

## [0.3.0] - 2026-07-09

- Central Puppet Server, r10k deployment, manual CA enrollment, and production branch.

## [0.2.0] - 2026-07-09

- Standalone local package/file baseline for Debian and Ubuntu.

## [0.1.0] - 2026-07-09

- Control-repository foundation, validation, and bilingual documentation.
