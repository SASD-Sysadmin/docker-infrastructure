# Release process

The current release is `0.2.0` and is tagged `v0.2.0` after acceptance.

1. update `VERSION`, both site-module metadata files, marker-version Hiera, and changelog;
2. update English and German documentation;
3. run Puppet 7 and Puppet 8 validation suites;
4. run all supported container integration tests;
5. capture reviewed VM no-op evidence;
6. commit with a milestone-focused message;
7. create an annotated semantic-version tag;
8. push the commit and tag only after review.

Never move an existing release tag. Correct a released defect with a new patch
version.
