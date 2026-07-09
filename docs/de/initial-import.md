# Bereitgestelltes Git-Repository veröffentlichen

Das ZIP enthält die vollständige Historie bis Milestone 2 und einen passenden
`origin`-Remote. Vor dem Push prüfen:

```bash
git status
git log --oneline --decorate --graph --all
git remote -v
git tag --list --format='%(refname:short) %(subject)'
```

Ist dieselbe Milestone-1-Historie bereits remote vorhanden:

```bash
git push origin main
git push origin main test production --tags
```

Einen bedeutungslosen GitHub-Platzhalter nur nach Fetch und Vergleich mit
`--force-with-lease` ersetzen. Enthält das Remote wertvolle unabhängige Arbeit,
wird die Historie nicht überschrieben; die Änderungen werden in einen frischen
Remote-Clone übernommen und dort neu committed.
