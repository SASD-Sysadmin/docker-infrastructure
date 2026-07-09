# Roadmap

## Completed

- Milestone 1: control-repository foundation and validation.
- Milestone 2: standalone local package/file baseline.
- Milestone 3: central Puppet Server, r10k, CA enrollment, production branch.
- Milestone 4: promotion, agents, compact reporting, health, backup, rollback, optional PuppetDB.
- Milestone 5: application profiles, explicit roles, policy, release assurance.
- Milestone 6: node lifecycle, inventory/compliance, guarded decommissioning, opt-in encrypted-data foundation.

## Candidate stepstones after 0.6.0

1. Enable Hiera eyaml only for a concrete secret-consuming profile after key custody and recovery tests.
2. Add selected Red Hat-family agents after separate package and agent validation.
3. Integrate compliance JSON into the independent monitoring platform.
4. Add language SDK profiles independently (.NET, Java, PHP).
5. Define PuppetDB retention and node-deactivation policy if PuppetDB becomes production-critical.
6. Test full CA and encrypted-data disaster recovery on an isolated replacement server.
7. Evaluate a second compiler only when measured load or availability requirements justify it.
