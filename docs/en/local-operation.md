# Local operation

## Preview

```bash
./scripts/apply-local.sh --noop
```

No-op reports drift without enforcing it. Puppet's detailed exit codes `0` (no
change) and `2` (successful changes or simulated changes) are normalized to
shell success. Other detailed codes remain failures.

## Enforce

```bash
sudo ./scripts/apply-local.sh --apply
```

Real enforcement requires root. The runner uses an isolated temporary Puppet
state directory and rejects concurrent runs when `flock` is present.

## Fixture compilation

```bash
./scripts/apply-local.sh --noop --facts tests/fixtures/facts/debian-12.yaml
```

Synthetic facts are accepted only in no-op mode.

## Update

```bash
sudo ./scripts/update-local.sh
sudo ./scripts/update-local.sh --apply
```

The updater requires a clean working tree, performs `git pull --ff-only`,
deploys Puppetfile modules, validates the result, and finally runs no-op or
apply. It refuses detached HEAD and local modifications.

## Status

```bash
./scripts/status-local.sh
```

The status command reports repository version/commit/state, Puppet and r10k,
and the managed marker if present.
