# Inventory and fleet compliance

The repository inventory is intentionally small and Git-native. It is not a
replacement for an enterprise CMDB.

## Validate node data

```bash
ruby scripts/check_node_data.rb
```

The validator checks certname filenames, required owner/role/lifecycle keys,
allowlisted roles, maintenance metadata, timestamp syntax, and retired-record
placement.

## Inventory output

```bash
ruby scripts/node-inventory.rb
ruby scripts/node-inventory.rb --format csv
ruby scripts/node-inventory.rb --format json --include-retired
```

## Compliance correlation

```bash
ruby scripts/fleet-compliance.rb \
  --reports /var/lib/sasd-puppet/reports \
  --max-age 7200
```

The result distinguishes compliant nodes, missing or stale reports, failed
runs, maintenance, expired maintenance windows, invalid reports, and retired
nodes still present in the active inventory.

Exit codes:

- `0`: compliant or valid maintenance only;
- `2`: warning such as stale/missing report or expired maintenance;
- `3`: failed/invalid/retired-pending-decommission condition.
