# Architecture

The repository supports two execution modes sharing one catalog model:

- standalone: a host clones the repository and runs `puppet apply`;
- central: r10k deploys the `production` branch to Puppet Server, which compiles catalogs for certificate-authenticated agents.

Code layers:

1. `manifests/site.pp` — allowlisted role classification;
2. `site-modules/role` — node-purpose composition;
3. `site-modules/profile` — technical implementation;
4. `data` — Hiera policy values;
5. `Puppetfile`/`modules` — pinned external dependencies;
6. `scripts` — explicit bootstrap and control-plane operations.

The Puppet CA, package credentials, deployed environments, caches, and runtime reports are host state and never repository content.
