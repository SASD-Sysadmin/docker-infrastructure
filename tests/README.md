# Tests

Milestone 2 has four layers:

1. static source and repository validation;
2. RSpec-Puppet catalog tests for Debian 12, Debian 13, and Ubuntu 24.04;
3. bootstrap dry-run tests using os-release fixtures;
4. optional disposable-container enforcement and idempotence tests.

Run the normal suite with `bundle exec rake`. Run a container integration test
with, for example, `tests/integration/container-baseline.sh debian:12`.
