# ADR 0030: Red Hat-family Puppet Server remains deferred

## Status
Accepted.

## Decision
Milestone 7 expands agents only. The central Puppet Server remains supported on Debian 12 and Ubuntu 24.04.

## Consequences
Server package, Java, CA, backup, and recovery behavior do not gain an untested second implementation path. A future server expansion needs isolated installation and disaster-recovery validation.
