# Changelog

All notable changes are documented here. The format follows Keep a Changelog,
and versions use semantic versioning.

## [Unreleased]

### Planned

- Additional application groups and service/configuration stepstones.

## [0.2.0] - 2026-07-09

### Added

- Complete Milestone 2 standalone local-test operation.
- Safe Debian 12/13 and Ubuntu 24.04 bootstrap with distribution packages.
- r10k Puppetfile deployment, Git fast-forward update, status, and locking.
- First Hiera-driven administration package baseline.
- Managed `/etc/sasd/puppet-baseline.conf` EPP marker.
- Exact platform Hiera hierarchy and supported-platform rejection.
- Puppet 7.23 and Puppet 8.10 CI validation.
- RSpec-Puppet platform/resource tests and bootstrap fixtures.
- Disposable-container apply/idempotence integration workflow.
- English and German bootstrap, operation, baseline, platform, and rollback docs.
- ADRs for package source, resource boundary, and disabled agent service.

### Changed

- Module compatibility widened from Puppet 8-only to Puppet 7.23 through 8.x.
- Milestone 1 workload-free validation replaced by the Milestone 2 package/file scope gate.

## [0.1.0] - 2026-07-09

### Added

- Complete Milestone 1 Puppet control-repository foundation.
- Workload-free `role::baseline` and `profile::baseline` class chain.
- Hiera 5 data hierarchy, validation, tests, CI, and bilingual documentation.

## [0.0.0] - 2026-07-09

### Added

- Initial repository scaffold.
