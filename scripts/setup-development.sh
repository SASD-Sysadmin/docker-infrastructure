#!/usr/bin/env bash
# Install the repository-local Ruby development dependencies.
# This script changes only the working copy's vendor/bundle directory.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
readonly REPOSITORY_ROOT

cd "${REPOSITORY_ROOT}"

if ! command -v ruby >/dev/null 2>&1; then
  printf 'ERROR: Ruby 3.1 through 3.4 is required.\n' >&2
  exit 1
fi

if ! command -v bundle >/dev/null 2>&1; then
  printf 'ERROR: Bundler is not installed. Install it with: gem install bundler\n' >&2
  exit 1
fi

bundle config set --local path 'vendor/bundle'
bundle install
printf 'Development dependencies installed. Run: bundle exec rake\n'
