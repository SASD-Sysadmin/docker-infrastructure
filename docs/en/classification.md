# Classification

Hiera supplies `sasd::role`; `manifests/site.pp` maps it through an explicit
allowlist. Milestone 5 accepts:

- `baseline` for standalone/local nodes;
- `managed_agent` for minimal enrolled central agents;
- `server` for general-purpose managed servers;
- `development` for command-line development hosts;
- `container_host` for daemonless OCI hosts;
- `puppet_server` for the central server's own agent catalog.

Never construct a class name dynamically from Hiera. `config/role-catalog.json`
mirrors, but does not drive, the allowlist. Add a role only together with its
profiles, tests, documentation, Hiera example, and site-manifest branch.
