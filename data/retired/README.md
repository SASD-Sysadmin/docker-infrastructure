# Retired node records

This directory stores non-secret classification records for nodes whose Puppet
certificate has been revoked and cleaned. Files are moved here only by the
reviewed decommission workflow and remain subject to Git review.

A retired record is historical evidence. It is not loaded by `hiera.yaml` and
therefore cannot classify an agent.
