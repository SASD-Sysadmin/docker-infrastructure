# Validation and tests

## Complete suite

```bash
bundle exec rake
```

This executes strict static validation, RSpec-Puppet tests, and fixture catalog
no-op runs.

## Static validation

`scripts/validate.sh --strict` checks:

- Bash syntax and ShellCheck;
- YAML parsing/style and JSON parsing;
- repository structure, module versions, required files, and secret extensions;
- repository-local Markdown links;
- the Milestone 2 package/file resource boundary;
- supported/unsupported bootstrap os-release fixtures;
- Puppet parser and EPP syntax;
- puppet-lint and metadata-json-lint.

Without `--strict`, unavailable external tools produce warnings while built-in
checks still execute.

## Unit tests

RSpec-Puppet compiles the profile and role on Debian 12, Debian 13, and Ubuntu
24.04 facts. It asserts package state, directory/file permissions, template
content, role composition, and rejection of Rocky Linux 9.

## Fixture catalogs

`rake catalog` converts YAML fixtures into temporary high-weight custom facts
and runs `puppet apply --noop`. These custom facts exist only inside the
temporary test directory and cannot be used with `--apply`.

## Integration

`tests/integration/container-baseline.sh IMAGE` installs the distribution Puppet
package in a disposable container, applies twice, verifies packages and marker
content, and checks idempotent content. GitHub Actions covers all three supported
images.
