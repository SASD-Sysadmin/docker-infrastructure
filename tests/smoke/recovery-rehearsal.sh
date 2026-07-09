#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
mkdir -p "$t/src/metadata" "$t/src/rootfs/etc/puppetlabs/puppetserver/ca" "$t/src/rootfs/etc/puppetlabs/puppet" "$t/src/rootfs/etc/puppetlabs/code/environments/production"
printf ca >"$t/src/rootfs/etc/puppetlabs/puppetserver/ca/ca_crt.pem"; printf conf >"$t/src/rootfs/etc/puppetlabs/puppet/puppet.conf"; printf site >"$t/src/rootfs/etc/puppetlabs/code/environments/production/site.pp"; printf readme >"$t/src/metadata/README.txt"
(cd "$t/src" && find . -type f ! -path './metadata/SHA256SUMS' -print0 | sort -z | xargs -0 sha256sum >metadata/SHA256SUMS); tar -C "$t/src" -czf "$t/b.tar.gz" .
python3 "$ROOT/scripts/recovery-readiness.py" "$t/b.tar.gz" | grep -q '"ready": true'
"$ROOT/scripts/rehearse-recovery.sh" --archive "$t/b.tar.gz" --target "$t/lab" --confirm-isolated "$t/lab"; [[ -f "$t/lab/RECOVERY-REHEARSAL.txt" ]]
echo 'Recovery rehearsal smoke test passed.'
