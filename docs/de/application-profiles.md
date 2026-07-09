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
