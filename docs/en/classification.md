# Classification

`manifests/site.pp` accepts only the roles in `config/role-catalog.json` and the
lifecycle states `active`, `maintenance`, and `retired`. Hiera data cannot name
arbitrary classes.

A normal central node record contains:

```yaml
---
sasd::role: server
sasd::lifecycle_state: active
sasd::owner: operations
```

Maintenance additionally requires reason, ticket, and UTC expiry. Retired nodes
are rejected before role compilation and must be processed through the
decommission runbook. The standalone `baseline` role supports only `active`.

Platform support is independent from role classification. AlmaLinux 9 and Rocky
Linux 9 may use the same allowlisted central roles as Debian/Ubuntu agents, but
`puppet_server` is rejected by the role manifest outside to Debian 12 and Ubuntu 24.04.
