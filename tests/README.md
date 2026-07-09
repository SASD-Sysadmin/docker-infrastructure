# Tests

Milestone 9 validation layers:

1. syntax, YAML/JSON/metadata, links, structure, and resource boundaries;
2. deterministic package ownership, platform policy, SDK policy, and role-catalog parity;
3. RSpec-Puppet role/profile and report-processor tests;
4. fixture catalog compilation for supported agents;
5. bootstrap, CA, reporting, health, promotion, backup, application, SDK, lifecycle, and release smoke tests;
6. disposable-container baseline/application/SDK package and idempotence checks;
7. tag-triggered release evidence generation and verification.

`bundle exec rake` runs the complete development suite. Smoke scripts are also
individually executable and avoid modifying the host by using dry-runs, fixtures,
temporary clones, and disposable containers.

## Milestone 7

`tests/smoke/redhat-family.sh` checks platform and package-source guards.
`tests/integration/redhat-package-availability.sh` installs reviewed EL9 package
groups in disposable Rocky Linux 9 and AlmaLinux 9 containers. Catalog fixtures
cover both operating systems without requiring repository credentials.

## Milestone 8

Smoke tests cover monitoring export, no-secret audit bundles, isolated recovery
rehearsal, upgrade preflight, and PuppetDB retention/deactivation guards.

## Milestone 9

`tests/smoke/sdk-profiles.sh` verifies the SDK catalog, role composition, and
OS-family package mappings. `tests/smoke/sdk-status.sh` verifies the local SDK
status helper without installing software. `tests/integration/sdk-package-availability.sh`
checks Java and PHP package availability in disposable supported-platform images.
