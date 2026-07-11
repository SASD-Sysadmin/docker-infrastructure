# PuppetDB retention and node deactivation

The reviewed candidate uses `node-ttl=7d`, `node-purge-ttl=30d`, `report-ttl=14d`, and `resource-events-ttl=14d`. Generate it for review:

```bash
python3 scripts/generate-puppetdb-retention.py --output /tmp/database.ini.candidate
```

Nothing installs the candidate automatically. A decommissioned node is first moved to `data/retired`, then deactivated with exact confirmation:

```bash
./scripts/deactivate-puppetdb-node.sh --certname node.example.net --confirm node.example.net
sudo ./scripts/deactivate-puppetdb-node.sh --certname node.example.net --confirm node.example.net --apply
```

Deactivation preserves history until the reviewed purge TTL expires. Immediate deletion remains forbidden.
