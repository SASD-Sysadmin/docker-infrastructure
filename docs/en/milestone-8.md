# Milestone 8 — Production assurance

Milestone 8 closes the first repository line with monitoring integration, audit evidence, isolated recovery rehearsal, upgrade preflight, and a reviewed PuppetDB retention policy. It adds no application repositories, secrets, firewall changes, automatic upgrades, or live restore automation.

## Deliverables

- `profile::monitoring_bridge` and hardened systemd timer;
- aggregate Prometheus, JSON, and Nagios-compatible output;
- checksum-verifiable audit bundles without private keys;
- backup readiness inspection and isolated extraction rehearsal;
- read-only upgrade preflight;
- PuppetDB retention candidate and guarded node deactivation;
- smoke tests, CI, ADRs, and bilingual runbooks.
