# Role data

Role classification is selected with `sasd::role` and allowlisted in
`manifests/site.pp`. Milestone 4 roles are `baseline`, `managed_agent`, and
`puppet_server`. This directory is reserved for future role-specific Hiera data;
it is not yet an active hierarchy layer because node-specific classification is
clearer at the current scale.
