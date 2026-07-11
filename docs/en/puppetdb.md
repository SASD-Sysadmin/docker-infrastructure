# Optional PuppetDB

PuppetDB is optional in Milestone 4. Compact summaries work without it.
PuppetDB becomes useful when historical reports, facts, catalogs, events,
exported resources, or structured queries are required.

## Supported topology

The provided bootstrap supports a small same-host installation:

```text
Puppet Server + PuppetDB + PostgreSQL
```

Requirements:

- Debian 12 or Ubuntu 24.04 amd64;
- Puppet Server major version 8 or newer;
- installable `puppetdb`, `puppetdb-termini`, and PostgreSQL packages;
- adequate memory and durable storage;
- a verified control-plane backup.

Preflight only:

```bash
sudo ./scripts/bootstrap-puppetdb.sh --dry-run
```

Apply deliberately:

```bash
sudo ./scripts/bootstrap-puppetdb.sh --apply
sudo ./scripts/status-puppetdb.sh
```

The bootstrap uses pinned `puppetlabs-puppetdb` module version `8.1.0` in an
isolated bootstrap modulepath and follows the official same-host class model:
`puppetdb` plus `puppetdb::master::config`.

PuppetDB failure can affect catalog compilation depending on connection
settings. Treat it as control-plane infrastructure, monitor it, and back up its
PostgreSQL database. Default report retention is finite; increasing retention
also increases database size.
