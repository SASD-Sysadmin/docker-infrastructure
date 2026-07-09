# Tests

Milestone 4 validation layers:

1. syntax, YAML/JSON/metadata, links, structure, and security boundary;
2. RSpec-Puppet role/profile and report-processor tests;
3. fixture catalog compilation for supported agents;
4. bootstrap, CA, reporting, health, promotion, and backup smoke tests;
5. disposable-container apply and idempotence checks.

`bundle exec rake` runs the complete development suite. Smoke scripts are also
individually executable and avoid modifying the host by using dry-runs/fixtures.
