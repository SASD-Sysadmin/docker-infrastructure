# Changelog

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
