# Scripts

The scripts are defensive entry points for bootstrap, central operation, validation, application policy, and releases. Destructive or production-changing behavior requires explicit options.

Milestone 5 additions:

- `check_package_policy.rb` — validates sorted, unique package ownership;
- `check_role_catalog.py` — compares JSON role contract with Puppet code;
- `release-readiness.sh` — clean-tree/version/policy/validation gate;
- `generate-release-manifest.py` — per-file SHA-256 release evidence;
- `verify-release-manifest.py` — verifies a release tree;
- `check_milestone5_scope.py` — enforces the allowed Puppet resource boundary.

Puppet uses manifests and classes; operational procedures are documented as runbooks rather than Ansible-style playbooks.
