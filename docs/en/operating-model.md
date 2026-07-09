# Operating model

## Standalone phase — Milestone 2

Each lab node has a local clone, Puppet Agent command-line tools, and r10k. An
operator updates and validates the clone, reviews a no-op report, and explicitly
chooses whether to enforce. Periodic `puppet agent` services are disabled because
no Puppet Server exists.

```text
operator -> git/r10k -> validate -> puppet apply --noop -> review -> --apply
```

The clone is expected under `/opt/sasd/puppet-software-baseline`, but scripts
also work from a reviewed development clone.

## Future central phase

The Puppet Server will become the only component deploying the Git control
repository. Agents will submit facts and receive authenticated compiled catalogs.
The standalone scripts remain useful for development and controlled recovery,
but no longer form the normal fleet distribution path.
