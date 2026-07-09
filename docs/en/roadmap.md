# Roadmap

## Completed

- Milestone 1: control-repository foundation and validation.
- Milestone 2: standalone local package/file baseline.
- Milestone 3: central Puppet Server, r10k, CA enrollment, production branch, bilingual operations.

## Candidate Stepstones after Milestone 3

1. Harden and self-manage the Puppet Server configuration.
2. Add application installation profiles one small group at a time.
3. Add explicit server/workstation/development roles.
4. Introduce service consistency only with tests and rollback documentation.
5. Evaluate PuppetDB/PostgreSQL for reports and queries.
6. Add encrypted Hiera data when an actual secret use case exists.
7. Add controlled test environments and optional policy-based deployment automation.
8. Extend agent support to selected Red Hat-family systems.

No stepstone should turn Puppet into an incident-response runner; operational repair remains Ansible/admin-toolkit territory.
