#!/usr/bin/env bash
# Deactivate one retired node in PuppetDB; never delete its historical data.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"; cert=''; confirm=''; apply=false
usage(){ printf 'Usage: %s --certname NAME --confirm NAME [--apply]\n' "$0"; }
while (($#)); do case "$1" in --certname) shift; cert="${1:-}";; --confirm) shift; confirm="${1:-}";; --apply) apply=true;; -h|--help) usage; exit 0;; *) usage >&2; exit 64;; esac; shift; done
[[ "$cert" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*$ && "$confirm" == "$cert" ]] || { usage >&2; exit 64; }
record="$ROOT/data/retired/$cert.yaml"; [[ -f "$record" ]] || { echo "Retired record not found: $record" >&2; exit 66; }
if [[ "$apply" == false ]]; then echo "DRY-RUN: puppet node deactivate $cert"; exit 0; fi
command -v puppet >/dev/null || { echo 'puppet command not found' >&2; exit 127; }
puppet node deactivate "$cert"
printf 'PuppetDB node deactivated: %s\n' "$cert"
