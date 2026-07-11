# Node decommissioning

Decommissioning is deliberately multi-step because CA identity, inventory data,
reports, backups, and PuppetDB history have different retention implications.

1. Remove business workload and data using the relevant service runbook.
2. Set lifecycle to `retired` with reason and ticket.
3. Promote the retirement state. Further catalogs are rejected.
4. On an administrative clone, inspect the exact certname and run a dry run:

```bash
./scripts/decommission-node.sh \
  --certname node01.example.net \
  --confirm node01.example.net \
  --clean-ca
```

5. Execute only after review:

```bash
./scripts/decommission-node.sh \
  --certname node01.example.net \
  --confirm node01.example.net \
  --clean-ca --apply
```

The script cleans only the confirmed CA identity, moves the node record from
`data/nodes` to `data/retired`, adds a UTC decommission timestamp, and removes
the compact JSON report. Review and commit these repository changes.

PuppetDB history is not automatically deleted. Apply the organization's
retention/privacy policy separately.
