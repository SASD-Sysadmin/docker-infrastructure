# Puppet Server troubleshooting

## Server does not start

```bash
sudo systemctl status puppetserver
sudo journalctl -u puppetserver -b --no-pager
sudo puppetserver --version
sudo puppet config print certname
```

Check Java heap versus available RAM, syntax/ownership of configuration files, DNS names chosen before CA setup, and port 8140 conflicts.

## Agent waits for certificate

```bash
# server
sudo ./scripts/list-certificates.sh

# agent
sudo puppet ssl bootstrap --waitforcert 0
sudo puppet config print server certname environment
```

Do not solve a pending CSR by enabling autosign.

## Certificate name mismatch

Confirm that the agent `server` setting matches a name in the server certificate. For an agent identity replacement, clean the old CA entry and agent SSL state. For a server-name change, follow a full server certificate/CA procedure; do not simply edit `puppet.conf` after CA initialization.

## r10k deployment fails

```bash
sudo r10k --config /etc/puppetlabs/r10k/r10k.yaml deploy display
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Check Git reachability/credentials, existence of the remote `production` branch, Forge/module access, disk space, permissions, and the lock file only after confirming no deployment is active.

## Catalog fails

Run CI locally where possible, inspect parser errors, check Hiera data for the trusted certname, and reproduce with a no-op. Do not edit deployed code under the active `environmentpath` (`puppet config print environmentpath`); fix the repository and redeploy.
