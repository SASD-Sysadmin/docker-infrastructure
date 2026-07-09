# Disaster recovery rehearsal

A control-plane backup contains CA private material and must remain encrypted and offline. Milestone 8 adds `backup.json`, includes `/etc/sasd-puppet` when present, checks archive paths and expected CA/configuration content, and can extract only into an explicitly confirmed isolated directory.

```bash
python3 scripts/recovery-readiness.py /secure/puppet-control-plane-*.tar.gz
sudo ./scripts/rehearse-recovery.sh --archive /secure/backup.tar.gz --target /srv/recovery-lab/puppet-2026Q3 --confirm-isolated /srv/recovery-lab/puppet-2026Q3
```

The rehearsal does not write `/etc`, `/var`, `/opt`, or other live roots. Validate CA identity, certname, environments, r10k, PuppetDB dump, and eyaml key custody before declaring the drill successful.
