# Roadmap

## Completed

- Milestone 1: control-repository foundation and validation.
- Milestone 2: standalone local package/file baseline.
- Milestone 3: central Puppet Server, r10k, CA enrollment, production branch.
- Milestone 4: main/test/production promotion, regular agent service, compact reporting, health checks, verified backups, rollback preparation, optional PuppetDB.

## Candidate Stepstones after Milestone 4

1. Add application installation profiles one small, tested group at a time.
2. Add explicit server/workstation/development roles.
3. Introduce application service consistency with rollback documentation.
4. Add encrypted Hiera only when a real secret use case exists.
5. Integrate health JSON with the separate monitoring platform.
6. Add PuppetDB query examples and retention tuning if PuppetDB is enabled.
7. Extend selected agents to a tested Red Hat-family platform.
8. Evaluate a second Puppet Server/PuppetDB disaster-recovery topology only when scale requires it.

Puppet remains desired-state management; operational repair remains Ansible/admin-toolkit territory.
