# ADR 0019: Distribution security updates over exact package pins

## Decision
Generic application profiles use `ensure => installed` rather than exact package versions.

## Consequences
Normal distribution security upgrades remain possible. Exact pinning requires a narrowly documented exception with repository, compatibility, and rollback tests.
