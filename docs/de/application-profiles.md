# Anwendungsprofile

## Grundregel

Ein Profil besitzt genau einen technischen Verantwortungsbereich. Eine Rolle kombiniert Profile zum vollständigen Sollzustand eines Knotens. Anwendungsprofile klassifizieren keine Rechner selbst.

## Administrationswerkzeuge

`profile::administration_tools` installiert geprüfte Kommandozeilenwerkzeuge wie `htop`, `tcpdump`, `vim`, `dnsutils`, ACL-/Attributwerkzeuge und Archivprogramme. Das Profil installiert Werkzeuge, führt sie aber nicht aus.

## Entwicklungswerkzeuge

`profile::development_tools` installiert Compiler-Werkzeugkette, Debugger, `pkg-config`, Python-Entwicklungs- und venv-Unterstützung sowie ShellCheck aus der Distribution. Sprachspezifische SDKs und Upstream-Version-Manager bleiben späteren, separat geprüften Profilen vorbehalten.

## Container-Werkzeuge

`profile::container_tools` installiert Podman, Buildah, Skopeo und Pakete für rootless Container. Es installiert kein Docker, erzeugt keinen Kompatibilitätssocket, konfiguriert keine Registry, lädt keine Images und aktiviert keinen Daemon.

## Paketquelle und Versionen

Die Pakete stammen aus den konfigurierten Debian-/Ubuntu-Repositories und werden mit `ensure => installed` verwaltet. Dadurch bleibt der Sicherheitsupdate-Zyklus der Distribution erhalten. Exakte Versionsbindungen benötigen später eine eigene Architekturentscheidung, Rückfallplanung und Plattformtests.

## Paketabbildungen nach OS-Familie

Seit Milestone 7 stammen Paketnamen aus `data/os/family/Debian.yaml` oder `data/os/family/RedHat.yaml`. Die EL9-Abbildung enthält bewusst keine Pakete, die EPEL erfordern.

## Java-SDK

`profile::java_sdk` installiert das geprüfte OpenJDK-17-Entwicklungspaket und
Maven für die jeweilige Betriebssystemfamilie. Es ändert keine Java-Alternativen,
installiert kein SDKMAN, fügt kein Upstream-Repository hinzu und lädt keine
Binärarchive herunter.

## PHP-SDK

`profile::php_sdk` installiert PHP-CLI, Entwicklungsheader und geprüfte
Erweiterungen aus der Distribution. Composer gehört nur zur Debian-Abbildung.
Das Profil installiert weder Webserver noch PHP-FPM oder PECL-Erweiterungen und
ändert keinen EL9-AppStream-Modulstream.

## SDK-Nachweis

`profile::sdk_status` installiert `/usr/local/sbin/sasd-sdk-status` und verwaltet
`/etc/sasd/toolchains.d`. Sprachprofile schreiben dort nicht sensitive
Erwartungsdateien. Das Werkzeug meldet zugewiesene Toolchains und gefundene
Programmversionen, verändert aber weder Pakete noch Alternativen.

## .NET-SDK

`profile::dotnet_sdk` installiert .NET 10 LTS aus der geprüften Plattform-Paketquelle. Das Debian-Repository wird explizit und getrennt eingerichtet; Workloads und Benutzerzustände werden nicht verwaltet.
