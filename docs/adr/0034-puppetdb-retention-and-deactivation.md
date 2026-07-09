# ADR 0034: PuppetDB retention and deactivation

## Status
Accepted in 0.8.0.

## Decision
Retired nodes are deactivated, not immediately deleted. The reviewed candidate uses node TTL 7d, node purge TTL 30d, report TTL 14d, and resource-event TTL 14d. Installation remains manual and reversible.
