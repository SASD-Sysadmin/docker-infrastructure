# Repository scripts

All scripts resolve the repository root from their own location and are safe to invoke from any working directory.

| Script | Purpose | Changes managed systems? |
|---|---|---:|
| `validate.sh` | Runs all available static checks; `--strict` requires the full toolchain | No |
| `validate_yaml.rb` | Parses every YAML file with Ruby/Psych | No |
| `validate_repository.py` | Enforces required structure, versions, and secret-file exclusions | No |
| `check_markdown_links.py` | Checks repository-local Markdown links | No |
| `check_no_workload.py` | Enforces the workload-free Milestone 1 boundary | No |
| `test-catalog.sh` | Compiles and applies the default catalog in an isolated no-op workspace | No |
| `apply-local.sh` | Runs local `puppet apply`; defaults to no-op | Only with `--apply` |
| `config_version.sh` | Reports the local Git revision or a visible VERSION fallback | No |
| `setup-development.sh` | Installs Ruby dependencies into `vendor/bundle` | Only the working copy |

The strict validation path is also run by `bundle exec rake` and GitHub Actions.
