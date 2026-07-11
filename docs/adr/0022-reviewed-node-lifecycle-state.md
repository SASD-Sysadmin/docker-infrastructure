# ADR 0022: Reviewed node lifecycle state

## Status
Accepted in Milestone 6.

## Decision
Every centrally managed node has an allowlisted lifecycle state: `active`,
`maintenance`, or `retired`. The site manifest rejects retired nodes before a
catalog is compiled. Maintenance requires reason, ticket, and UTC expiry.

## Consequences
Lifecycle transitions are reviewable Git changes. They do not replace a CMDB or
change-management system.
