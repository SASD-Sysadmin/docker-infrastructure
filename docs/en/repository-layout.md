# Repository layout

Important current paths:

- `manifests/site.pp`: allowlisted role and lifecycle dispatcher;
- `site-modules/profile`: implementation profiles and templates;
- `site-modules/role`: complete node roles;
- `data/nodes`: active/maintenance/retirement-pending node records;
- `data/retired`: archived decommission records, not loaded by Hiera;
- `config/role-catalog.json`: machine-readable role contract;
- `config/node-data-contract.json`: node-data and lifecycle contract;
- `secrets`: encrypted-data staging area with no private keys;
- `scripts`: bootstrap, operations, lifecycle, compliance, release, and recovery tools;
- `tests`: smoke, RSpec-Puppet, and container integration tests;
- `docs/en` and `docs/de`: English and German operational documentation.

## Milestone 7 additions

- `config/platform-catalog.json`: supported platform, architecture, and package-source contract;
- `data/os/family/`: complete package-name mappings per OS family;
- `profile::platform_state`: local non-secret platform evidence;
- `redhat-family.yml`: EL9 contract and package-availability tests.
