# Architecture

The repository supports two execution modes sharing one catalog model:

- standalone: a host clones the repository and runs `puppet apply` with `role::baseline`;
- central: r10k deploys `test` and `production`; Puppet Server compiles catalogs for certificate-authenticated agents.

```text
main -> test -> production -> r10k -> Puppet Server -> agents
                                      |            |
                                      |            + compact sasd_json summaries
                                      + optional PuppetDB/PostgreSQL
```

Code layers:

1. `manifests/site.pp` — allowlisted role classification;
2. `site-modules/role` — node-purpose composition;
3. `site-modules/profile` — technical desired state;
4. `site-modules/sasd_reporting` — dataminimized report plugin;
5. `data` — Hiera policy values;
6. `scripts` — explicit bootstrap, promotion, CA, backup, and operations;
7. `Puppetfile`/`modules` — external dependencies when deliberately introduced.

The CA, package credentials, deployed environments, caches, reports, database,
and backups are host state and never repository content.
