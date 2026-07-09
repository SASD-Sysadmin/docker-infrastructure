# Milestone 9 – Java- und PHP-SDK-Profile

Milestone 9 ergänzt geprüfte Kommandozeilen-SDKs, ohne das Vertrauensmodell des Repositorys zu verändern. Java wird auf allen unterstützten Agentplattformen als OpenJDK 17 plus Maven installiert. PHP folgt der von der jeweiligen Distribution gelieferten Version. Composer wird nur auf Systemen der Debian-Familie installiert, weil es dort aus den bereits geprüften Paketquellen verfügbar ist.

## Lieferumfang

- `profile::java_sdk`, `profile::php_sdk` und `profile::sdk_status`;
- `role::java_development`, `role::php_development` und `role::polyglot_development`;
- Paketabbildungen je Betriebssystemfamilie und maschinenlesbarer SDK-Katalog;
- lokale, nicht geheime Toolchain-Nachweise und `sasd-sdk-status`;
- RSpec-Puppet-, Smoke- und Paketverfügbarkeitstests, CI, ADRs und Runbooks.

## Bewusst nicht enthalten

- kein .NET SDK;
- keine Curl-to-Shell- oder Hersteller-Bootstrapper;
- kein SDKMAN;
- keine Verwaltung von Java-Alternatives;
- kein Webserver und kein PHP-FPM;
- kein Umschalten von PHP-Modulstreams auf EL9;
- keine Projektabhängigkeiten oder globalen Composer-Pakete.
