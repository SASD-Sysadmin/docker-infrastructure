# Classification

## Milestone 2

`manifests/site.pp` assigns every node to `role::baseline`. Platform support is
then enforced inside `profile::baseline` using structured `os` facts. This is a
controlled temporary classification for a small homogeneous lab, not the final
fleet model.

## Future model

A Puppet Server deployment may classify by trusted certificate name, a reviewed
custom role fact, or an external node classifier. Regardless of mechanism:

- one node receives one primary role;
- roles compose profiles;
- node-specific Hiera is exceptional;
- classification data must not contain secrets;
- role changes require a no-op review because they can alter many resources.
