# Node lifecycle

Each central node record under `data/nodes/<certname>.yaml` contains:

```yaml
---
sasd::role: server
sasd::lifecycle_state: active
sasd::owner: operations
sasd::description: Internal application server
```

## States

### Active

The assigned role converges normally and the native Puppet agent remains enabled
and running.

### Maintenance

Maintenance requires a reason, external ticket/reference, and an expiry in UTC:

```yaml
sasd::lifecycle_state: maintenance
sasd::lifecycle_reason: Kernel and firmware maintenance
sasd::lifecycle_ticket: CHG-2026-0042
sasd::lifecycle_expires_at: '2026-07-10T18:00:00Z'
```

The current run still enforces the assigned role, writes
`/etc/sasd/lifecycle.d/state.conf`, then stops and disables the periodic agent.
To leave maintenance, promote the active state and run `puppet agent -t` once
manually before re-enabling the regular service.

### Retired

`site.pp` rejects catalog compilation for retired nodes. This is an intermediate
state used before the decommission workflow cleans the CA identity and archives
the node record.

## Commands

```bash
ruby scripts/manage-node.rb register \
  --certname node01.example.net --role server --owner operations

ruby scripts/manage-node.rb maintenance \
  --certname node01.example.net \
  --reason 'Kernel maintenance' \
  --ticket CHG-2026-0042 \
  --expires-at 2026-07-10T18:00:00Z

ruby scripts/manage-node.rb activate --certname node01.example.net

ruby scripts/manage-node.rb retire \
  --certname node01.example.net \
  --reason 'System removed' --ticket CHG-2026-0051
```

Every change is reviewed, committed, validated, and promoted like Puppet code.
