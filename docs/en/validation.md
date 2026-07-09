# Validation and tests

## Complete suite

Run:

```bash
bundle exec rake
```

The default Rake task executes static validation, RSpec-Puppet tests, and a no-op catalog run.

## Static validation

`bundle exec rake validate` calls `scripts/validate.sh --strict` and checks:

- Bash syntax and ShellCheck findings;
- every YAML and JSON document, plus YAML style with `yamllint`;
- required repository files, versions, and metadata invariants;
- repository-local Markdown links;
- the workload-free Milestone 1 boundary;
- Puppet parser validation;
- EPP syntax when templates exist;
- Puppet style with `puppet-lint`;
- module metadata with `metadata-json-lint`.

Running `./scripts/validate.sh` without `--strict` is useful for an initial workstation check: missing external Puppet/Ruby tools produce warnings while built-in checks still run. Strict mode fails when a required external tool is absent.

## Unit tests

RSpec-Puppet compiles `profile::baseline` and `role::baseline`, verifies the role-to-profile dependency, and asserts that no resource beyond structural `Class` and `Stage` resources is present.

## Catalog smoke test

`bundle exec rake catalog` executes `puppet apply --noop` through an isolated temporary `confdir` and `vardir`. This avoids modifying the developer's Puppet state and converts Puppet detailed exit codes 0 and 2 into test success.

## CI equivalence

GitHub Actions installs ShellCheck and yamllint, restores the pinned Ruby dependencies, and runs `bundle exec rake`. Local and CI acceptance therefore use the same top-level command.
