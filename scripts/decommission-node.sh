#!/usr/bin/env bash
# Revoke/clean one retired node certificate and archive its Hiera record.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
certname=''; confirm=''; apply=false; clean_ca=false; report_directory='/var/lib/sasd-puppet/reports'
usage(){ cat <<'USAGE'
Usage: decommission-node.sh --certname NAME --confirm NAME [--apply] [--clean-ca] [--report-directory DIR]

Default is a dry run. The node record must already have lifecycle_state=retired.
--clean-ca requires root and puppetserver on the CA host.
USAGE
}
while (($#)); do
  case "$1" in
    --certname) certname="${2:-}"; shift 2 ;;
    --confirm) confirm="${2:-}"; shift 2 ;;
    --apply) apply=true; shift ;;
    --clean-ca) clean_ca=true; shift ;;
    --report-directory) report_directory="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; usage >&2; exit 64 ;;
  esac
done
[[ -n "${certname}" && "${confirm}" == "${certname}" ]] || { echo 'ERROR: --certname and identical --confirm are required' >&2; exit 64; }
[[ "${certname}" =~ ^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$ ]] || { echo 'ERROR: invalid certname' >&2; exit 64; }
source_file="${ROOT}/data/nodes/${certname}.yaml"; retired_file="${ROOT}/data/retired/${certname}.yaml"
[[ -f "${source_file}" ]] || { echo "ERROR: node record not found: ${source_file}" >&2; exit 66; }
ruby -rpsych -e 'd=Psych.safe_load_file(ARGV[0], permitted_classes: [], permitted_symbols: [], aliases: false); abort("node is not marked retired") unless d["sasd::lifecycle_state"]=="retired"' "${source_file}"
[[ ! -e "${retired_file}" ]] || { echo "ERROR: retired record already exists: ${retired_file}" >&2; exit 73; }
ca_command=(puppetserver)
if [[ "${clean_ca}" == true ]]; then
  if [[ ${EUID} -ne 0 ]]; then
    command -v sudo >/dev/null 2>&1 || { echo 'ERROR: sudo is required for CA cleanup' >&2; exit 77; }
    ca_command=(sudo puppetserver)
  fi
  command -v puppetserver >/dev/null 2>&1 || [[ ${EUID} -ne 0 ]] || { echo 'ERROR: puppetserver command not found' >&2; exit 69; }
fi
printf '%s\n' "Plan for ${certname}:" "- archive ${source_file} -> ${retired_file}" "- remove compact report ${report_directory}/${certname}.json"
[[ "${clean_ca}" == true ]] && echo "- revoke and clean CA certificate ${certname}"
if [[ "${apply}" != true ]]; then echo 'Dry run only. Add --apply to execute.'; exit 0; fi
[[ -z "$(git -C "${ROOT}" status --porcelain --untracked-files=no)" ]] || { echo 'ERROR: tracked Git worktree must be clean before decommissioning' >&2; exit 75; }
if [[ "${clean_ca}" == true ]]; then "${ca_command[@]}" ca clean --certname "${certname}"; fi
python3 - "${source_file}" <<'PY'
import pathlib,sys
p=pathlib.Path(sys.argv[1]); text=p.read_text()
if 'sasd::decommissioned_at:' not in text:
    import datetime
    text += f"sasd::decommissioned_at: '{datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}'\n"
p.write_text(text)
PY
mkdir -p "$(dirname -- "${retired_file}")"; mv -- "${source_file}" "${retired_file}"
report_file="${report_directory}/${certname}.json"
if [[ -e "${report_file}" && ! -w "${report_file}" ]]; then
  command -v sudo >/dev/null 2>&1 || { echo "ERROR: cannot remove ${report_file} and sudo is unavailable" >&2; exit 77; }
  sudo rm -f -- "${report_file}"
else
  rm -f -- "${report_file}"
fi
echo "Decommission data prepared. Review, commit, promote, and separately remove/deactivate PuppetDB history according to policy."
