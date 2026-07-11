# sasd_reporting module

This site module provides the `sasd_json` Puppet report processor. It writes one
compact JSON status document per certname to `/var/lib/sasd-puppet/reports`.
It deliberately excludes full resource values, logs, facts, secrets, and YAML
object serialization. Enable it with `scripts/configure-reporting.sh`.
