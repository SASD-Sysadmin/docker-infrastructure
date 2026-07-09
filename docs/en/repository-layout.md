# Repository layout

## Root files

- `README.md`: primary project overview in English.
- `README.de.md`: additional German overview.
- `LICENSE`: MIT license.
- `CHANGELOG.md`: notable repository changes.
- `CONTRIBUTING.md`: contribution and review rules.
- `SECURITY.md`: reporting and repository security policy.
- `Puppetfile`: pinned external module dependencies for r10k.
- `environment.conf`: Puppet environment module path and later environment settings.
- `hiera.yaml`: environment-level Hiera 5 hierarchy.

## `manifests/`

Contains the environment's main manifest. `site.pp` is intentionally empty in the initial commit so that checking out the repository cannot install packages or modify services by itself.

## `site-modules/`

Contains SASD-owned Puppet code committed with the control repository.

- `profiles/`: technical implementation classes.
- `roles/`: node-purpose classes that compose profiles.

A later stepstone will create conventional Puppet module structures with metadata, manifests, templates, files, facts, and tests as required.

## `modules/`

Reserved for external dependencies installed by r10k from `Puppetfile`. Generated module contents are ignored by Git.

## `data/`

Contains Hiera data:

- `common.yaml`: common defaults;
- `os/`: values selected by operating-system family;
- `roles/`: values selected by node role;
- `nodes/`: exceptional values selected by trusted certificate name.

The hierarchy order gives more specific sources precedence over common defaults.

## `scripts/`

Reserved for bootstrap, validation, local execution, and deployment helpers. Scripts will not be added until their privilege model and supported platforms are documented.

## `tests/`

Reserved for static validation, unit tests, catalog compilation tests, and integration tests.

## `.github/`

Contains issue and pull request templates. Active CI workflows are intentionally deferred until Puppet and test-tool versions are selected.

## `docs/`

- `en/`: detailed primary documentation.
- `de/`: German companion documentation.
- `adr/`: architecture decision records, normally maintained in English.
