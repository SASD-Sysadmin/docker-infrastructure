# Tests

Milestone 3 has five layers:

1. static source, secret, link, and repository validation;
2. RSpec-Puppet catalog tests on all supported agent platforms;
3. local, central-agent, and Puppet Server bootstrap dry-runs;
4. fixture catalog compilation with Puppet 7 and Puppet 8;
5. optional disposable-container baseline enforcement/idempotence tests.

Run `bundle exec rake`. Server installation itself is intentionally not executed
in public CI because current Puppet Core packages can require credentials and a
real CA lifecycle must not be created in an untrusted runner.
