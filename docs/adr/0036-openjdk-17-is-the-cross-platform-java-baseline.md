# ADR 0036: OpenJDK 17 is the cross-platform Java baseline

- Status: Accepted
- Date: 2026-07-09

## Decision

Use OpenJDK 17 development packages and Maven from configured distribution repositories on every supported agent platform. Do not manage Java alternatives or `JAVA_HOME`.

## Consequences

The baseline is explicit and cross-family. New Java feature releases require a separate compatibility and migration decision.
