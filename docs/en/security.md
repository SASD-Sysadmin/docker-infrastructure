# Security

## Milestone 3 controls

- no-op remains the default for standalone bootstrap, update, and local execution;
- `--apply` and all CA-changing operations require root;
- synthetic fact fixtures cannot be combined with `--apply`;
- unsupported platforms fail before installation or enforcement;
- the active catalog remains limited to package and file resources;
- no firewall, user, service, mount, schedule, cron, host, or arbitrary `exec` resource is declared;
- Puppet Server autosigning is explicitly disabled;
- a CSR is signed only by exact, reviewed certname;
- certificate cleanup requires an exact confirmation value;
- a pre-existing CA is never regenerated, renamed, or silently assigned new DNS names;
- central-agent services remain disabled until certificate approval and an explicit activation test;
- r10k deploys one explicit same-named branch/environment under a lock and parser-validates it;
- the production deployment unit is manual and has no timer or webhook;
- Puppet Core API keys must be in a root-owned file without group/world access;
- potential key and certificate file extensions are rejected by repository validation;
- no secrets belong in Git, Hiera, examples, fixtures, or CI output.

## Privileged-code review

Treat every change under `scripts/`, `manifests/`, `site-modules/`, `data/`,
`Puppetfile`, and `systemd/` as privileged. Review exact diffs, run the complete
suite, test in a snapshot-backed lab, and retain no-op output with the change
record. Promotion from `main` to `production` is a security decision, not only
a Git operation.

## Package trust

The default bootstrap uses the repositories already configured for the chosen
distribution. The optional Puppet Core source requires an operator-supplied API
key file and HTTPS release package. Package source, support expectations, and
update policy must be recorded before production use.

## Certificate identity

A Puppet certificate name is a durable machine identity. Verify DNS, hostname,
asset ownership, and the pending CSR before signing. Never copy another node's
private key or SSL directory. Follow the documented clean/re-enrolment process
when a machine is rebuilt or renamed.
