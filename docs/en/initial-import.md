# Initial import into GitHub

## Repository history contained in the ZIP

The Milestone 1 ZIP contains a complete Git repository with two focused commits:

```text
Initial Commit
Complete Milestone 1 foundation
```

It also contains the annotated tag `v0.1.0` and an `origin` remote pointing to:

```text
https://github.com/SASD-Sysadmin/puppet-software-baseline.git
```

## Choose the correct push path

First inspect the extracted repository and the current remote state:

```bash
git status
git log --oneline --decorate --graph --all
git remote -v
git fetch origin main
git log --oneline --decorate --graph --all
```

### The earlier Initial Commit was already pushed

When the remote `main` already ends at the same `Initial Commit`, publish Milestone 1 normally:

```bash
git push origin main
git push origin v0.1.0
```

### GitHub still contains only its disposable placeholder commit

Replacing that unrelated placeholder history requires a deliberate force update. Do this only when the remote contains no work that must be preserved:

```bash
git push --force-with-lease origin main
git push origin v0.1.0
```

If Git refuses because the lease is stale, fetch and inspect again. Do not replace `--force-with-lease` with an unrestricted `--force` without understanding the remote changes.

### The remote contains work that must be preserved

Do not rewrite it. Clone the remote normally, copy the Milestone 1 files into that clone, review the result, and create a new commit. The resulting commit hashes will differ from the ZIP, but preserved history is more important than matching the supplied hashes.
