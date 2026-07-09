# Classification

Hiera supplies `sasd::role`; `manifests/site.pp` maps it through an explicit
allowlist. Milestone 4 accepts:

- `baseline` for standalone/local nodes;
- `managed_agent` for enrolled central agents;
- `puppet_server` for the central server's own agent catalog.

Never construct a class name dynamically from Hiera. Add a role only together
with its profiles, tests, documentation, Hiera example, and site-manifest branch.
