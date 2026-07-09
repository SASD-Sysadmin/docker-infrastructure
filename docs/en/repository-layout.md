# Repository layout

```text
puppet-software-baseline/
├── .github/                 GitHub validation, dependency updates, templates
├── data/                    Environment-level Hiera data
├── docs/                    English, German, and ADR documentation
├── manifests/site.pp        Node classification entry point
├── modules/                 Generated third-party modules; never hand-maintained
├── scripts/                 Validation, local apply, and config-version helpers
├── site-modules/
│   ├── profile/             SASD technical implementation profiles
│   └── role/                Node-purpose compositions
├── tests/                   Repository smoke tests and representative fixtures
├── environment.conf         Per-environment Puppet settings
├── hiera.yaml               Hiera 5 hierarchy
├── Puppetfile               Pinned external module declarations
├── Gemfile                  Development and CI dependencies
├── Rakefile                 Unified verification tasks
└── VERSION                  Repository and site-module version
```

## Ownership boundaries

`site-modules` is authoritative source code. `modules` is deployment output from r10k. `data` holds values, not implementation logic. `manifests/site.pp` classifies nodes but does not implement applications.
