# ADR 0025: Maintenance stops the periodic Puppet agent

## Status
Accepted in Milestone 6.

## Decision
A maintenance catalog enforces the assigned role once, writes lifecycle
evidence, then stops and disables the native Puppet agent service.

## Consequences
Leaving maintenance requires a reviewed data change followed by one explicit
`puppet agent -t` or service start. This prevents an indefinite hidden pause.
