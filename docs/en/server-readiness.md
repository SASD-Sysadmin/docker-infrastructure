# Puppet Server readiness

Milestone 1 does not install Puppet Server, but its control-repository contract is server-ready:

- `environment.conf` includes `$basemodulepath` for server or PE system modules;
- own code is stored in `site-modules`;
- generated dependencies belong in `modules` and are declared only in `Puppetfile`;
- `config_version` reports a local Git revision or explicit VERSION fallback in catalogs and reports;
- Hiera is environment-local;
- the main manifest provides deterministic default classification;
- CI can reject invalid code before r10k deployment.

A later Puppet Server stepstone must still define:

- installation source and supported server platform;
- memory sizing and Java configuration;
- CA and certificate lifecycle;
- r10k source, authentication, deployment hooks, and branch mapping;
- environment timeout;
- backups of configuration, CA material, code, and optional PuppetDB;
- monitoring and recovery tests.
