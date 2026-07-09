# Changelog

All notable changes are documented here. The project follows semantic versioning for repository milestones.

## [0.3.0] - 2026-07-09

### Added

- Puppet Server bootstrap for Debian 12 and Ubuntu 24.04.
- Distribution and authenticated Puppet Core package-source modes.
- r10k configuration and explicit production deployment wrapper.
- `production` branch/environment release model.
- Central agent bootstrap and activation workflows.
- Manual list, sign, and clean certificate wrappers.
- Server status command, server/agent examples, and systemd deployment example.
- Allowlisted Hiera role classification.
- Central management mode and trusted certname in the baseline marker.
- English and German server, CA, deployment, backup, migration, network, and troubleshooting guides.
- Milestone 3 ADRs and dry-run tests.

### Security

- Autosigning explicitly disabled.
- Existing CA is preserved and never silently regenerated.
- Puppet Core credentials are accepted only through a restricted file.
- Agent service remains disabled until certificate review and activation.

## [0.2.0] - 2026-07-09

- Standalone local Puppet baseline for Debian 12/13 and Ubuntu 24.04.

## [0.1.0] - 2026-07-09

- Initial control-repository foundation.
