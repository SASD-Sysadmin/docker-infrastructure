# Hiera data

This directory contains environment-level data consumed through Automatic
Parameter Lookup.

Priority, highest first:

1. `nodes/<trusted.certname>.yaml` for exceptional node overrides;
2. `os/<name>/<major>.yaml` for exact platform releases;
3. `os/<name>.yaml` for product defaults;
4. `os/family/<family>.yaml` for family defaults;
5. `common.yaml` for repository-wide defaults.

Array package data uses a `unique` merge. Roles remain code composition, not a
free-form data switch. Never commit credentials or private key material here.
