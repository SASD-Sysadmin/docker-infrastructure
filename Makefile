SHELL := /usr/bin/env bash
.PHONY: help setup validate spec catalog bootstrap test noop status
help:
	@printf '%s\n' \
	  'setup      Install Ruby development dependencies' \
	  'validate   Validate source, docs, metadata, and Milestone 2 scope' \
	  'spec       Run RSpec-Puppet unit tests' \
	  'catalog    Compile all supported fixture catalogs in no-op mode' \
	  'bootstrap  Run bootstrap dry-run tests' \
	  'test       Run the complete Milestone 2 verification suite' \
	  'noop       Preview the local host catalog' \
	  'status     Display local baseline status'
setup:
	./scripts/setup-development.sh
validate:
	bundle exec rake validate
spec:
	bundle exec rake spec
catalog:
	bundle exec rake catalog
bootstrap:
	bundle exec rake bootstrap
test:
	bundle exec rake
noop:
	./scripts/apply-local.sh --noop
status:
	./scripts/status-local.sh
