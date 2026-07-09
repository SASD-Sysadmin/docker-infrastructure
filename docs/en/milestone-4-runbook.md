# Milestone 4 implementation runbook

1. Push `main`, `test`, `production`, and tag `v0.4.0`.
2. Deploy `test` and run fixture plus real test-agent no-op checks.
3. Promote `test` to `production` only after review.
4. Deploy production with r10k.
5. Classify the Puppet Server node as `puppet_server`.
6. Run the server's no-op, then apply and confirm health timer state.
7. Enable `sasd_json` reporting and confirm one test summary.
8. Classify signed agents as `managed_agent`.
9. Configure the reviewed agent interval and confirm idempotency.
10. Create and verify a control-plane backup.
11. Optionally install PuppetDB only after the separate preflight passes.
12. Record versions, backup location, test nodes, and approvals in the change.

Stop and investigate when any certificate identity, CA path, environment mapping,
service state, or validation output differs from the reviewed plan.
