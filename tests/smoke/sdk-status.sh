#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT
mkdir -p "${tmp}/markers" "${tmp}/bin"
printf 'sdk=java\nexpected_java_major=17\nbuild_tool=maven\n' >"${tmp}/markers/java.conf"
printf 'sdk=php\ncomposer_expected=true\n' >"${tmp}/markers/php.conf"
printf 'sdk=dotnet\nexpected_dotnet_major=10\nrepository_strategy=distribution\n' >"${tmp}/markers/dotnet.conf"
cat >"${tmp}/bin/java" <<'SH'
#!/bin/sh
echo 'openjdk version "17.0.15"' >&2
SH
cat >"${tmp}/bin/javac" <<'SH'
#!/bin/sh
echo 'javac 17.0.15'
SH
cat >"${tmp}/bin/mvn" <<'SH'
#!/bin/sh
echo 'Apache Maven 3.8.7'
SH
cat >"${tmp}/bin/dotnet" <<'SH'
#!/bin/sh
echo '10.0.109'
SH
cat >"${tmp}/bin/php" <<'SH'
#!/bin/sh
echo 'PHP 8.2.28 (cli)'
SH
cat >"${tmp}/bin/composer" <<'SH'
#!/bin/sh
echo 'Composer version 2.5.5'
SH
chmod +x "${tmp}/bin/"*

PATH="${tmp}/bin:${PATH}" python3 \
  "${ROOT}/site-modules/profile/files/sasd-sdk-status.py" \
  --root "${tmp}/markers" --json >"${tmp}/result.json"
python3 - "${tmp}/result.json" <<'PYTEST'
import json
import sys

result = json.load(open(sys.argv[1], encoding="utf-8"))
assert result["status"] == "pass"
assert result["policy_violations"] == []
assert set(result["commands"]) == {"java", "javac", "maven", "dotnet", "php", "composer"}
PYTEST

rm "${tmp}/bin/composer"
if PATH="${tmp}/bin:${PATH}" python3 \
  "${ROOT}/site-modules/profile/files/sasd-sdk-status.py" \
  --root "${tmp}/markers" --json >/dev/null; then
  echo 'ERROR: missing expected Composer was accepted' >&2
  exit 1
fi

cat >"${tmp}/bin/composer" <<'SH'
#!/bin/sh
echo 'Composer version 2.5.5'
SH
cat >"${tmp}/bin/java" <<'SH'
#!/bin/sh
echo 'openjdk version "21.0.7"' >&2
SH
chmod +x "${tmp}/bin/composer" "${tmp}/bin/java"
if PATH="${tmp}/bin:${PATH}" python3 \
  "${ROOT}/site-modules/profile/files/sasd-sdk-status.py" \
  --root "${tmp}/markers" --json >"${tmp}/mismatch.json"; then
  echo 'ERROR: unexpected Java major was accepted' >&2
  exit 1
fi
grep -q 'java major 21 does not match expected 17' "${tmp}/mismatch.json"

cat >"${tmp}/bin/dotnet" <<'SH'
#!/bin/sh
echo '9.0.301'
SH
chmod +x "${tmp}/bin/dotnet"
if PATH="${tmp}/bin:${PATH}" python3 \
  "${ROOT}/site-modules/profile/files/sasd-sdk-status.py" \
  --root "${tmp}/markers" --json >"${tmp}/dotnet-mismatch.json"; then
  echo 'ERROR: unexpected .NET major was accepted' >&2
  exit 1
fi
grep -q 'dotnet major 9 does not match expected 10' "${tmp}/dotnet-mismatch.json"

printf 'SDK status smoke test passed.\n'
