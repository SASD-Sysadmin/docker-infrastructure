# Agent-Zeitplanung und Dienstkonsistenz

Der paketierte native Puppet-Dienst bleibt der Scheduler. Nach Zertifikatsfreigabe:

```bash
sudo ./scripts/configure-agent-service.sh   --runinterval 1h --splaylimit 15m --environment production
```

Das Skript ermittelt die aktiven Puppet-Pfade und ändert weder Certname, Server,
CA noch Schlüsselpfade. `profile::agent_service` hält anschließend den Dienst
aktiviert und laufend. `role::managed_agent` darf erst nach Signierung des
Zertifikats zugewiesen werden.
