# ADR 0029: No automatic SELinux or firewall changes

## Status
Accepted.

## Decision
Adding EL9 agents does not authorize this repository to modify SELinux mode, policies, booleans, firewalld, or network access.

## Consequences
Sites must provide required connectivity and investigate denials separately. Exceptions require a dedicated ADR, tests, and rollback plan.
