# Cross-platform package data

Puppet profiles express intent; Hiera maps that intent to distribution package names.

```text
data/common.yaml                 empty package defaults and shared settings
data/os/family/Debian.yaml       Debian 12/13 and Ubuntu 24.04 names
data/os/family/RedHat.yaml       AlmaLinux 9 and Rocky Linux 9 names
```

Each family file owns complete, sorted, non-overlapping arrays for baseline, administration, development, and container tools. `scripts/check_package_policy.rb` validates each map independently.

This avoids conditional package-name logic inside manifests and makes review straightforward. Family maps may differ in size: for example, `htop` and `shellcheck` are not forced onto EL9 because Milestone 7 does not enable EPEL.

Adding a package requires confirming availability on every affected supported distribution and running the integration workflow. A package unavailable in the configured base repositories must not be silently replaced by a third-party repository.
