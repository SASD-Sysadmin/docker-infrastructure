# Milestone 9 runbook

## 1. Select a role

Choose exactly one of `java_development`, `php_development`, or `polyglot_development`. Do not add SDK classes dynamically through Hiera.

## 2. Create or edit node data

```bash
ruby scripts/manage-node.rb register \
  --certname dev01.example.net \
  --role java_development \
  --owner development \
  --description "Java development host"
```

For an existing node, edit the reviewed node YAML and validate it.

## 3. Validate and promote

```bash
./scripts/validate.sh
./scripts/promote-environment.sh --from main --to test
```

Run a no-op on the selected node in `test`, inspect package changes, then promote `test` to `production`.

## 4. Verify the node

```bash
sudo puppet agent -t --noop
sudo puppet agent -t
sudo sasd-sdk-status --json
cat /etc/sasd/applications.d/assigned.conf
```

## 5. Roll back

Change the node to the previous reviewed role and use the normal promotion path. Package removal is not automatic: profiles guarantee presence, not absence. Remove no-longer-needed SDK packages only through a separately reviewed cleanup change.
