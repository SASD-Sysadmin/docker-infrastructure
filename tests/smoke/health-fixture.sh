#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; tmp=$(mktemp -d); trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/env/production/manifests" "$tmp/ca" "$tmp/state/deployments" "$tmp/state/reports" "$tmp/out"
touch "$tmp/env/production/manifests/site.pp" "$tmp/state/deployments/production.status"
echo certificate >"$tmp/ca/ca_crt.pem"
cat >"$tmp/state/reports/node.json" <<JSON
{"status":"changed"}
JSON
cat >"$tmp/bin/systemctl" <<'SH'
#!/bin/sh
case "$1" in is-active) exit 0;; list-unit-files) exit 1;; *) exit 0;; esac
SH
cat >"$tmp/bin/puppet" <<'SH'
#!/bin/sh
exit 0
SH
chmod +x "$tmp/bin/systemctl" "$tmp/bin/puppet"
SYSTEMCTL_BIN="$tmp/bin/systemctl" PUPPET_BIN="$tmp/bin/puppet" ENVIRONMENT_PATH="$tmp/env" CA_DIR="$tmp/ca" SASD_PUPPET_STATE_ROOT="$tmp/state" SASD_PUPPET_REPORT_DIR="$tmp/state/reports" \
  "${ROOT}/scripts/server-health.sh" --output "$tmp/out/last.json"
python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); assert d["status"]=="ok"' "$tmp/out/last.json"
echo 'Health fixture passed.'
