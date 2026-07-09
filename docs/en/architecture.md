# Architecture

## Context

The repository maintains persistent software-installation and configuration
baselines. It is not an incident-response, diagnostic, or procedural repair
toolkit.

## Milestone 2 architecture

```text
GitHub / local Git clone
          |
          | bootstrap, validation, r10k Puppetfile install
          v
standalone Puppet environment
  manifests/site.pp
          |
          v
   role::baseline
          |
          v
 profile::baseline
     |          |
  packages   /etc/sasd marker
```

The local execution path is `puppet apply`, not `puppet agent`. No-op is the
default. The future central architecture inserts r10k deployment and Puppet
Server while preserving this environment layout and roles/profiles boundary.

## Layers

- `manifests`: classification only;
- `role`: node-purpose composition only;
- `profile`: organization-specific implementation policy;
- `data`: Hiera parameters and platform differences;
- `modules`: generated third-party dependencies from `Puppetfile`;
- `scripts`: privileged bootstrap and defensive local operation;
- `tests`: static, catalog, bootstrap, and disposable integration checks.

## Constraints

- roles and `site.pp` declare no direct workload resources;
- Milestone 2 profiles may declare only package and file resources;
- unsupported platforms fail catalog compilation;
- external modules are pinned and generated, never copied manually;
- no clear-text secrets in Git;
- real enforcement requires explicit `--apply` and root;
- dirty or non-fast-forward deployments are refused;
- node-specific Hiera remains exceptional.

See `docs/adr/` for durable decisions.
