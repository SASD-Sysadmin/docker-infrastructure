# ADR 0038: Composer is Debian-family only

- Status: Accepted
- Date: 2026-07-09

## Decision

Install Composer only where it is available from reviewed Debian-family repositories. Do not use EPEL or the upstream Composer installer on EL9.

## Consequences

EL9 PHP hosts receive the PHP SDK without Composer until a separate repository-trust decision is accepted.
