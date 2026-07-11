# Java SDK profile

`profile::java_sdk` keeps OpenJDK 17 development tools and Maven installed from configured distribution repositories.

## Package mapping

| Family | Packages |
|---|---|
| Debian | `openjdk-17-jdk-headless`, `maven` |
| RedHat | `java-17-openjdk-devel`, `maven` |

The profile records its contract in `/etc/sasd/toolchains.d/java.conf`. It does not set `JAVA_HOME`, alter system alternatives, install Gradle, add Maven repositories, or populate user caches.

## Role

```yaml
---
sasd::role: java_development
sasd::lifecycle_state: active
sasd::owner: development
sasd::description: Java development host
```

Use `polyglot_development` when both Java and PHP are required.
