# Scripts

| Script | Purpose | Default safety |
|---|---|---|
| `bootstrap-agent.sh` | Install local tooling, clone/update, validate, run | no-op |
| `apply-local.sh` | Compile and apply the local catalog | no-op |
| `install-module-dependencies.sh` | Validate/install Puppetfile modules with r10k | pinned only |
| `update-local.sh` | Fast-forward, deploy modules, validate, run | no-op |
| `status-local.sh` | Report local repository and marker state | read-only |
| `validate.sh` | Run static/platform/scope checks | read-only |
| `test-catalog.sh` | Compile supported fixture catalogs | no-op |

Shared shell functions live in `scripts/lib/common.sh`. Privileged scripts must
remain non-interactive, fail closed, and never silently overwrite dirty state.
