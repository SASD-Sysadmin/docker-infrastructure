# Operating model

## Phase 1: local development

A maintainer develops and validates code in a clone of the repository. Puppet may be executed locally in an isolated laboratory system, preferably with no-op mode before an actual apply.

The future local tooling should:

- verify root requirements only when an apply needs them;
- detect the operating system and supported version;
- validate syntax and Hiera data before compilation;
- use a lock to prevent concurrent runs;
- log the repository commit and Puppet exit code;
- default to no-op unless an explicit apply option is supplied.

## Phase 2: central Puppet Server

The Puppet Server becomes the authoritative catalog compiler. r10k deploys approved control repository revisions. Agents authenticate to the server, submit facts, retrieve catalogs, apply them, and submit reports.

## Bootstrap separation

Three concerns should remain separate:

1. **Local developer bootstrap** installs tools used to validate and test the repository.
2. **Puppet Server bootstrap** installs Git, Puppet Server, r10k, and later optional PuppetDB components.
3. **Agent bootstrap** installs Puppet Agent, configures the server name, establishes certificate trust, and enables the agent service.

An agent in the final architecture does not need Git solely for Puppet configuration delivery.

## Change promotion

Before a productive change is promoted:

1. Review code and data.
2. Validate syntax and dependency declarations.
3. Compile representative catalogs.
4. Run no-op against an isolated test node.
5. Apply in a non-production environment.
6. Confirm idempotence and service health.
7. Promote an immutable reviewed revision.
8. Monitor agent reports and be prepared to suspend deployment.

## Scheduling

Puppet Agent intervals, splay, maintenance windows, and restart policy will be defined after the managed-system inventory is known. The repository does not currently impose a schedule.
