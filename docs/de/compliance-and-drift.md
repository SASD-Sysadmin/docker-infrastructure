# Compliance und Drift

Die Puppet-Konvergenz ist der primäre Konsistenzmechanismus. Milestone 5 ergänzt Nachweise, behauptet aber nicht, dass eine Markierungsdatei Puppet-Reports oder die Paketdatenbank ersetzt.

## Nachweisquellen

1. signierte Knotenidentität und freigegebene Rolle;
2. kompilierter Katalog und Konfigurationsversion;
3. Puppet-Reportstatus und Ereigniszähler;
4. `/etc/sasd/puppet-baseline.conf` für Baseline/Version;
5. `/etc/sasd/applications.d/assigned.conf` für vorgesehene Rolle/Profile;
6. Paketdatenbank der Distribution für installierte Versionen.

Vor einer Rollenerweiterung wird ein No-op geprüft, danach angewendet und durch einen zweiten änderungsfreien Lauf die Idempotenz bestätigt. Wiederkehrende Änderungen werden als Drift oder Codeproblem untersucht und nicht mit beliebigen Reparaturbefehlen verdeckt.
