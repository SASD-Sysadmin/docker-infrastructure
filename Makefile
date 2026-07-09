SHELL := /usr/bin/env bash
.PHONY: help setup validate spec catalog bootstrap test noop status server-status
help:
	@printf '%s\n' 'setup Install Ruby dependencies' 'validate Validate Milestone 4 source and security boundaries' 'spec Run RSpec-Puppet' 'catalog Compile fixture catalogs' 'bootstrap Run all operational smoke tests' 'test Run complete suite' 'noop Preview local catalog' 'status Show local status' 'server-status Show Puppet Server status'
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
server-status:
	./scripts/status-server.sh
