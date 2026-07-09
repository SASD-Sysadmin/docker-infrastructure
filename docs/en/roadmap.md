# Roadmap

The roadmap is intentionally incremental. Each stepstone should be independently reviewable and usable.

## Stepstone 0: repository foundation — completed by this ZIP

- control repository structure;
- English and German documentation;
- license and collaboration policies;
- empty Puppet entry point and data hierarchy;
- decision to support a future Puppet Server.

## Stepstone 1: validation foundation

- select supported Puppet version range;
- select linting and test tools;
- add local validation script;
- add GitHub Actions validation;
- document exit codes and developer prerequisites.

## Stepstone 2: supported platforms and local bootstrap

- select initial Debian and Ubuntu releases;
- implement safe tool installation;
- implement local no-op wrapper;
- document uninstall and recovery behavior.

## Stepstone 3: first baseline profile

- define a minimal approved package set;
- implement the first profile;
- add Hiera parameters and tests;
- prove idempotence in isolated test systems.

## Stepstone 4: roles and classification

- choose the source of the role assignment;
- implement initial server and development roles;
- document node onboarding and exceptions.

## Stepstone 5: Puppet Server laboratory

- design server sizing and operating system;
- install and secure Puppet Server;
- configure r10k deployment;
- establish CA procedures;
- enroll the first laboratory agent.

## Stepstone 6: central production readiness

- add monitoring, reporting, backups, and recovery tests;
- define environment promotion;
- define maintenance and upgrade processes;
- evaluate PuppetDB;
- migrate selected nodes from local testing to central management.

The detailed content and order may change as requirements become concrete.
