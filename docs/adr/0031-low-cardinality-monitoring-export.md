# ADR 0031: Export low-cardinality monitoring data

## Status
Accepted in 0.8.0.

## Decision
The built-in monitoring bridge exports aggregate fleet states and control-plane health. It does not expose per-node labels in Prometheus output and does not install a monitoring platform.

## Consequences
Independent monitoring can consume one textfile without turning certnames into unbounded metric labels. Detailed node evidence remains in the protected compliance JSON.
