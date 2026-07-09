# Milestone 5: Application Baselines and Release Assurance

Milestone 5 completes the first planned repository cycle. It turns the central operating foundation into a useful application-installation baseline while preserving narrow safety boundaries.

## Delivered

- administration, development, and daemonless OCI package profiles;
- explicit `server`, `development`, and `container_host` roles;
- application-assignment marker under `/etc/sasd/applications.d`;
- machine-readable role catalog and parity check;
- deterministic package-policy validation;
- RSpec-Puppet coverage for every new profile and role;
- disposable-container profile/idempotence workflow;
- deterministic release file manifest and verifier;
- release-readiness gate and checklist;
- tag-triggered release-artifact workflow;
- English and German implementation/operations documentation.

## Safety boundary

Milestone 5 continues to allow only Puppet `package`, `file`, `service`, and the exact refresh-only systemd daemon-reload `exec` introduced earlier. Application profiles install packages only. They do not add repositories, pin upstream versions, start application daemons, configure registries, pull images, create containers, manage users, or hold secrets.

## Definition of done

Milestone 5 is complete when all role/profile mappings are validated, package groups are unique and deterministic, catalogs compile on supported facts, container integration tests converge twice, the release readiness gate passes, and an independently verifiable archive can be produced from the tagged commit.
