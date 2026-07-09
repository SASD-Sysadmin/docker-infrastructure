# r10k-Deployment und Environments

## Branch-Modell

- `main`: Integrationsbranch für Pull Requests und CI.
- `production`: freigegebener Stand; wird zum Puppet-Environment `production`.
- Feature-Branches: nicht automatisch produktiv ausgerollt.

r10k bildet Branch-Namen direkt auf Environments ab. Deshalb erzwingt das Deployment-Skript identische Namen.

## Freigabe

```bash
git checkout main
git pull --ff-only
bundle exec rake

git checkout production
git merge --ff-only main
git push origin production

sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Das Skript verwendet eine Sperrdatei, deployed nur ein Environment, installiert Puppetfile-Abhängigkeiten, prüft die Manifeste und schreibt einen Zeitstempel. Es gibt in Milestone 3 bewusst weder Timer noch Webhook. Beim Server-Bootstrap wird eine stabile Kopie unter `/usr/local/libexec/sasd-puppet/` installiert. Zusätzlich wird die manuell aufzurufende One-shot-Unit `sasd-puppet-deploy.service` installiert:

```bash
sudo systemctl start sasd-puppet-deploy.service
```

Die Unit wird nicht aktiviert und besitzt keinen Timer.

Ein Rollback erfolgt über einen zuvor getesteten Commit im Branch `production` und ein erneutes r10k-Deployment – niemals durch manuelle Änderungen im erzeugten Environment.
