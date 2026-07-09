#!/usr/bin/env bash
# Extract a verified backup into an isolated laboratory directory only.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; archive=''; target=''; confirm=''
usage(){ printf 'Usage: %s --archive FILE --target ABSOLUTE_PATH --confirm-isolated ABSOLUTE_PATH\n' "$0"; }
while (($#)); do case "$1" in --archive) shift; archive="${1:-}";; --target) shift; target="${1:-}";; --confirm-isolated) shift; confirm="${1:-}";; -h|--help) usage; exit 0;; *) usage >&2; exit 64;; esac; shift; done
[[ -f "$archive" && "$target" == /* && "$confirm" == "$target" ]] || { usage >&2; exit 64; }
case "$target" in /|/etc|/var|/opt|/usr|/srv|/root|/home) echo 'Refusing unsafe recovery target' >&2; exit 65;; esac
[[ ! -e "$target" || -z "$(find "$target" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]] || { echo 'Target must be absent or empty' >&2; exit 65; }
python3 "$SCRIPT_DIR/recovery-readiness.py" "$archive" >/dev/null
install -d -m 0700 "$target"; tar -C "$target" -xzf "$archive"
cat >"$target/RECOVERY-REHEARSAL.txt" <<EOF
SASD Puppet isolated recovery rehearsal
Archive: $archive
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
This directory is staging evidence only. Do not bind-mount or copy it over live Puppet paths without an approved recovery change.
Next checks: inspect CA identity, puppet.conf, deployed environments, r10k config, PuppetDB dump, and eyaml key custody.
EOF
chmod 0600 "$target/RECOVERY-REHEARSAL.txt"
printf 'Isolated recovery rehearsal prepared at %s\n' "$target"
