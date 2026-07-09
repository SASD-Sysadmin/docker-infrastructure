#!/usr/bin/env bash
# Validate source formats, documentation, manifests, and Milestone 3 boundaries.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
strict=false; [[ "${1:-}" == '--strict' ]] && strict=true; [[ $# -le 1 ]] || { echo 'Usage: validate.sh [--strict]' >&2; exit 64; }
missing=0
require_or_warn(){ if command -v "$1" >/dev/null 2>&1; then return 0; fi; if [[ "${strict}" == true ]]; then echo "ERROR: required command not found: $1" >&2; missing=1; else echo "WARNING: optional command not found: $1" >&2; fi; return 1; }
cd "${ROOT}"
echo '==> Shell syntax'; while IFS= read -r -d '' f; do bash -n "$f"; done < <(find scripts tests -type f -name '*.sh' -print0 | sort -z)
echo '==> YAML, JSON, structure, links, scope and dry-runs'
ruby scripts/validate_yaml.rb
python3 scripts/validate_repository.py
python3 scripts/check_markdown_links.py
python3 scripts/check_milestone3_scope.py
python3 -c "import json,pathlib; fs=sorted(p for p in pathlib.Path('.').rglob('*.json') if '.git' not in p.parts and 'vendor' not in p.parts); [json.loads(p.read_text()) for p in fs]; print(f'JSON validation passed for {len(fs)} file(s).')"
tests/smoke/bootstrap-dry-run.sh
tests/smoke/server-dry-run.sh
tests/smoke/central-agent-dry-run.sh
tests/smoke/ca-argument-validation.sh
if require_or_warn yamllint; then mapfile -d '' fs < <(find . -path './.git' -prune -o -path './vendor' -prune -o -path './modules' -prune -o -type f \( -name '*.yaml' -o -name '*.yml' \) -print0 | sort -z); yamllint "${fs[@]}"; fi
if command -v systemd-analyze >/dev/null 2>&1; then systemd-analyze verify systemd/*.service; fi
if require_or_warn shellcheck; then mapfile -d '' fs < <(find scripts tests -type f -name '*.sh' -print0 | sort -z); shellcheck -x "${fs[@]}"; fi
if require_or_warn puppet; then mapfile -d '' fs < <(find manifests site-modules -type f -name '*.pp' -print0 | sort -z); puppet parser validate "${fs[@]}"; while IFS= read -r -d '' f; do puppet epp validate "$f"; done < <(find site-modules -type f -name '*.epp' -print0 | sort -z); fi
if require_or_warn puppet-lint; then puppet-lint manifests site-modules; fi
if require_or_warn metadata-json-lint; then metadata-json-lint site-modules/profile/metadata.json; metadata-json-lint site-modules/role/metadata.json; fi
[[ "${missing}" -eq 0 ]] || exit 1
echo 'Validation completed successfully.'
