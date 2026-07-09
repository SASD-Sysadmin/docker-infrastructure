# Tests

Milestone 1 uses three complementary levels:

1. static validation through `scripts/validate.sh`;
2. RSpec-Puppet unit compilation for `profile::baseline` and `role::baseline`;
3. a local no-op catalog test through `scripts/test-catalog.sh`.

The default catalog contains no workload resources. A successful test proves the repository wiring, not application installation. Integration tests in disposable machines will be introduced with productive profiles.
