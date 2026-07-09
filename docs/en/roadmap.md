# Roadmap

## Milestone 1 — Control repository foundation — complete

Server-ready layout, workload-free role/profile catalog, Hiera foundation, validation, unit tests, local no-op runner, CI, and bilingual documentation.

## Next stepstones

The productive workload will be introduced in small, reviewable increments rather than as one oversized milestone. Candidate sequence:

1. supported-platform and package-policy decision;
2. Puppet Agent bootstrap for Debian/Ubuntu;
3. first harmless marker profile;
4. core administration package profile;
5. service/configuration consistency profile;
6. application groups and role composition;
7. Puppet Server and r10k deployment;
8. certificate operations, reporting, backups, and optional PuppetDB.

Every stepstone must define acceptance criteria, rollback behaviour, tests, no-op evidence, and English/German operational documentation.
