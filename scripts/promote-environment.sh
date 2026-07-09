#!/usr/bin/env bash
# Fast-forward reviewed code from main -> test or test -> production.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; source "${SCRIPT_DIR}/lib/common.sh"
from=''; to=''; push=false; full_validation=false
usage(){ cat <<'USAGE'
Usage: promote-environment.sh --from main|test --to test|production [OPTIONS]
  --push             Push the updated target branch to origin.
  --full-validation  Run bundle exec rake before moving the branch.
USAGE
}
while (($#)); do case "$1" in --from) shift; from="${1:-}";; --to) shift; to="${1:-}";; --push) push=true;; --full-validation) full_validation=true;; -h|--help) usage; exit 0;; *) usage >&2; die "unknown argument: $1" 64;; esac; shift; done
case "${from}:${to}" in main:test|test:production) ;; *) die 'allowed promotion paths are main -> test and test -> production' 64;; esac
root="$(repository_root)"; cd "$root"
[[ -z "$(git status --porcelain)" ]] || die 'working tree must be clean' 65
git show-ref --verify --quiet "refs/heads/${from}" || die "local source branch not found: ${from}" 66
git show-ref --verify --quiet "refs/heads/${to}" || git branch "${to}" "${from}"
source_commit=$(git rev-parse "refs/heads/${from}"); target_commit=$(git rev-parse "refs/heads/${to}")
git merge-base --is-ancestor "${target_commit}" "${source_commit}" || die "${to} cannot fast-forward to ${from}; reconcile history without force-push" 65
if [[ "${full_validation}" == true ]]; then bundle exec rake; else scripts/validate.sh --promotion-context; fi
git branch -f "${to}" "${source_commit}"
log "promoted ${from}@${source_commit} to ${to} (previous ${target_commit})"
if [[ "${push}" == true ]]; then git push origin "refs/heads/${to}:refs/heads/${to}"; else log 'local branch only; review and rerun with --push to publish'; fi
