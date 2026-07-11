# Rollback

Ein Rollback ist ein neuer geprüfter Commit, kein Zurücksetzen veröffentlichter
Branches:

```bash
./scripts/prepare-rollback.sh --revision v0.3.0
```

Der erzeugte Rollback-Branch wird geprüft, nach `main` übernommen und normal
über `test` nach `production` promoviert. CA, Zertifikate, PuppetDB und Agent-SSL
werden bei einem Code-Rollback niemals gelöscht.
