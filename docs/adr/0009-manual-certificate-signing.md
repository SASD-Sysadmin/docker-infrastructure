# ADR 0009: Manual certificate signing

- Status: Accepted
- Date: 2026-07-09

## Decision

Disable autosigning and require exact, operator-reviewed certname signing.

## Rationale

Basic autosigning trusts a name asserted by the requester. Manual review is appropriate for the small SASD environment and makes identity admission explicit.

## Consequences

Enrollment requires two administrative steps. Automation may later use policy-based signing only after a separate threat model and authenticated inventory source exist.
