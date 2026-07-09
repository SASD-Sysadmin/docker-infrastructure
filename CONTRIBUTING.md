# Contributing

English is the leading repository language. Material operational documentation
must also receive an equivalent German update.

## Change workflow

1. branch from `main`;
2. keep roles free of direct resources;
3. put technical resources in focused profiles;
4. keep node/environment differences in Hiera;
5. add Puppet Strings comments, RSpec-Puppet tests, smoke tests, and rollback notes;
6. run `bundle exec rake`;
7. merge to `main` through review;
8. promote `main -> test -> production` with the repository script.

## Milestone 4 boundaries

Allowed direct resource types are package, file, service, and the single exact
refresh-only systemd daemon-reload exec in `profile::server_operations`.
Additional `exec`, user, group, mount, cron, firewall, or schedule resources
require a new ADR, tests, documentation, and explicit scope change.

Never force-push `test` or `production`, bypass test promotion, enable broad
autosigning, or add secrets/backups/reports to Git.
