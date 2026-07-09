# Application profiles

## Design rule

A profile owns one technical concern. A role composes profiles into the full intended state of a node. Application profiles never classify nodes themselves.

## Administration tools

`profile::administration_tools` installs reviewed command-line tools such as `htop`, `tcpdump`, `vim`, `dnsutils`, ACL/attribute tools, and archive utilities. The profile installs tools; it does not run them.

## Development tools

`profile::development_tools` installs the distribution compiler toolchain, debugger, `pkg-config`, Python development/virtual-environment support, and ShellCheck. Language-specific SDKs and upstream version managers are intentionally deferred to separate future profiles because their lifecycle and repository trust require independent decisions.

## Container tools

`profile::container_tools` installs Podman, Buildah, Skopeo, and rootless-support packages. It does not install Docker, create a compatibility socket, configure registries, pull images, or enable a daemon.

## Package source and versions

Packages use the target system's configured Debian/Ubuntu repositories with `ensure => installed`. This preserves the distribution security-update lifecycle. Exact package versions are not pinned in Puppet because mixing fixed versions with normal security repositories can block security upgrades. A future pinning exception requires an ADR, rollback plan, and platform-specific tests.

## Adding a package

1. Choose the single owning profile.
2. Confirm the package exists on every supported target release or add an OS-specific Hiera override.
3. Keep the group sorted.
4. Avoid duplicates between groups.
5. Update RSpec expectations and documentation.
6. Run `ruby scripts/check_package_policy.rb`.
7. Run no-op/apply/idempotence tests in a disposable target.
8. Promote through test before production.

## OS-family package mappings

Since Milestone 7, profile package names are supplied by `data/os/family/Debian.yaml` or `data/os/family/RedHat.yaml`. The EL9 mapping intentionally excludes packages that would require EPEL.

## Java SDK

`profile::java_sdk` installs the reviewed OpenJDK 17 development package and
Maven package for the target OS family. It does not select Java alternatives,
install SDKMAN, add an upstream repository, or download binary archives.

## PHP SDK

`profile::php_sdk` installs the distribution PHP CLI, development headers, and
reviewed extensions. Composer is included only in the Debian-family mapping.
The profile does not install a web server, PHP-FPM, PECL extensions, upstream
installers, or change the EL9 AppStream module.

## SDK evidence

`profile::sdk_status` installs `/usr/local/sbin/sasd-sdk-status` and owns
`/etc/sasd/toolchains.d`. Language profiles write non-secret expectation files
there. The helper reports assigned toolchains and observed command versions but
does not alter packages or alternatives.
