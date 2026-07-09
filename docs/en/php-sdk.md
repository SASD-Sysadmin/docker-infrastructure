# PHP SDK profile

`profile::php_sdk` installs a command-line PHP development baseline. It never installs a web server or PHP-FPM and does not edit `php.ini`.

## Version policy

The selected version is the supported version delivered by the distribution major release. This avoids third-party repositories and keeps security updates under the distribution's lifecycle. EL9 remains on its currently selected/default AppStream; Puppet does not switch streams.

## Composer

Composer is installed from distribution packages on Debian 12, Debian 13, and Ubuntu 24.04. It is intentionally absent from the EL9 mapping because EPEL and the upstream installer are outside the trust boundary.

## Role

```yaml
---
sasd::role: php_development
sasd::lifecycle_state: active
sasd::owner: development
sasd::description: PHP CLI development host
```
