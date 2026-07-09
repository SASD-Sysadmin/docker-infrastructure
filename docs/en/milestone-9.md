# Milestone 9 — Java and PHP SDK profiles

Milestone 9 adds reviewed command-line development SDKs without changing the repository trust model. Java is OpenJDK 17 plus Maven on every supported agent platform. PHP follows the version delivered by each supported distribution. Composer is installed only on Debian-family systems because it is available from those reviewed repositories.

## Deliverables

- `profile::java_sdk`, `profile::php_sdk`, and `profile::sdk_status`;
- `role::java_development`, `role::php_development`, and `role::polyglot_development`;
- OS-family package mappings and a machine-readable SDK catalog;
- local non-secret toolchain evidence and `sasd-sdk-status`;
- RSpec-Puppet, smoke, package-availability CI, ADRs, and bilingual runbooks.

## Non-goals

- no .NET SDK;
- no curl-to-shell or vendor bootstrap installers;
- no SDKMAN;
- no Java alternatives management;
- no PHP web server or PHP-FPM;
- no EL9 PHP module-stream switching;
- no project dependencies or global Composer packages.
