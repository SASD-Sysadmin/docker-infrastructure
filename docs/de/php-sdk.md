# PHP-SDK-Profil

`profile::php_sdk` installiert eine PHP-Kommandozeilen-Entwicklungsbasis. Es installiert weder Webserver noch PHP-FPM und verändert keine `php.ini`.

## Versionsrichtlinie

Verwendet wird die von der jeweiligen Distributions-Hauptversion unterstützte PHP-Version. Dadurch bleiben Sicherheitsupdates im Lebenszyklus der Distribution. Auf EL9 wird der vorhandene beziehungsweise standardmäßige AppStream verwendet; Puppet schaltet keinen Modulstream um.

## Composer

Composer wird auf Debian 12, Debian 13 und Ubuntu 24.04 aus Distributionspaketen installiert. In der EL9-Abbildung fehlt Composer bewusst, weil EPEL und der Upstream-Installer außerhalb der Vertrauensgrenze liegen.

```yaml
---
sasd::role: php_development
sasd::lifecycle_state: active
sasd::owner: development
sasd::description: PHP CLI development host
```
