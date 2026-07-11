#!/usr/bin/env bash
# Bootstrap a Debian/Ubuntu host for standalone local Puppet operation.
#
# The script intentionally uses distribution packages. Current Puppet Core
# repositories require authenticated access, whereas Milestone 2 is designed to
# be reproducible in a credential-free lab. A future Puppet Server milestone
# will make the production package-source decision independently.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

repository_url='https://github.com/SASD-Sysadmin/puppet-software-baseline.git'
branch='main'
destination='/opt/sasd/puppet-software-baseline'
mode='--noop'
dry_run=false
os_release_file='/etc/os-release'

usage() {
  cat <<'EOF'
Usage: bootstrap-agent.sh [OPTIONS]

Options:
  --repository-url URL  Git repository to clone.
  --branch NAME         Branch to check out (default: main).
  --destination DIR     Local clone destination.
  --noop                Bootstrap, then preview the catalog (default).
  --apply               Bootstrap and enforce the baseline.
  --dry-run             Print the detected plan without changing the host.
  --os-release-file F   Alternate os-release fixture; intended for tests.
  -h, --help            Show this help.
EOF
}

while (($#)); do
  case "$1" in
    --repository-url) shift; [[ $# -gt 0 ]] || die '--repository-url requires a value' 64; repository_url="$1" ;;
    --branch) shift; [[ $# -gt 0 ]] || die '--branch requires a value' 64; branch="$1" ;;
    --destination) shift; [[ $# -gt 0 ]] || die '--destination requires a value' 64; destination="$1" ;;
    --noop) mode='--noop' ;;
    --apply) mode='--apply' ;;
    --dry-run) dry_run=true ;;
    --os-release-file) shift; [[ $# -gt 0 ]] || die '--os-release-file requires a value' 64; os_release_file="$1" ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" 64 ;;
  esac
  shift
done

[[ -n "${repository_url}" && "${repository_url}" != -* ]] || die 'repository URL must be non-empty and must not start with a dash' 64
[[ -n "${branch}" && "${branch}" != -* ]] || die 'branch must be non-empty and must not start with a dash' 64
[[ -n "${destination}" && "${destination}" != -* ]] || die 'destination must be non-empty and must not start with a dash' 64

read_os_release "${os_release_file}"
is_supported_platform || die "unsupported platform ${ID} ${VERSION_ID}; supported: Debian 12/13 and Ubuntu 24.04" 69

log "platform: ${ID} ${VERSION_ID}"
log "repository: ${repository_url} (${branch})"
log "destination: ${destination}"
log "catalog mode: ${mode#--}"

if [[ "${dry_run}" == true ]]; then
  log 'dry-run complete; no package, Git, service, or Puppet action was executed'
  exit 0
fi

require_root
export DEBIAN_FRONTEND=noninteractive

log 'refreshing APT metadata and installing bootstrap prerequisites'
apt-get update
apt-get install --yes ca-certificates curl git

if [[ "${ID}" == 'ubuntu' ]] && ! apt-cache show puppet-agent >/dev/null 2>&1; then
  log 'enabling Ubuntu Universe for puppet-agent and r10k'
  apt-get install --yes software-properties-common
  add-apt-repository --yes universe
  apt-get update
fi

log 'installing distribution Puppet Agent and r10k packages'
apt-get install --yes puppet-agent r10k hiera-eyaml
git check-ref-format --branch "${branch}" >/dev/null || die "invalid Git branch name: ${branch}" 64

# Local mode must not start periodic server-oriented agent runs. Service names
# vary between package generations, therefore both candidates are handled.
if command -v systemctl >/dev/null 2>&1; then
  systemctl disable --now puppet.service puppet-agent.service 2>/dev/null || true
fi

install -d -m 0755 "$(dirname -- "${destination}")"
if [[ -d "${destination}/.git" ]]; then
  [[ -z "$(git -C "${destination}" status --porcelain)" ]] || die "destination clone is dirty: ${destination}" 65
  log 'updating existing clone by fast-forward only'
  git -C "${destination}" fetch --prune origin
  git -C "${destination}" checkout "${branch}"
  git -C "${destination}" merge --ff-only "origin/${branch}"
elif [[ -e "${destination}" ]]; then
  die "destination exists but is not a Git clone: ${destination}" 73
else
  log 'cloning control repository'
  git clone --branch "${branch}" --single-branch "${repository_url}" "${destination}"
fi

"${destination}/scripts/install-module-dependencies.sh"
"${destination}/scripts/validate.sh"
"${destination}/scripts/apply-local.sh" "${mode}"
log 'local Puppet bootstrap completed'
