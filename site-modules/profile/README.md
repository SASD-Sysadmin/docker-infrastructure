# sasd-profile

Implementation profiles for the SASD Puppet control repository. Milestone 6 contains baseline, administration tools, development tools, container tools, application-state evidence, agent service, and Puppet Server operations.

Profiles own resources; roles compose profiles. Do not classify nodes by including profiles directly in `site.pp`.

Milestone 6 adds `profile::lifecycle_state`. Central roles use it together with
`profile::agent_service` so maintenance is visible and the periodic agent is
stopped until an explicit reactivation run.
