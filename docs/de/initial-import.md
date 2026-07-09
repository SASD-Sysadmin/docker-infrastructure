# Erstimport in GitHub

## Im ZIP enthaltene Repository-Historie

Das Milestone-1-ZIP enthält ein vollständiges Git-Repository mit zwei klar getrennten Commits:

```text
Initial Commit
Complete Milestone 1 foundation
```

Zusätzlich sind das annotierte Tag `v0.1.0` und folgender `origin`-Remote enthalten:

```text
https://github.com/SASD-Sysadmin/puppet-software-baseline.git
```

## Den passenden Push-Weg auswählen

Zuerst müssen das entpackte Repository und der aktuelle Remote-Zustand geprüft werden:

```bash
git status
git log --oneline --decorate --graph --all
git remote -v
git fetch origin main
git log --oneline --decorate --graph --all
```

### Der frühere Initial Commit wurde bereits gepusht

Endet `origin/main` bereits auf demselben `Initial Commit`, kann Milestone 1 normal veröffentlicht werden:

```bash
git push origin main
git push origin v0.1.0
```

### GitHub enthält weiterhin nur seinen entbehrlichen Platzhalter-Commit

Das Ersetzen dieser unabhängigen Platzhalterhistorie erfordert ein bewusstes Umschreiben. Dies darf nur erfolgen, wenn der Remote keine erhaltenswerte Arbeit enthält:

```bash
git push --force-with-lease origin main
git push origin v0.1.0
```

Lehnt Git den Push wegen veralteter Lease-Informationen ab, muss erneut gefetcht und geprüft werden. Ein uneingeschränktes `--force` ist kein angemessener Ersatz.

### Der Remote enthält erhaltenswerte Arbeit

Dann darf die Historie nicht überschrieben werden. Stattdessen wird der Remote normal geklont, der Milestone-1-Inhalt in diesen Klon übernommen, geprüft und als neuer Commit gespeichert. Die Commit-Hashes unterscheiden sich anschließend vom ZIP; der Erhalt vorhandener Arbeit ist wichtiger als identische Hashes.
