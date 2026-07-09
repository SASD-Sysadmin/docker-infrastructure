# Erstimport in GitHub

## Bestehender Zustand

Das GitHub-Repository wurde mit einer Platzhalter-README erstellt und besitzt daher bereits einen Commit. Das erzeugte ZIP enthält dagegen ein eigenständiges Git-Repository mit genau einem Commit namens `Initial Commit` und folgendem Remote:

```text
https://github.com/SASD-Sysadmin/puppet-software-baseline.git
```

Zum Ersetzen des Platzhalter-Verlaufs ist ein bewusstes Umschreiben des Remote-Branches notwendig. Dies darf nur erfolgen, solange der vorhandene Commit keine erhaltenswerte Arbeit enthält.

## Prüfung

Im entpackten Repository:

```bash
git status
git log --oneline --decorate --all
git remote -v
git fetch origin main
git log --oneline --decorate --graph --all
```

## Platzhalterhistorie ersetzen

Wenn eindeutig feststeht, dass der Remote nur den entbehrlichen Platzhalter enthält:

```bash
git push --force-with-lease origin main
```

`--force-with-lease` ist einem uneingeschränkten `--force` vorzuziehen. Lehnt Git den Push wegen veralteter Informationen ab, sollte erneut gefetcht und geprüft werden.

## Alternative ohne Umschreiben

Die Dateien können auch in einen normalen Klon des GitHub-Repositorys kopiert und als zweiter Commit gespeichert werden. Dadurch bleibt der vorhandene Verlauf erhalten, es entsteht aber nicht die gewünschte Historie mit genau einem `Initial Commit`.
