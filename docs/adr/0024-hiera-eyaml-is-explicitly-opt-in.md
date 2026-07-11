# ADR 0024: Hiera eyaml is explicitly opt-in

## Status
Accepted in Milestone 6.

## Decision
Milestone 6 provides a pinned hiera-eyaml installation workflow and hierarchy
template, but does not enable the encrypted hierarchy automatically. Private
keys stay outside Git and outside r10k environments.

## Consequences
Existing catalog compilation remains unchanged. Enabling secrets requires a
reviewed commit, compiler installation, key backup, catalog tests, and staged
promotion.
