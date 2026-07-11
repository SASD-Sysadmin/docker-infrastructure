#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; tmp="$(mktemp -d)"; trap 'rm -rf -- "$tmp"' EXIT
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 1 -subj '/CN=test/' -keyout "$tmp/private_key.pkcs7.pem" -out "$tmp/public_key.pkcs7.pem" >/dev/null 2>&1
# Stub workstation eyaml so verification can exercise key and policy checks offline.
mkdir "$tmp/bin"; cat >"$tmp/bin/eyaml" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod +x "$tmp/bin/eyaml"
PATH="$tmp/bin:$PATH" "$ROOT/scripts/verify-hiera-eyaml.sh" --mode workstation --key-directory "$tmp" | grep -q 'verification passed'
rotation="$tmp/rotation-candidate"
"$ROOT/scripts/stage-hiera-eyaml-key-rotation.sh" --current-key-directory "$tmp" --output-directory "$rotation" --confirm "$rotation" | grep -q 'Candidate keypair staged'
[[ -s "$rotation/rotation.json" && -s "$rotation/private_key.pkcs7.pem" ]]
printf 'Hiera-eyaml operations smoke test passed.
'
