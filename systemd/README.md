# systemd example

`bootstrap-server.sh` installs `sasd-puppet-deploy.service` as a **manual**
oneshot unit and copies the validated deployment wrapper to
`/usr/local/libexec/sasd-puppet/`. Milestone 3 intentionally installs no timer
and no webhook. An operator can deploy after reviewing the control-repository
branch with:

```bash
sudo systemctl start sasd-puppet-deploy.service
sudo systemctl status sasd-puppet-deploy.service
```

The unit deploys only the `production` environment. Change control for other
environments must invoke `deploy-environment.sh` explicitly and preserve the
branch-to-environment equality rule.
