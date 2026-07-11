# Development

## Toolchain

The code supports Puppet 7.23 through Puppet 8.x. CI uses Puppet 7.23 with Ruby
3.1 and Puppet 8.10 with Ruby 3.3. The default local Gemfile selection is Puppet
8.10; override it for compatibility checks:

```bash
PUPPET_GEM_VERSION=7.23.0 bundle install
PUPPET_GEM_VERSION=7.23.0 bundle exec rake
```

Install dependencies:

```bash
gem install bundler
./scripts/setup-development.sh
```

## Change flow

1. create a focused branch;
2. update code, Hiera, tests, and both documentation languages;
3. run `bundle exec rake`;
4. run an appropriate disposable-container integration test;
5. review real no-op output on a matching VM;
6. open a pull request with rollback notes.

## Design rules

Roles compose profiles. Profiles own resources. Platform variation belongs in
Hiera or narrowly justified code. New resource types require an ADR and an
update to the scope validator. Do not add `exec` as a shortcut for missing
declarative design.
