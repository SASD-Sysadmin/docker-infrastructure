# ADR 0013: Native Puppet agent service

## Status
Accepted in Milestone 4.

## Decision
Use the package-provided native Puppet service with a reviewed one-hour run interval and splay. Enrollment scripts configure identity and cadence; Puppet enforces service state only.

## Consequences
No parallel cron/systemd timer scheduler is introduced, and manifests cannot accidentally rewrite certname or CA settings.
