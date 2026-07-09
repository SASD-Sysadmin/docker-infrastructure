# Role catalog

`config/role-catalog.json` is the machine-readable role contract. It is not used for dynamic Puppet class inclusion. `manifests/site.pp` remains the security boundary and maps each explicit value to a concrete role class.

## Roles

- `baseline`: local/standalone minimum; no agent service.
- `managed_agent`: minimal signed central agent.
- `server`: baseline plus administration tools.
- `development`: server tools plus build/development tools.
- `container_host`: server tools plus daemonless OCI tooling.
- `puppet_server`: administration tools, agent service, health/reporting operations.

All central roles require a remotely authenticated catalog because they include `profile::agent_service`. Enrollment and certificate approval must therefore occur before classification changes from `baseline`.

## Verification

```bash
python3 scripts/check_role_catalog.py
```

The check compares version, allowlisted site values, role manifest existence, and expected profile composition. It prevents documentation or automation from silently drifting away from Puppet code.
