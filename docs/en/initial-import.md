# Publishing the supplied Git repository

The ZIP contains the complete history through Milestone 2 and an `origin` remote
for the SASD-Sysadmin repository. Inspect before pushing:

```bash
git status
git log --oneline --decorate --graph --all
git remote -v
git tag --list --format='%(refname:short) %(subject)'
```

If the remote already contains the same Milestone 1 history, publish normally:

```bash
git push origin main
git push origin main production --tags
```

If the remote still contains only an unrelated GitHub placeholder commit,
fetch and compare it first. Replace history only when that placeholder is known
to be disposable, using `--force-with-lease`, never an unconditional force.

If the remote contains valuable independent work, do not rewrite it. Clone the
remote, copy/replay the Milestone 2 changes, test, and create a new commit there.
Commit hashes may differ; preserved history matters more than matching the ZIP.
