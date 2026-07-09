# GitHub Actions

`validate.yml` runs the complete Milestone 1 verification suite on pushes to `main`, pull requests, and manual dispatches. It installs the pinned Ruby development dependencies and executes `bundle exec rake`.

The workflow performs validation only. It does not deploy Puppet code and cannot contact managed systems.
