# Control-plane backup operations

The Puppet CA is identity-bearing state. A source-code clone does not replace a
CA/configuration/database backup.

Create a root-only archive:

```bash
sudo ./scripts/backup-control-plane.sh
```

When PuppetDB is installed, a PostgreSQL custom-format dump is included
automatically. Override only when documented:

```bash
sudo ./scripts/backup-control-plane.sh --exclude-puppetdb
```

Verify independently:

```bash
sudo ./scripts/verify-backup.sh /var/backups/sasd-puppet/puppet-control-plane-*.tar.gz
```

The archive contains CA and host private keys. It must be copied to offline or
otherwise independent storage, encrypted at rest, restricted to administrators,
and tested through a documented restore exercise. Do not commit archives,
checksums containing private paths, database dumps, or extracted keys.

Restore order is documented in `server-backup-restore.md`; Milestone 4 does not
automate destructive restoration onto a live CA.
