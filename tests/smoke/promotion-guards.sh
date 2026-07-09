#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; tmp=$(mktemp -d); trap 'rm -rf -- "$tmp"' EXIT
cp -a "$ROOT" "$tmp/repo"; cd "$tmp/repo"
git config user.name 'Milestone 4 Test'; git config user.email 'test@example.invalid'
git switch main >/dev/null
if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  git commit -m 'Milestone 4 fixture state' >/dev/null
fi
base=$(git rev-parse HEAD~1); git branch -f test "$base"; git branch -f production "$base"
printf 'promotion-test\n' >.promotion-test; git add .promotion-test; git commit -m 'Promotion fixture' >/dev/null
./scripts/promote-environment.sh --from main --to test >/dev/null
[[ "$(git rev-parse main)" == "$(git rev-parse test)" ]]
./scripts/promote-environment.sh --from test --to production >/dev/null
[[ "$(git rev-parse test)" == "$(git rev-parse production)" ]]
if ./scripts/promote-environment.sh --from main --to production >/dev/null 2>&1; then echo 'ERROR: direct production promotion accepted' >&2; exit 1; fi
echo 'Promotion guards passed.'
