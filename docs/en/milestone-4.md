# Milestone 4: Central Operations

Milestone 4 turns the central Puppet Server introduced in Milestone 3 into a
reviewable daily operating model. It does **not** add incident-remediation
playbooks. Puppet continues to describe persistent desired state through
manifests, roles, profiles, Hiera data, and report processors.

## Delivered

- `main`, `test`, and `production` environment branches;
- fast-forward-only promotion (`main -> test -> production`);
- `role::managed_agent` and `role::puppet_server`;
- native Puppet agent service consistency;
- reviewed one-hour run interval with splay configured during activation;
- compact `sasd_json` report processor without facts, logs, or resource values;
- periodic systemd health checks;
- server/report status commands;
- root-only control-plane backup and verification;
- optional same-host PuppetDB/PostgreSQL bootstrap for Puppet Server 8+;
- rollback preparation through a new descendant commit, never force-push;
- expanded unit, smoke, structure, and CI tests;
- complete English and German operations documentation.

## Safety boundaries

The application baseline remains deliberately small. Milestone 4 adds service
state and one tightly allowlisted `systemctl daemon-reload` refresh command.
It does not add users, firewall policy, mounts, cron entries, arbitrary shell
commands, unattended deployments, automatic certificate signing, or secrets.

## Definition of done

Milestone 4 is complete when code can be promoted through both gates, a signed
agent runs periodically, the server receives compact summaries, health and
backup scripts pass, and optional PuppetDB can be enabled only after its
preflight succeeds.
