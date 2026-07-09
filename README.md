# puppet-software-baseline

[Deutsche Dokumentation](README.de.md) · [English documentation index](docs/en/README.md)

Puppet control repository for reviewed application installation, consistent system state, central Puppet operations, node lifecycle, fleet compliance, and an opt-in encrypted-data foundation across SASD systems.

> **Status:** Milestone 6 complete (`0.6.0`). The repository adds reviewed node lifecycle states, Git-native inventory and compliance tooling, guarded decommissioning, and a deliberately opt-in Hiera eyaml foundation.

## Scope

Puppet declares persistent desired state. It does not replace Ansible runbooks, the Linux admin toolkit, incident response, or one-time repairs.

Milestone 6 supports:

- reviewed distribution package profiles;
- explicit roles and central Puppet agent consistency;
- Puppet Server health, reporting, backup, rollback, and promotion;
- lifecycle states `active`, `maintenance`, and `retired`;
- machine-readable node-data contracts and inventory;
- fleet compliance correlation with compact Puppet reports;
- exact-confirmation certificate and node decommissioning;
- Hiera eyaml preparation without automatic activation.

No role adds third-party repositories, pulls container images, creates users, opens firewall ports, commits secrets, or runs general shell remediation.

## Node classification

```yaml
---
sasd::role: development
sasd::lifecycle_state: active
sasd::owner: operations
sasd::description: Command-line development host
```

Save the file as `data/nodes/<trusted-certname>.yaml`. Classification remains allowlisted in [`manifests/site.pp`](manifests/site.pp), roles are mirrored in [`config/role-catalog.json`](config/role-catalog.json), and node requirements are defined in [`config/node-data-contract.json`](config/node-data-contract.json).

## Lifecycle

- `active`: normal convergence and regular agent service;
- `maintenance`: assigned role converges once, lifecycle evidence is written, then the periodic agent is stopped and disabled;
- `retired`: catalog compilation is rejected until the guarded decommission workflow is completed.

```bash
ruby scripts/manage-node.rb register --certname node01.example.net --role server --owner operations
ruby scripts/manage-node.rb maintenance --certname node01.example.net \
  --reason 'Kernel maintenance' --ticket CHG-42 --expires-at 2026-07-10T18:00:00Z
ruby scripts/manage-node.rb activate --certname node01.example.net
ruby scripts/manage-node.rb retire --certname node01.example.net --reason 'Removed' --ticket CHG-51
```

## Inventory and compliance

```bash
ruby scripts/check_node_data.rb
ruby scripts/node-inventory.rb
ruby scripts/node-inventory.rb --format json --include-retired
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
```

## Secure-data foundation

Hiera eyaml remains disabled by default. Install the pinned backend and create keys outside Git only after key custody, backup, and recovery have been agreed:

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server
./scripts/prepare-hiera-eyaml.sh --output /tmp/hiera.yaml.candidate
python3 scripts/check_secret_policy.py
```

## Quality and release gates

```bash
./scripts/validate.sh
bundle exec rake
./scripts/release-readiness.sh --require-branch main
```

Operational flow remains:

```text
feature branch -> main -> test -> production -> r10k -> Puppet Server -> signed agents
```

## Documentation

- [Milestone 6](docs/en/milestone-6.md)
- [Node lifecycle](docs/en/node-lifecycle.md)
- [Inventory and compliance](docs/en/inventory-and-compliance.md)
- [Maintenance windows](docs/en/maintenance-windows.md)
- [Decommissioning](docs/en/decommissioning.md)
- [Secure-data foundation](docs/en/secure-data-foundation.md)
- [Milestone 6 runbook](docs/en/milestone-6-runbook.md)
- [German documentation](docs/de/README.md)

## License

Licensed under the [MIT License](LICENSE).
