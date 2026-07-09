# Initial import into GitHub

## Important existing repository state

The GitHub repository was created with a placeholder README and therefore already has a commit. The ZIP generated for this project contains an independent Git repository with a single commit named `Initial Commit` and an `origin` remote pointing to:

```text
https://github.com/SASD-Sysadmin/puppet-software-baseline.git
```

Replacing the placeholder history requires a deliberate force update. Do this only while the remote contains no work that must be preserved.

## Review before pushing

From the extracted repository directory:

```bash
git status
git log --oneline --decorate --all
git remote -v
```

Review the files and confirm that the remote repository still contains only the disposable placeholder commit.

## Safe replacement procedure

First retrieve the current remote state:

```bash
git fetch origin main
```

Inspect both histories:

```bash
git log --oneline --decorate --graph --all
```

When the remote placeholder is confirmed disposable, replace it using force-with-lease rather than an unrestricted force push:

```bash
git push --force-with-lease origin main
```

If Git refuses because the lease information is stale, fetch again and investigate instead of switching immediately to `--force`.

## Alternative without replacing history

To preserve the existing GitHub commit, copy the project files into a normal clone of the remote repository and create a new commit. That produces two commits and does not meet the requested single-commit history, but it avoids rewriting the remote branch.
