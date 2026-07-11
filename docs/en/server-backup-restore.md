# Server backup and restore

## Backup scope

At minimum protect:

- the active `cadir` from `puppet config print cadir` — CA keys, certificates, serials, and CRLs;
- the active `ssldir` from `puppet config print ssldir` — Puppet Server host keys and certificates;
- the active `confdir` from `puppet config print confdir` — Puppet configuration;
- `/etc/puppetlabs/puppetserver` and `/etc/default/puppetserver`;
- `/etc/puppetlabs/r10k`;
- `/var/lib/sasd-puppet/deployments`;
- package/version inventory and the Git repository URL.

The deployed environments and r10k cache are reproducible from Git and Puppetfile, but including them can speed recovery. The Git repository itself needs independent remote backup/protection.

## Consistent backup

Stop Puppet Server for a simple small-environment CA backup, archive with numeric ownership and ACL/xattr support, encrypt the result, store it offline, and test restoration on an isolated VM.

## Restore principles

1. Restore to a compatible OS/package version.
2. Keep the same server certname and DNS names.
3. Restore file ownership and modes exactly.
4. Start the server isolated first and inspect CA/server certificates.
5. Deploy `production` from Git.
6. Test one agent no-op before reopening normal access.

Never initialize a new CA and then overlay only parts of an old SSL directory. Restore the CA as a coherent unit or follow a documented full CA replacement procedure.
