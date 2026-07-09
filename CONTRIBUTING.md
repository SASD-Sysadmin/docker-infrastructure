# Contributing

Thank you for contributing to `puppet-software-baseline`.

## Project scope

Changes should support the declarative installation and consistent configuration of applications, packages, files, and services. Incident handling, diagnostics, ad-hoc repairs, and procedural remediation should be implemented elsewhere.

## Language

English is the primary language for source code, commit messages, issues, pull requests, and primary documentation. Important operational and architectural documentation should receive a German companion version when practical.

## Change discipline

- Keep commits focused and understandable.
- Explain the desired state and the reason for a change.
- Avoid unrelated formatting changes.
- Never commit secrets or production credentials.
- Pin external module versions or immutable Git references.
- Prefer roles and profiles over large node definitions.
- Prefer Hiera data over host-specific values embedded in manifests.
- Add or update tests for productive Puppet code.
- Document rollback or recovery considerations for risky changes.

## Before submitting productive code

The exact automated toolchain will be introduced in a later milestone. Until then, contributors should at least review:

1. Puppet syntax and catalog compilation.
2. YAML syntax and Hiera lookups.
3. No-op output on an isolated test system.
4. Idempotence of a second apply.
5. Effects on every supported operating-system family.
6. Documentation in English and, where relevant, German.

## Pull requests

A pull request should state:

- what desired state is introduced or changed;
- which systems and roles are affected;
- how the change was tested;
- what a no-op run reported;
- whether a restart, outage, or manual migration is expected;
- how the change can be reverted.

## Commit messages

Use clear imperative or descriptive messages. Examples:

```text
Add Debian administration package profile
Document Puppet Server certificate workflow
Fix chrony service name on RedHat systems
```

The repository bootstrap is intentionally committed as:

```text
Initial Commit
```
