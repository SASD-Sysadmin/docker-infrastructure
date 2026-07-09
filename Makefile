SHELL := /usr/bin/env bash

.PHONY: help setup validate spec catalog test noop

help:
	@printf '%s\n' \
	  'setup     Install the Ruby development dependencies' \
	  'validate  Validate code, metadata, documentation links, and repository structure' \
	  'spec      Run RSpec-Puppet unit tests' \
	  'catalog   Compile the workload-free catalog in no-op mode' \
	  'test      Run the complete Milestone 1 verification suite' \
	  'noop      Run the local apply wrapper in no-op mode'

setup:
	./scripts/setup-development.sh

validate:
	bundle exec rake validate

spec:
	bundle exec rake spec

catalog:
	bundle exec rake catalog

test:
	bundle exec rake

noop:
	./scripts/apply-local.sh
