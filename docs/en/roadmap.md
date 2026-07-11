# Roadmap

## Completed

- Milestones 1–10: foundation, central operation, lifecycle, production assurance, cross-platform application profiles, and Java/PHP/.NET SDK baselines.
- Milestone 11: active per-node Hiera-eyaml with a narrowly scoped Debian APT read-only credential consumer and recovery/rotation controls.

## Candidate stepstones after 0.11.0

1. Test a complete CA, PuppetDB, and encrypted-data service restore on an isolated replacement server.
2. Evaluate agent-side deferred secret retrieval if cached-catalog exposure becomes unacceptable.
3. Validate .NET arm64 package sources before expanding the architecture allowlist.
4. Evaluate EL10 agents only after Puppet and application-package validation.
5. Evaluate a second compiler only when measured load or availability requirements justify it.
