# Milestone 6 runbook

## Register a node

```bash
ruby scripts/manage-node.rb register \
  --certname node01.example.net \
  --role server --owner operations \
  --description 'Internal application server'
ruby scripts/check_node_data.rb
```

Proceed with the existing central enrollment and certificate-signing runbook.

## Enter and leave maintenance

Use `manage-node.rb maintenance`, promote, run the agent once, perform the
maintenance, then use `manage-node.rb activate`, promote, and run the agent once
again.

## Daily/weekly checks

```bash
ruby scripts/check_node_data.rb
ruby scripts/node-inventory.rb
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
python3 scripts/check_secret_policy.py
```

## Retire

Mark retired, promote, then use the exact-confirmation decommission script on
the CA host. Commit the archived record afterward.

## Enable encrypted data

Do not enable eyaml during an unrelated change. Install the backend on every
compiler, create and back up keys, generate a candidate hierarchy, test in
`main` and `test`, and only then promote to `production`.
