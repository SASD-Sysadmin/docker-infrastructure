# Compact SASD reporting

Every Puppet run already creates a report. Milestone 4 adds the custom
`sasd_json` processor as a small operational index; it is not a replacement for
PuppetDB or Puppet's full report store.

Enable it after deploying the environment that contains `sasd_reporting`:

```bash
sudo ./scripts/configure-reporting.sh
sudo systemctl restart puppetserver
```

Latest summaries are written atomically to:

```text
/var/lib/sasd-puppet/reports/<certname>.json
```

The schema contains certname, environment, configuration version, transaction
UUID, status, noop state, timestamps, and aggregate event counts. It excludes
facts, resource values, log messages, file diffs, credentials, and serialized
Ruby/YAML objects.

Query summaries:

```bash
sudo ./scripts/report-status.py
sudo ./scripts/report-status.py --stale-after 10800 --json
```

Exit codes: `0` healthy, `1` stale/failed latest summaries, `2` unreadable or
invalid report data.
