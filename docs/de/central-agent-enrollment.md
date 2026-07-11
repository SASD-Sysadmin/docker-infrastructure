# Zentrale Agent-Anbindung

Der Certname ist die dauerhafte Puppet-Identität. Er muss eindeutig, klein geschrieben und FQDN-ähnlich sein. Derselbe Certname darf niemals gleichzeitig für zwei Rechner verwendet werden.

## CSR erzeugen

```bash
sudo ./scripts/bootstrap-central-agent.sh   --server puppet.example.test   --certname node01.example.test   --environment production
```

Das Skript installiert den Agent, schreibt `puppet.conf`, deaktiviert den periodischen Dienst und erzeugt einen CSR.

## Auf dem Server prüfen und signieren

Die Identität muss über Inventar, Konsole oder einen anderen unabhängigen Weg geprüft werden.

```bash
sudo ./scripts/list-certificates.sh
sudo ./scripts/sign-certificate.sh --certname node01.example.test
```

## Agent aktivieren

```bash
sudo ./scripts/activate-central-agent.sh --noop --enable-service
```

Erst nach Prüfung des No-op:

```bash
sudo ./scripts/activate-central-agent.sh --apply --enable-service
```

## AlmaLinux und Rocky Linux

EL9 benötigt `--package-source puppet-core` und eine rootgeschützte `--api-key-file`. Siehe [AlmaLinux-9- und Rocky-Linux-9-Agents](redhat-family-agents.md).
