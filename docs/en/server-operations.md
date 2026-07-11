# Puppet Server operations

## Daily checks

```bash
sudo ./scripts/status-server.sh
sudo systemctl is-active puppetserver
sudo ./scripts/list-certificates.sh
sudo journalctl -u puppetserver --since today
```

Review compact summaries with `report-status.py`. PuppetDB is optional in Milestone 4 and is enabled only when historical/query requirements justify it.

## Deploy approved code

```bash
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

After deployment, run one representative agent in no-op mode before broad enforcement.

## Service control

```bash
sudo systemctl restart puppetserver
sudo systemctl status puppetserver
sudo journalctl -u puppetserver -b
```

A restart is not normally required for control-repository deployments. Use it only for server configuration or package changes.

## Package updates

Take a configuration/CA backup, review Puppet platform compatibility, update in a maintenance window, verify server/CA status, deploy code, then test an agent no-op. Puppet Server, agent, and optional PuppetDB versions form a platform set; do not upgrade components blindly.

## Logs and paths

- server configuration: the package's Puppet/Puppet Server configuration directories (`puppet config print confdir`);
- environments: `$(puppet config print environmentpath)`;
- r10k cache: `/var/cache/r10k`;
- Puppet Server data: `/opt/puppetlabs/server/data/puppetserver` on Puppet Core packages;
- logs: `/var/log/puppetlabs/puppetserver` or the distribution journal/package path;
- SASD deployment status: `/var/lib/sasd-puppet/deployments`.
