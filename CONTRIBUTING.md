# Contributing

English is the leading source language. Update German operational documentation when a change affects installation, validation, deployment, security, or administration.

## Workflow

1. Create a focused feature branch.
2. Implement one reviewable desired-state change.
3. Document Puppet classes with Puppet Strings-style comments.
4. Add or update tests.
5. Run `bundle exec rake`.
6. Review local no-op output on a disposable representative system for productive changes.
7. Open a pull request with scope, verification, and rollback notes.

## Puppet rules

- roles compose profiles and do not declare operating-system resources;
- profiles implement coherent capabilities;
- third-party modules are pinned in `Puppetfile`;
- Hiera contains values rather than implementation logic;
- `exec` is a last resort and requires idempotence guards;
- host-specific exceptions require explicit justification;
- no secret or sensitive production value belongs in Git.

## Commit messages

Use imperative, focused messages, for example:

```text
Add baseline role compilation test
Document Hiera precedence
Prepare Debian agent bootstrap
```
