# Maintenance windows

1. Create or reference an approved change ticket.
2. Set the node to maintenance with a precise UTC expiry.
3. Validate and promote the change.
4. Run the agent explicitly once so the maintenance catalog is applied.
5. Confirm `/etc/sasd/lifecycle.d/state.conf` and the stopped agent service.
6. Perform maintenance through the appropriate operational tooling—not through
   arbitrary Puppet `exec` resources.
7. Change the node back to active, validate, and promote.
8. Run `puppet agent -t`, inspect the report, then confirm the regular service.

Expired maintenance is a fleet-compliance warning and must be resolved; it is
not automatically extended.
