# Milestone 2 baseline

## Package policy

The package list is intentionally conservative and sourced only from standard
platform repositories. `common.yaml` defines cross-platform tools; OS family,
product, and release layers add narrow differences. `lookup_options` uses a
`unique` array merge.

Removing a name from Hiera does **not** uninstall the package. Milestone 2 uses
`ensure => installed`, not an authoritative purge policy. Package removal must
be designed as a separate reviewed stepstone.

## Marker policy

`/etc/sasd/puppet-baseline.conf` proves file ownership, template rendering, and
platform-aware catalogs. It contains no secret and no executable configuration.
Manual changes are replaced on the next apply.

## Unsupported platforms

`profile::baseline` fails compilation unless facts identify Debian 12, Debian
13, or Ubuntu 24.04. Expanding support requires package review, facts fixtures,
unit tests, integration tests, and bilingual documentation.
