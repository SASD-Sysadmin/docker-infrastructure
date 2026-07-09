# Classification and roles/profiles

## Milestone 1 classification

`manifests/site.pp` assigns every node to `role::baseline`. This is a deliberate temporary classification that compiles a real class chain while managing no workload.

```text
node default
  -> role::baseline
     -> profile::baseline
        -> no resources
```

## Role contract

A role represents the complete intended purpose of a node and composes profiles. Roles must not directly manage packages, files, services, users, or commands.

## Profile contract

A profile implements one coherent technical capability. It may wrap third-party modules and obtain environment data through typed parameters and Hiera.

## Future classification

Before adding multiple production roles, the project will select and document the authoritative source for a node role. Options include trusted certificate extensions, an ENC, or another controlled classifier. The unused `data/roles/` directory does not imply that an unverified custom fact has already been accepted.
