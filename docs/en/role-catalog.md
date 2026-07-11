# Role catalog

`config/role-catalog.json` is the machine-readable role contract. It is not used
for dynamic Puppet class inclusion. `manifests/site.pp` remains the security
boundary and maps each explicit value to a concrete role class.

## Roles

- `baseline`: local/standalone minimum; no agent service.
- `managed_agent`: minimal signed central agent.
- `server`: baseline plus administration tools.
- `development`: server tools plus general build/development tools.
- `java_development`: development role plus OpenJDK 17 and Maven.
- `php_development`: development role plus distribution PHP SDK packages.
- `polyglot_development`: development role plus both reviewed SDK profiles.
- `container_host`: server tools plus daemonless OCI tooling.
- `puppet_server`: administration tools, agent service, health/reporting operations.

All central roles require a remotely authenticated catalog because they include
`profile::agent_service`. Enrollment and certificate approval must therefore
occur before classification changes from `baseline`.

Language SDK roles use fixed profile composition. Hiera provides reviewed
package names but never arbitrary class names, repositories, installers, or
commands.

## Verification

```bash
python3 scripts/check_role_catalog.py
python3 scripts/check_sdk_catalog.py
```

The checks compare versions, allowlisted site values, role manifest existence,
expected profile composition, SDK policy, and package mappings. They prevent
documentation or automation from silently drifting away from Puppet code.

## `dotnet_development`

A central x86_64 development role combining the general development baseline with `profile::dotnet_sdk`.
