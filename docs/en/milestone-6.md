# Milestone 6 — node lifecycle, fleet compliance, and secure-data foundation

Milestone 6 turns reviewed per-node Hiera files into an operational inventory and
adds controlled lifecycle transitions without turning Puppet into an incident
remediation system.

## Delivered

- allowlisted lifecycle states: `active`, `maintenance`, and `retired`;
- lifecycle-aware Puppet agent service behavior;
- node registration and transition tooling;
- machine-readable node-data contract and validation;
- inventory in table, CSV, and JSON form;
- fleet compliance correlation with compact Puppet reports;
- guarded certificate/data decommission workflow;
- opt-in Hiera eyaml installation and hierarchy template;
- tracked-file secret scanning;
- RSpec, smoke, CI, runbook, ADR, and bilingual documentation updates.

## Safety boundary

Maintenance does not execute repairs. It applies the already assigned role once,
records the maintenance control data, then stops and disables the periodic agent.
A retired node receives no catalog. Decommissioning always requires an exact
certname confirmation; PuppetDB history is retained unless a separate retention
policy says otherwise.

## Release acceptance

Run:

```bash
bundle exec rake
./scripts/release-readiness.sh --require-branch main
```

Then promote `main -> test -> production` through the existing fast-forward
workflow.
