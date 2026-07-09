# puppet-software-baseline

[Deutsche Dokumentation](README.de.md)

Puppet control repository for installing applications and maintaining consistent package, service, and configuration baselines across SASD systems.

The repository is designed for two operating modes:

1. **Initial development and laboratory use with `puppet apply`**.
2. **A future central Puppet Server deployment using r10k, Hiera, and the roles-and-profiles pattern**.

> **Project status:** Repository scaffolding only. The initial commit intentionally contains no productive workload, no package installation policy, and no active node classification. Functional stepstones will be implemented in later milestones.

## Purpose

This project will describe the desired, persistent state of SASD-managed systems. It is intended to:

- install approved applications and operating-system packages;
- maintain consistent configuration files and service settings;
- enable, disable, start, or stop services as part of a declared baseline;
- separate reusable implementation profiles from machine roles;
- separate Puppet code from environment-specific Hiera data;
- support reproducible deployments through a Puppet Server and r10k;
- validate changes before they reach managed systems.

It is deliberately **not** intended to become an incident-response or troubleshooting repository. Temporary repairs, diagnostics, log analysis, ad-hoc commands, and procedural remediation belong in the SASD Ansible and administration tool repositories.

## Design principles

### Declarative configuration

The repository describes what a system should look like. Puppet determines which changes are necessary to converge the machine toward that state.

### Safe by default

The initial repository does not manage any resource. Future bootstrap and deployment tooling should prefer validation and no-op execution before an actual apply.

### Server-ready from the first commit

Although local `puppet apply` testing will be supported, the directory layout follows a Puppet control repository suitable for later deployment through r10k or Puppet Enterprise Code Manager.

### Roles and profiles

Reusable implementation logic will be placed in profiles. A role will compose profiles into the intended purpose of a node. Nodes should normally receive one role.

### Data separated from code

Hiera data belongs under `data/`. Puppet manifests should avoid embedding host-specific or environment-specific values unless there is a strong reason to do so.

### Minimal node-specific exceptions

Common, operating-system, and role data should be preferred. Files for individual nodes should remain an exception because excessive host-specific data weakens consistency.

### No secrets in Git

Passwords, private keys, API tokens, certificates, and unencrypted sensitive configuration must never be committed. A later milestone may introduce an approved encrypted Hiera backend and a documented key-management process.

## Repository layout

```text
puppet-software-baseline/
├── .github/                   GitHub collaboration templates
├── data/                      Environment-level Hiera data
│   ├── common.yaml            Defaults shared by managed systems
│   ├── nodes/                 Exceptional per-node data
│   ├── os/                    Operating-system family data
│   └── roles/                 Role-specific data
├── docs/
│   ├── adr/                   Architecture decision records
│   ├── de/                    Additional German documentation
│   └── en/                    Detailed English documentation
├── manifests/
│   └── site.pp                Environment entry point; intentionally empty
├── modules/                   External modules installed by r10k; not committed
├── scripts/                   Reserved for bootstrap, validation, and deployment tools
├── site-modules/
│   ├── profile/               Organization-specific implementation profiles
│   └── role/                  Node roles composed from profiles
├── tests/                     Reserved for validation and integration tests
├── Puppetfile                 External module declarations
├── environment.conf           Puppet environment configuration
└── hiera.yaml                 Hiera 5 hierarchy
```

See [Repository layout](docs/en/repository-layout.md) for the intended responsibility of every directory.

## Current contents

The initial commit provides:

- an English primary README and German companion documentation;
- a MIT license;
- contribution and security guidance;
- a Puppet Server-ready control repository structure;
- an intentionally empty `site.pp`;
- an empty `Puppetfile` prepared for pinned external dependencies;
- a Hiera 5 hierarchy for nodes, operating systems, and common data;
- architecture and roadmap documentation;
- placeholders for future scripts, modules, tests, and GitHub automation;
- no productive Puppet workload.

## Planned operating model

### Development and laboratory phase

During early milestones, manifests can be compiled and tested locally with a command similar to:

```bash
puppet apply \
  --environmentpath "$(pwd)/.." \
  --environment "$(basename "$(pwd)")" \
  --noop \
  manifests/site.pp
```

The exact supported command will be provided by a future validation or apply script. The initial commit does not promise that Puppet is installed or configured on the host.

### Central Puppet Server phase

The intended production flow is:

```text
GitHub control repository
          |
          | r10k deployment
          v
     Puppet Server
          |
          | compiled catalogs over authenticated TLS
          v
     Puppet Agents
```

In this model:

- r10k deploys branches as Puppet environments;
- the Puppet Server compiles catalogs;
- agents do not clone this repository;
- agents submit facts and retrieve catalogs from the server;
- the Puppet Server certificate authority authenticates nodes;
- PuppetDB may be added later for reports, facts, inventory, and queries.

## Initial Hiera hierarchy

The environment-level [`hiera.yaml`](hiera.yaml) searches data in this order:

1. trusted certificate name under `data/nodes/`;
2. operating-system family under `data/os/`;
3. common defaults in `data/common.yaml`.

The `data/roles/` directory is reserved but not yet active in the hierarchy. The final node-classification mechanism will be selected during a later architecture stepstone before productive role data is introduced.

## External modules

External Puppet Forge or Git modules will be declared in [`Puppetfile`](Puppetfile) with explicit versions or immutable references. The generated `modules/` directory is excluded from Git except for its placeholder.

No external module is declared in the initial commit. Dependencies will be introduced only when a concrete baseline requirement justifies them.

## Own modules

Organization-specific code belongs in `site-modules/`:

- `profile` will contain reusable technical implementation classes;
- `role` will contain role classes that compose profiles.

The initial commit contains documentation placeholders only. It does not define classes, resources, packages, files, services, or node assignments.

## Branch and environment strategy

The initial branch is `main`. For a future Puppet Server deployment, a deliberate mapping between Git branches and Puppet environments will be documented before r10k is enabled. A likely model is:

- `main` deployed as the approved production environment;
- short-lived feature branches deployed to temporary test environments;
- an optional long-lived development environment only when operationally useful.

The repository does not yet enforce this strategy.

## Security baseline for this repository

Before productive use:

- protect the default branch;
- require review for changes affecting production;
- pin external module versions;
- validate Puppet syntax, YAML, shell scripts, and documentation;
- test catalog compilation with representative facts;
- test changes in an isolated system before production rollout;
- define a controlled process for Puppet certificate signing;
- define backup and recovery procedures for the Puppet Server and certificate authority;
- introduce encrypted secret handling before storing any sensitive value.

Read [SECURITY.md](SECURITY.md) and [Security architecture](docs/en/security.md).

## Documentation

### English

- [Architecture](docs/en/architecture.md)
- [Repository layout](docs/en/repository-layout.md)
- [Operating model](docs/en/operating-model.md)
- [Security architecture](docs/en/security.md)
- [Roadmap](docs/en/roadmap.md)
- [Initial import into GitHub](docs/en/initial-import.md)

### Deutsch

- [Deutsche Übersicht](README.de.md)
- [Architektur](docs/de/architecture.md)
- [Verzeichnisstruktur](docs/de/repository-layout.md)
- [Betriebsmodell](docs/de/operating-model.md)
- [Sicherheitsarchitektur](docs/de/security.md)
- [Roadmap](docs/de/roadmap.md)
- [Erstimport in GitHub](docs/de/initial-import.md)

## Contributing

Changes should be small, reviewable, documented, and reversible. Productive changes should include appropriate tests and a no-op review before rollout. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

## Author and project

Developed for the **SASD SysAdmin** GitHub organization and maintained as part of the SASD system-administration repository family.

Repository: `https://github.com/SASD-Sysadmin/puppet-software-baseline`
