# Milestone 1 — Control repository foundation

## Objective

Milestone 1 establishes a testable Puppet control repository without introducing productive system workload. It creates the engineering boundary on which later installation and configuration stepstones can safely build.

## Delivered capabilities

- Puppet 8 environment files: `environment.conf`, `hiera.yaml`, `Puppetfile`, and `manifests/site.pp`;
- server-ready module path including `site-modules`, r10k-managed `modules`, and `$basemodulepath`;
- a Git/VERSION `config_version` helper;
- PDK-compatible `role` and `profile` module metadata;
- documented role/profile structure;
- default classification through `role::baseline`;
- an intentionally empty `profile::baseline`;
- Hiera directories for common, operating-system, future role, and exceptional node data;
- static validation for Puppet syntax/style, module metadata, YAML, JSON, shell, and repository structure;
- RSpec-Puppet compilation tests;
- safe local catalog execution with no-op as the default;
- GitHub Actions validation and Dependabot configuration;
- English primary documentation and German companion documentation.

## Safety property

The catalog compiles a class chain but declares no package, file, service, user, group, repository, mount, schedule, or `exec` resource. Running it cannot install or reconfigure an application.

`apply-local.sh` additionally defaults to `--noop`; real application requires `--apply` explicitly. This double boundary is intentional.

## Acceptance criteria

Milestone 1 is complete when:

1. every required repository file exists;
2. all YAML and JSON files parse;
3. shell scripts pass `bash -n`;
4. Puppet manifests pass parser and lint validation in a prepared environment;
5. role and profile metadata pass `metadata-json-lint`;
6. both RSpec-Puppet class tests compile;
7. the default catalog compiles in no-op mode;
8. GitHub Actions executes the same verification suite;
9. the English and German documentation explain operation and limitations;
10. no productive Puppet workload exists.

## Out of scope

- Puppet Agent installation;
- Puppet Server installation;
- r10k server configuration;
- certificate lifecycle management;
- PuppetDB;
- application packages and repositories;
- managed configuration files and services;
- encrypted Hiera secrets;
- production node classification.

These are later stepstones, not hidden unfinished work in Milestone 1.
