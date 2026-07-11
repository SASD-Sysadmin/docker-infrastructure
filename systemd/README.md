# systemd integration

- `sasd-puppet-deploy.service` remains a manually invoked one-shot deployment unit.
- `profile::server_operations` renders `sasd-puppet-health.service` and
  `sasd-puppet-health.timer` from EPP templates.

There is intentionally no automatic production deployment timer or unauthenticated
webhook. The health timer opens no network listener and writes only compact JSON
state under `/var/lib/sasd-puppet/health`.
