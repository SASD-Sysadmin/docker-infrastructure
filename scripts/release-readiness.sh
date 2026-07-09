#!/usr/bin/env bash
# Run deterministic pre-release gates without publishing or changing branches.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
strict=false; require_branch=''; output=''
while (($#)); do
  case "$1" in
    --strict) strict=true; shift ;;
    --require-branch) require_branch="${2:?missing branch}"; shift 2 ;;
    --output) output="${2:?missing output}"; shift 2 ;;
    *) echo 'Usage: release-readiness.sh [--strict] [--require-branch BRANCH] [--output FILE]' >&2; exit 64 ;;
  esac
done
cd "${ROOT}"
status=pass; messages=()
[[ -z "$(git status --porcelain)" ]] || { status=fail; messages+=("Git worktree is not clean"); }
branch="$(git symbolic-ref --quiet --short HEAD || true)"
[[ -z "${require_branch}" || "${branch}" == "${require_branch}" ]] || { status=fail; messages+=("Expected branch ${require_branch}, found ${branch:-detached}"); }
version="$(<VERSION)"
[[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { status=fail; messages+=("VERSION is not semantic x.y.z"); }
python3 scripts/check_role_catalog.py >/dev/null || { status=fail; messages+=("Role catalog validation failed"); }
ruby scripts/check_package_policy.rb >/dev/null || { status=fail; messages+=("Package policy validation failed"); }
if [[ "${strict}" == true ]]; then
  scripts/validate.sh --strict --promotion-context || { status=fail; messages+=("Strict repository validation failed"); }
else
  scripts/validate.sh --promotion-context || { status=fail; messages+=("Repository validation failed"); }
fi
commit="$(git rev-parse HEAD)"
if [[ -n "${output}" ]]; then
  mkdir -p "$(dirname -- "${output}")"
  python3 - "${output}" "${status}" "${version}" "${commit}" "${branch}" "${messages[*]:-ready}" <<'PY2'
import json,sys,pathlib
out,status,version,commit,branch,message=sys.argv[1:]
pathlib.Path(out).write_text(json.dumps({'schema_version':1,'status':status,'version':version,'commit':commit,'branch':branch,'message':message},indent=2)+'\n')
PY2
fi
if [[ "${status}" != pass ]]; then printf 'ERROR: %s\n' "${messages[@]}" >&2; exit 1; fi
printf 'Release readiness passed for version %s at %s on %s.\n' "${version}" "${commit}" "${branch:-detached}"
