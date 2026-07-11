# Central operational model

## Responsibilities

| Component | Responsibility |
|---|---|
| `main` | Integration branch and pull-request target |
| `test` | Pre-production Puppet environment |
| `production` | Approved production Puppet environment |
| Puppet Server | Compile catalogs, serve plugins/files, operate the CA |
| Puppet agents | Request and apply their approved catalogs |
| `sasd_json` | Write a compact latest-status document per certname |
| PuppetDB (optional) | Retain catalogs, facts, events, and reports for queries |

## Daily checks

```bash
sudo ./scripts/status-server.sh
sudo ./scripts/server-health.sh
sudo ./scripts/report-status.py
sudo ./scripts/list-certificates.sh
```

A warning is operational debt, not permission to bypass review. A critical
health result blocks promotion until the control plane is understood.

## Weekly checks

- verify the latest control-plane backup;
- inspect pending and revoked certificates;
- review failed or stale node summaries;
- confirm `test` and `production` point to the intended commits;
- review disk use in Puppet Server, report, CA, and optional PuppetDB paths.

## Change rule

Configuration consistency belongs in Puppet. Incident diagnosis, temporary
repairs, and emergency orchestration remain in Ansible/admin-toolkit workflows.
