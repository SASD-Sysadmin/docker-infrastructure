# Compliance and drift

Puppet convergence remains the primary consistency mechanism. Marker files are
local evidence, not a substitute for reports or the package database.

Milestone 6 adds fleet-level correlation:

```bash
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
```

Active nodes require a recent successful compact report. Maintenance nodes are
reported separately and become warnings after their expiry. Retired nodes still
present in active inventory are errors. Missing and stale reports are warnings;
failed or malformed reports are errors.
