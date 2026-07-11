# Agent scheduling and service consistency

Puppet's package-provided native service is the supported scheduler. The
activation procedure configures a one-hour interval and a 15-minute splay:

```bash
sudo ./scripts/configure-agent-service.sh   --runinterval 1h   --splaylimit 15m   --environment production
```

The script discovers the active Puppet binary/configuration path and writes
settings with `puppet config set`. It never changes the certname, server, CA, or
private-key paths. `profile::agent_service` then keeps the native service
running and enabled.

Do not assign `role::managed_agent` before the certificate is signed. The
profile deliberately rejects locally authenticated `puppet apply` catalogs.

Useful checks:

```bash
sudo puppet config print server certname environment runinterval splay splaylimit --section agent
systemctl status puppet.service
sudo puppet agent --test --noop
```
