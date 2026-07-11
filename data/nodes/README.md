# Per-node data

A centrally managed node is classified by a file named after its exact trusted
certificate name:

```yaml
---
sasd::role: server
sasd::lifecycle_state: active
sasd::owner: operations
sasd::description: Internal application server
```

Use `scripts/manage-node.rb` rather than hand-editing lifecycle transitions.
Run `scripts/check_node_data.rb` before committing. Maintenance additionally
requires reason, ticket, and a UTC expiry. A retired record is temporarily kept
here until `scripts/decommission-node.sh` moves it to `data/retired/`.

Do not store credentials, private keys, personal notes, or unreviewed arbitrary
class names in node data.
