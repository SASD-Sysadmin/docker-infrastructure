# Changelog

All notable changes to this repository are documented here.

## [0.4.0] - 2026-07-09

### Added

- `main -> test -> production` fast-forward promotion workflow.
- `role::managed_agent` and `role::puppet_server`.
- `profile::agent_service` and `profile::server_operations`.
- compact `sasd_json` Puppet report processor.
- systemd control-plane health service and timer.
- agent scheduling, report status, health, promotion, rollback, backup, and backup-verification tools.
- guarded optional same-host PuppetDB/PostgreSQL bootstrap and status check.
- Milestone 4 smoke tests, RSpec-Puppet coverage, ADRs, and bilingual runbooks.

### Changed

- baseline version and site-module metadata to `0.4.0`.
- classification allowlist now accepts `baseline`, `managed_agent`, and `puppet_server`.
- validation boundary now permits package, file, service, and one exact refresh-only systemd reload command.
- CI watches `main`, `test`, and `production`.

### Security

- production promotion cannot skip the test branch or rewrite history.
- compact reports omit facts, logs, diffs, and resource values.
- control-plane backups are mode `0600`, checksummed, and explicitly documented as private-key material.
- PuppetDB is opt-in and blocked on unsupported server/platform/package combinations.

## [0.3.0] - 2026-07-09

- Central Puppet Server, r10k deployment, manual CA enrollment, and production branch.

## [0.2.0] - 2026-07-09

- Standalone local package/file baseline for Debian and Ubuntu.

## [0.1.0] - 2026-07-09

- Control-repository foundation, validation, and bilingual documentation.
