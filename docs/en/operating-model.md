# Operating model

`main` receives reviewed development. `production` represents deployable policy. An operator promotes a tested commit, runs r10k manually, then validates with an agent no-op. Puppet agents enforce only after certificate admission and activation.

Local mode remains a lab/fallback path, but a node must not run local and central enforcement concurrently. Puppet Server bootstrap remains script-managed in Milestone 3 to avoid a circular dependency; later self-management is a separate stepstone.
