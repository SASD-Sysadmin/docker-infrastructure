#!/usr/bin/env bash
# Validate source formats, documentation, manifests, and Milestone 2 boundaries.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
strict=false
[[ "${1:-}" == '--strict' ]] && strict=true
[[ $# -le 1 ]] || { printf 'Usage: %s [--strict]\n' "$0" >&2; exit 64; }
missing=0
require_or_warn() {
  if command -v "$1" >/dev/null 2>&1; then return 0; fi
  if [[ "${strict}" == true ]]; then printf 'ERROR: required command not found: %s\n' "$1" >&2; missing=1
  else printf 'WARNING: optional command not found; related checks skipped: %s\n' "$1" >&2; fi
  return 1
}
cd "${REPOSITORY_ROOT}"
printf '%s\n' '==> Checking shell syntax'
while IFS= read -r -d '' file; do bash -n "${file}"; done < <(find scripts tests -type f -name '*.sh' -print0 | sort -z)
printf '%s\n' '==> Checking YAML, JSON, structure, links, and scope'
ruby scripts/validate_yaml.rb
python3 scripts/validate_repository.py
python3 scripts/check_markdown_links.py
python3 scripts/check_milestone2_scope.py
python3 -c "import json,pathlib; fs=sorted(p for p in pathlib.Path('.').rglob('*.json') if '.git' not in p.parts and 'vendor' not in p.parts); [json.loads(p.read_text()) for p in fs]; print(f'JSON validation passed for {len(fs)} file(s).')"
"${REPOSITORY_ROOT}/tests/smoke/bootstrap-dry-run.sh"
if require_or_warn yamllint; then
  mapfile -d '' files < <(find . -path './.git' -prune -o -path './vendor' -prune -o -path './modules' -prune -o -type f \( -name '*.yaml' -o -name '*.yml' \) -print0 | sort -z)
  yamllint "${files[@]}"
fi
if require_or_warn shellcheck; then
  mapfile -d '' files < <(find scripts tests -type f -name '*.sh' -print0 | sort -z)
  shellcheck -x "${files[@]}"
fi
if require_or_warn puppet; then
  mapfile -d '' files < <(find manifests site-modules -type f -name '*.pp' -print0 | sort -z)
  puppet parser validate "${files[@]}"
  mapfile -d '' epp < <(find site-modules -type f -name '*.epp' -print0 | sort -z)
  for file in "${epp[@]}"; do puppet epp validate "${file}"; done
fi
if require_or_warn puppet-lint; then puppet-lint manifests site-modules; fi
if require_or_warn metadata-json-lint; then
  metadata-json-lint site-modules/profile/metadata.json
  metadata-json-lint site-modules/role/metadata.json
fi
[[ "${missing}" -eq 0 ]] || exit 1
printf '%s\n' 'Validation completed successfully.'
