# Unterstützte Plattformen

Als Puppet Server werden Debian 12 amd64 und Ubuntu 24.04 LTS amd64 unterstützt. Debian 13 wird für den Server bewusst nicht akzeptiert.

Als verwaltete Agenten sind Debian 12, Debian 13 und Ubuntu 24.04 LTS vorgesehen. Die Modulmetadaten erlauben Puppet ab 7.23 bis vor 9.0; CI testet Puppet 7.23 und 8.10.

Die Bootstrap-Skripte setzen Apt und systemd voraus. Andere Plattformen benötigen eine eigene getestete Umsetzung und dürfen nicht durch Umgehen der Prüfung eingeführt werden.

## Milestone-7-Agents

AlmaLinux 9 und Rocky Linux 9 werden als zentrale Agents auf x86_64 und aarch64 unterstützt. Sie benötigen authentifizierte Puppet-Core-Pakete und sind weder für den Standalone-Bootstrap noch als Puppet Server freigegeben.
