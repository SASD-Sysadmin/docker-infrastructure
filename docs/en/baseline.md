# Baseline

Milestone 7 retains the conservative package/file baseline and reviewed
application profiles. `/etc/sasd/puppet-baseline.conf` records version `0.8.0`,
platform, management mode, and trusted certname.

Central roles additionally write:

- `/etc/sasd/applications.d/assigned.conf` for intended role/profile evidence;
- `/etc/sasd/lifecycle.d/state.conf` for active or maintenance state.

These marker files contain no secrets and do not replace Puppet reports or the
operating-system package database.
