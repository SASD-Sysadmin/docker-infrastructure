# Hiera data

This directory contains environment-level Hiera 5 data. The active hierarchy is defined in [`../hiera.yaml`](../hiera.yaml).

Precedence in Milestone 1:

1. `nodes/<trusted.certname>.yaml`
2. `os/<facts.os.family>.yaml`
3. `common.yaml`

`roles/` is reserved until the source and validation of the node role are formally selected. Do not place secrets in this directory. Empty placeholder files use `{}` so they remain valid YAML hashes.
