# role module

Node-purpose composition for SASD systems.

Milestone 3 provides only `role::baseline`, which contains
`profile::baseline`. `manifests/site.pp` maps the Hiera value `sasd::role` to
this allowlisted class. Roles remain free of direct technical resources.
