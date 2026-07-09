# Release process

Milestone 1 identifies the repository as version `0.1.0`.

For future releases:

1. complete and review a focused stepstone;
2. run `bundle exec rake`;
3. update English and German operational documentation;
4. update `CHANGELOG.md` and `VERSION`;
5. keep both site-module `metadata.json` versions aligned with `VERSION` while they are released together;
6. merge through a reviewed pull request;
7. create an annotated Git tag such as `v0.2.0`;
8. deploy first to a test environment and review no-op output before production.

A Git tag is not by itself authorization to deploy production code.
