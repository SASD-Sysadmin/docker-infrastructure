# Role-data placeholder

This directory is reserved for a later role-data hierarchy. It is deliberately
not active in `hiera.yaml` during Milestone 3. The authoritative role selector
is `sasd::role`, resolved through Hiera and constrained by the explicit
allowlist in `manifests/site.pp`. Node-specific overrides are keyed by the
certificate-bound `trusted.certname`.

Do not add a free-form role hierarchy until additional application roles and a
reviewed classification policy exist.
