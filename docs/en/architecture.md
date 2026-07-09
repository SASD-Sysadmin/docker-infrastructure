# Architecture

## Context

The repository maintains persistent application-installation and configuration baselines. It is not an incident-response, diagnostic, or procedural remediation toolkit.

## Current architecture

```text
Git working copy / GitHub
          |
          | validation
          v
Puppet environment
  manifests/site.pp
          |
          v
   role::baseline
          |
          v
 profile::baseline
          |
          v
    no resources
```

Local development uses `puppet apply --noop`. The future central architecture adds r10k and Puppet Server without changing the fundamental environment layout.

## Module layers

- `role`: node-purpose composition only;
- `profile`: organization-specific implementation policy;
- `modules`: third-party dependencies installed from `Puppetfile`;
- `data`: environment-level Hiera values;
- `manifests`: classification only.

## Architectural constraints

- no productive resource declarations in `site.pp` or role classes;
- no role includes from profile classes;
- no unmanaged content under `modules`;
- no clear-text secrets in Git;
- every productive profile is documented and tested;
- default local execution is no-op;
- node-specific data remains exceptional.

## Decisions

See `docs/adr/` for durable architecture decisions.
