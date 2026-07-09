# Development environment

## Supported development baseline

Milestone 1 targets Puppet 8 and Ruby 3.2 or 3.3. The repository pins its Ruby development tools in `Gemfile`.

## Preparation

```bash
ruby --version
gem install bundler
./scripts/setup-development.sh
```

The setup script configures Bundler to install into `vendor/bundle`, which is excluded from Git.

## Daily commands

```bash
make help
make validate
make spec
make catalog
make test
```

Equivalent Bundler commands:

```bash
bundle exec rake validate
bundle exec rake spec
bundle exec rake catalog
bundle exec rake
```

## Safe local Puppet run

```bash
./scripts/apply-local.sh          # no-op default
./scripts/apply-local.sh --noop   # explicit no-op
./scripts/apply-local.sh --apply  # explicit enforcement
```

Milestone 1 manages no workload resources, but later milestones will make the distinction operationally important.

## Working rules

Use a feature branch, keep commits focused, update class comments and tests with code, and run the complete suite before opening a pull request. Never test an unreviewed productive profile first on an important machine.
## Reproducible open-source test toolchain

The `Gemfile` pins Puppet 8.10.0, puppet-lint 5.1.1, RSpec-Puppet 5.0.0, and related test tools. The pin describes the repository's public Ruby-gem test environment; production Puppet Server and Agent versions are selected and validated separately during the server stepstone.

