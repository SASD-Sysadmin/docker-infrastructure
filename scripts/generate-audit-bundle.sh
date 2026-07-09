#!/usr/bin/env bash
# Create a checksum-verifiable operational evidence bundle without private keys.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
output_dir='./dist'; compliance_file=''; health_file=''; reports='/var/lib/sasd-puppet/reports'; skip_runtime=false
usage(){ printf 'Usage: %s [--output-directory PATH] [--compliance-file FILE] [--health-file FILE] [--reports PATH] [--skip-runtime]\n' "$0"; }
while (($#)); do case "$1" in --output-directory) shift; output_dir="${1:-}";; --compliance-file) shift; compliance_file="${1:-}";; --health-file) shift; health_file="${1:-}";; --reports) shift; reports="${1:-}";; --skip-runtime) skip_runtime=true;; -h|--help) usage; exit 0;; *) usage >&2; exit 64;; esac; shift; done
mkdir -p "$output_dir"; stage=$(mktemp -d); trap 'rm -rf -- "$stage"' EXIT; mkdir -p "$stage/evidence" "$stage/metadata"
stamp=$(date -u +%Y%m%dT%H%M%SZ); version=$(cat "$ROOT/VERSION"); commit=$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo unavailable)
ruby "$ROOT/scripts/node-inventory.rb" --format json >"$stage/evidence/inventory.json"
if [[ -n "$compliance_file" ]]; then cp "$compliance_file" "$stage/evidence/compliance.json"; else set +e; ruby "$ROOT/scripts/fleet-compliance.rb" --reports "$reports" --format json >"$stage/evidence/compliance.json"; echo $? >"$stage/metadata/compliance-exit-code"; set -e; fi
if [[ -n "$health_file" ]]; then cp "$health_file" "$stage/evidence/health.json"; elif [[ "$skip_runtime" == false && -x /usr/local/sbin/sasd-puppet-health ]]; then set +e; /usr/local/sbin/sasd-puppet-health >"$stage/evidence/health.json"; echo $? >"$stage/metadata/health-exit-code"; set -e; else printf '{"schema_version":1,"status":"unavailable","message":"runtime health collection skipped"}\n' >"$stage/evidence/health.json"; fi
cp "$ROOT/config/operations-policy.json" "$ROOT/config/platform-catalog.json" "$ROOT/config/role-catalog.json" "$stage/evidence/"
cp "$ROOT/VERSION" "$stage/evidence/VERSION"
if [[ "$skip_runtime" == false ]]; then
  { command -v puppet >/dev/null && puppet --version || true; command -v java >/dev/null && java -version 2>&1 || true; command -v ruby >/dev/null && ruby --version || true; } >"$stage/evidence/component-versions.txt"
  if command -v puppetserver >/dev/null; then puppetserver ca list --all >"$stage/evidence/certificate-inventory.txt" 2>&1 || true; fi
fi
python3 - "$stage/metadata/bundle.json" "$stamp" "$version" "$commit" <<'PY2'
import json,sys
json.dump({'schema_version':1,'created_at':sys.argv[2],'repository_version':sys.argv[3],'git_commit':sys.argv[4],'contains_private_keys':False,'contains_secret_values':False},open(sys.argv[1],'w'),indent=2); open(sys.argv[1],'a').write('\n')
PY2
(cd "$stage" && find . -type f ! -path './metadata/SHA256SUMS' -print0 | sort -z | xargs -0 sha256sum >metadata/SHA256SUMS)
archive="$output_dir/sasd-puppet-audit-${version}-${stamp}.tar.gz"; tar -C "$stage" -czf "$archive" .; chmod 0600 "$archive"; sha256sum "$archive" >"$archive.sha256"; chmod 0600 "$archive.sha256"; printf '%s\n' "$archive"
