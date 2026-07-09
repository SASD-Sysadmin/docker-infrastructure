# Role data

Role classification is selected with `sasd::role` and allowlisted in
`manifests/site.pp`. Milestone 6 roles are `baseline`, `managed_agent`, `server`,
`development`, `container_host`, and `puppet_server`.

Roles are code composition rather than a free-form Hiera layer. Node files may
select a reviewed role, but package groups remain owned by profile parameters in
common/OS data. This directory stays inactive until a justified role-data use
case exists.
