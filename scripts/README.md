# Scripts

The scripts are defensive entry points for bootstrap, central operation, validation, application policy, and releases. Destructive or production-changing behavior requires explicit options.

Milestone 6 includes all earlier tools plus:

- `check_package_policy.rb` — validates sorted, unique package ownership;
- `check_role_catalog.py` — compares JSON role contract with Puppet code;
- `release-readiness.sh` — clean-tree/version/policy/validation gate;
- `generate-release-manifest.py` — per-file SHA-256 release evidence;
- `verify-release-manifest.py` — verifies a release tree;
- `check_milestone5_scope.py` — enforces the allowed Puppet resource boundary.

Puppet uses manifests and classes; operational procedures are documented as runbooks rather than Ansible-style playbooks.

## Milestone 6 lifecycle and secure-data tools

- `manage-node.rb`: register and transition node records atomically.
- `check_node_data.rb`: validate the node-data contract.
- `node-inventory.rb`: render table, CSV, or JSON inventory.
- `fleet-compliance.rb`: correlate active inventory with compact reports.
- `decommission-node.sh`: guarded CA cleanup and node-data archival.
- `setup-hiera-eyaml.sh`: dry-run-first backend/key setup outside Git.
- `prepare-hiera-eyaml.sh`: generate or apply the reviewed hierarchy candidate.
- `check_secret_policy.py`: reject private keys and likely plaintext credentials.
