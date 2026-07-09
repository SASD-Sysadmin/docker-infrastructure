# role module

Node-purpose composition for SASD systems.

- `role::baseline`: standalone/local baseline.
- `role::managed_agent`: central baseline plus native agent service.
- `role::puppet_server`: central baseline, agent service, reporting/health operations.

Roles compose profiles and never declare technical resources directly.
