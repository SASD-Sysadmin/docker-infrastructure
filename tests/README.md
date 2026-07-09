# Tests

Milestone 6 validation layers:

1. syntax, YAML/JSON/metadata, links, structure, and resource boundary;
2. deterministic package ownership and role-catalog parity;
3. RSpec-Puppet role/profile and report-processor tests;
4. fixture catalog compilation for supported agents;
5. bootstrap, CA, reporting, health, promotion, backup, application, and release smoke tests;
6. disposable-container baseline/application apply and idempotence checks;
7. tag-triggered release evidence generation and verification.

`bundle exec rake` runs the complete development suite. Smoke scripts are also
individually executable and avoid modifying the host by using dry-runs, fixtures,
temporary clones, and disposable containers.

## Milestone 7

`tests/smoke/redhat-family.sh` checks platform and package-source guards.
`tests/integration/redhat-package-availability.sh` installs the reviewed EL9
package groups in disposable Rocky Linux 9 and AlmaLinux 9 containers. Catalog
fixtures cover both operating systems without requiring repository credentials.
