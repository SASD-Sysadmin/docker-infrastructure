# Roadmap

## Completed

- Milestone 1: control-repository foundation and validation.
- Milestone 2: standalone local package/file baseline.
- Milestone 3: central Puppet Server, r10k, CA enrollment, production branch.
- Milestone 4: promotion, regular agents, compact reporting, health, backup, rollback, optional PuppetDB.
- Milestone 5: application package profiles, explicit operational roles, machine-readable policy, release assurance.

## Candidate stepstones after 0.5.0

1. Add one application/service profile at a time with rollback and data-migration documentation.
2. Add encrypted Hiera only for a concrete secret use case and with key custody defined.
3. Add selected Red Hat-family agents after separate package and Puppet-agent tests.
4. Integrate health/report JSON into the separate monitoring platform.
5. Add PuppetDB query examples and retention tuning if PuppetDB is enabled.
6. Evaluate a second Puppet Server/PuppetDB disaster-recovery topology only when scale requires it.
7. Add language SDK profiles (.NET, Java, PHP) independently rather than expanding the generic development group.

Puppet remains desired-state management; incident repair remains Ansible/admin-toolkit territory.
