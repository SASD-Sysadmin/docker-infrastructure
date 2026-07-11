# Milestone 2 — Standalone local baseline

## Objective

Milestone 2 turns the engineering foundation into a usable, safe local Puppet
lab. A supported Debian/Ubuntu machine can install the required tooling, obtain
the control repository, preview drift, enforce a small baseline, and prove
idempotence without a Puppet Server.

## Delivered capabilities

- credential-free installation through distribution packages;
- support for Debian 12, Debian 13, and Ubuntu 24.04 LTS;
- compatibility testing for Puppet 7.23 and Puppet 8.10;
- root-safe, no-op-by-default local execution;
- Git clone/update bootstrap under `/opt/sasd`;
- r10k installation and Puppetfile handling;
- a first Hiera-driven package baseline;
- a managed marker under `/etc/sasd`;
- exact OS release, OS name, family, common, and node Hiera layers;
- RSpec-Puppet platform tests;
- bootstrap dry-run fixtures;
- disposable-container enforcement and idempotence tests;
- English and German operations documentation.

## Safety boundary

Only `package` and `file` resources are permitted. The repository contains no
`exec`, service, user, group, firewall, mount, schedule, or repository-management
resource. Unsupported operating systems fail catalog compilation before any
resource can be enforced.

No-op is the default at both bootstrap and local-run level. `--apply` requires
root and cannot be combined with synthetic facts.

## Acceptance criteria

1. all supported fixture catalogs compile;
2. expected package and marker resources appear in every supported catalog;
3. an unsupported Rocky Linux fixture fails;
4. bootstrap dry-run accepts all supported os-release fixtures and rejects the unsupported fixture;
5. static validation permits only package/file workload resources;
6. real container tests apply successfully twice and preserve marker content;
7. package state is present after integration enforcement;
8. documentation explains install, preview, apply, update, rollback, and limitations;
9. the Git repository remains ready for future Puppet Server deployment.

## Out of scope

- Puppet Server, CA, and agent certificates;
- periodic `puppet agent` service operation;
- PuppetDB and central reports;
- custom package repositories;
- application-specific profiles;
- service and configuration ownership beyond the SASD marker;
- encrypted Hiera data;
- Red Hat family support.
