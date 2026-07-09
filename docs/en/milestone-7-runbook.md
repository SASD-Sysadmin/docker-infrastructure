# Milestone 7 runbook

1. Validate the repository: `./scripts/validate.sh --strict`.
2. Register the node with `scripts/manage-node.rb register` and a reviewed role.
3. Create a root-only Puppet Core API-key file on the EL9 node.
4. Run the central-agent bootstrap with `--dry-run`.
5. Run the real bootstrap with `--package-source puppet-core`.
6. Verify the pending CSR on the Puppet Server.
7. Sign exactly one reviewed certname.
8. Run `activate-central-agent.sh --noop --enable-service`.
9. Review package and file changes, then run with `--apply`.
10. Verify `/etc/sasd/puppet-baseline.conf`, `/etc/sasd/platform.d/current.conf`, lifecycle and application markers.
11. Confirm the compact report and fleet-compliance status.
12. Record the enrollment and API-key custody in the operational ticket.

Rollback before activation: clean the CSR/certificate, remove the Puppet Core repo credential and release package, and remove `puppet-agent` according to the distribution's package procedure. Rollback after activation additionally requires retiring or reclassifying the node through the normal lifecycle workflow.
