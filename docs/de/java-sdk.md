# Java-SDK-Profil

`profile::java_sdk` hält OpenJDK-17-Entwicklungswerkzeuge und Maven aus den bereits konfigurierten Distributions-Repositories installiert.

## Paketabbildung

| Familie | Pakete |
|---|---|
| Debian | `openjdk-17-jdk-headless`, `maven` |
| RedHat | `java-17-openjdk-devel`, `maven` |

Der Vertrag wird in `/etc/sasd/toolchains.d/java.conf` dokumentiert. Das Profil setzt kein `JAVA_HOME`, verändert keine Alternatives, installiert kein Gradle und legt weder Maven-Repositories noch Benutzer-Caches an.

```yaml
---
sasd::role: java_development
sasd::lifecycle_state: active
sasd::owner: development
sasd::description: Java development host
```
