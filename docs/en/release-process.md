# Release process

1. Complete changes on a feature branch and merge them into `main` after CI.
2. Update `VERSION`, module metadata, marker data, changelog, tests, and documentation together.
3. Run `bundle exec rake` and relevant container tests.
4. Create an annotated version tag on the approved `main` commit.
5. Fast-forward or merge the same approved commit into `production` under branch protection.
6. Push `main`, `production`, and the tag.
7. Run the manual r10k deployment.
8. Test one representative agent with no-op, then apply according to change control.

Never point `production` at an untested commit and never force-push it as a normal release action.
