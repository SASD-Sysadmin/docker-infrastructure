# Validation

Run:

```bash
./scripts/validate.sh
bundle exec rake
```

Strict CI additionally requires shellcheck, yamllint, Puppet parser, EPP validation, puppet-lint, metadata-json-lint, RSpec-Puppet, fixture catalog compilation, internal Markdown-link checks, JSON/YAML parsing, secret-extension scanning, executable-mode checks, the package/file catalog boundary, and all local/server/agent dry-runs.

Real Puppet Server installation is not run in public CI because package access may require credentials and creating a reusable CA in an untrusted runner would not validate the production trust process.
