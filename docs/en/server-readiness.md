# Puppet Server readiness

Milestone 2 does not install Puppet Server, but preserves the server contract:

- standard `environment.conf` module path;
- `Puppetfile` for r10k-managed dependencies;
- classification isolated in `site.pp`;
- roles and profiles in `site-modules`;
- Hiera 5 with `trusted.certname` as the exceptional node layer;
- Git-derived `config_version`;
- no local-only absolute paths inside Puppet manifests;
- Puppet 7/8-compatible code during the transition.

Before central deployment, decide server/agent package provenance, supported
versions, environment/branch mapping, CA lifecycle, certificate approval,
backup, reporting, monitoring, and whether PuppetDB is justified. The local
bootstrap must then be replaced by a server-agent enrollment workflow; agents
must not clone the control repository.
