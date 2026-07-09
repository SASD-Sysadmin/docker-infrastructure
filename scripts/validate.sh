#!/usr/bin/env bash
# Validate all source formats and the Milestone 1 repository contract.
#
# Default mode runs every available check and warns about missing optional tools.
# --strict treats missing Puppet/Ruby validation commands as an error and is used
# by CI after Bundler has installed the development dependencies.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
readonly REPOSITORY_ROOT
strict=false

if [[ "${1:-}" == '--strict' ]]; then
  strict=true
elif [[ $# -gt 0 ]]; then
  printf 'Usage: %s [--strict]\n' "$0" >&2
  exit 64
fi

missing=0
require_or_warn() {
  local command_name="$1"
  if command -v "${command_name}" >/dev/null 2>&1; then
    return 0
  fi
  if [[ "${strict}" == true ]]; then
    printf 'ERROR: required command not found: %s\n' "${command_name}" >&2
    missing=1
  else
    printf 'WARNING: optional command not found; related checks skipped: %s\n' "${command_name}" >&2
  fi
  return 1
}

cd "${REPOSITORY_ROOT}"

printf '%s\n' '==> Checking shell syntax'
while IFS= read -r -d '' file; do
  bash -n "${file}"
done < <(find scripts tests -type f -name '*.sh' -print0 | sort -z)

printf '%s\n' '==> Checking YAML, structure, links, and workload boundary'
ruby scripts/validate_yaml.rb
python3 scripts/validate_repository.py
python3 scripts/check_markdown_links.py
python3 scripts/check_no_workload.py

if require_or_warn yamllint; then
  printf '%s\n' '==> Checking YAML style with yamllint'
  mapfile -d '' yaml_files < <(find . -path './.git' -prune -o -path './vendor' -prune -o -path './modules' -prune -o -type f \( -name '*.yaml' -o -name '*.yml' \) -print0 | sort -z)
  yamllint "${yaml_files[@]}"
fi


if require_or_warn shellcheck; then
  printf '%s\n' '==> Checking shell scripts with ShellCheck'
  mapfile -d '' shell_files < <(find scripts tests -type f -name '*.sh' -print0 | sort -z)
  shellcheck "${shell_files[@]}"
fi

printf '%s\n' '==> Checking JSON syntax'
python3 -c "import json,pathlib; files=sorted(p for p in pathlib.Path('.').rglob('*.json') if '.git' not in p.parts and 'vendor' not in p.parts); [json.loads(p.read_text(encoding='utf-8')) for p in files]; print(f'JSON validation passed for {len(files)} file(s).')"

if require_or_warn puppet; then
  printf '%s\n' '==> Checking Puppet manifest syntax'
  mapfile -d '' puppet_files < <(find manifests site-modules -type f -name '*.pp' -print0 | sort -z)
  puppet parser validate "${puppet_files[@]}"

  mapfile -d '' epp_files < <(find site-modules -type f -name '*.epp' -print0 | sort -z)
  if (( ${#epp_files[@]} > 0 )); then
    printf '%s\n' '==> Checking EPP templates'
    puppet epp dump --format json "${epp_files[@]}" >/dev/null
  fi
fi

if require_or_warn puppet-lint; then
  printf '%s\n' '==> Checking Puppet style'
  puppet-lint manifests site-modules
fi

if require_or_warn metadata-json-lint; then
  printf '%s\n' '==> Checking Puppet module metadata'
  metadata-json-lint site-modules/profile/metadata.json
  metadata-json-lint site-modules/role/metadata.json
fi

if [[ "${missing}" -ne 0 ]]; then
  exit 1
fi

printf '%s\n' 'Validation completed successfully.'
