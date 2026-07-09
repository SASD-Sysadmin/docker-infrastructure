# Roadmap

## Completed

- Milestone 1: control-repository foundation and validation.
- Milestone 2: standalone local package/file baseline.
- Milestone 3: central Puppet Server, r10k, CA enrollment, production branch.
- Milestone 4: promotion, agents, compact reporting, health, backup, rollback, optional PuppetDB.
- Milestone 5: application profiles, explicit roles, policy, release assurance.
- Milestone 6: node lifecycle, inventory/compliance, guarded decommissioning, opt-in encrypted-data foundation.
- Milestone 7: AlmaLinux/Rocky 9 agents and reviewed cross-family package mappings.

## Candidate stepstones after 0.7.0

1. Integrate compliance JSON into the independent monitoring platform.
2. Add Java and PHP SDK profiles from distribution repositories; design .NET separately because repository trust differs.
3. Enable Hiera eyaml only for a concrete secret-consuming profile after key custody and recovery tests.
4. Define PuppetDB retention and node-deactivation policy if PuppetDB becomes production-critical.
5. Test full CA and encrypted-data disaster recovery on an isolated replacement server.
6. Evaluate EL10 agents only after Puppet and application-package validation.
7. Evaluate a second compiler only when measured load or availability requirements justify it.
