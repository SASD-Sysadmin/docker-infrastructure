# frozen_string_literal: true

# r10k installs every external dependency declared here into ./modules.
# Generated module content is never committed to this control repository.
forge 'https://forge.puppet.com'

# Milestone 11 keeps the active SASD catalog on Puppet built-in resource types.
# Application profiles use built-in package resources. PuppetDB remains an explicitly optional control-plane component and is
# bootstrapped outside r10k with a pinned puppetlabs-puppetdb module version.
# This prevents an unused reporting stack from expanding every environment.
