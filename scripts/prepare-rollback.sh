#!/usr/bin/env bash
# Create a new rollback commit whose tree matches a reviewed historical revision.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; source "${SCRIPT_DIR}/lib/common.sh"
revision=''; worktree=''
usage(){ printf 'Usage: %s --revision TAG_OR_COMMIT [--worktree PATH]\n' "$0"; }
while (($#)); do case "$1" in --revision) shift; revision="${1:-}";; --worktree) shift; worktree="${1:-}";; -h|--help) usage; exit 0;; *) usage >&2; die "unknown argument: $1" 64;; esac; shift; done
[[ -n "${revision}" ]] || { usage >&2; die '--revision is required' 64; }
root="$(repository_root)"; cd "$root"; git rev-parse --verify "${revision}^{commit}" >/dev/null || die "unknown revision: ${revision}" 66
[[ -z "$(git status --porcelain)" ]] || die 'working tree must be clean' 65
stamp=$(date -u +%Y%m%dT%H%M%SZ); safe=$(printf '%s' "$revision" | tr -c 'A-Za-z0-9._-' '_'); branch="rollback/${stamp}-${safe}"
[[ -n "${worktree}" ]] || worktree="${TMPDIR:-/tmp}/sasd-puppet-${stamp}"
git worktree add -b "$branch" "$worktree" main
(
  cd "$worktree"
  git rm -r --ignore-unmatch . >/dev/null
  git checkout "$revision" -- .
  git add -A
  git commit -m "Prepare rollback to ${revision}"
  scripts/validate.sh
)
log "rollback commit prepared on ${branch} in ${worktree}"
log 'review the diff, then promote main -> test -> production through normal gates'
