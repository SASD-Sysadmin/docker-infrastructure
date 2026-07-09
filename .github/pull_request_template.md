## Purpose

Describe the desired-state change and why it belongs in this repository.

## Safety and scope

- [ ] The change is declarative and idempotent.
- [ ] No secret, private key, token, certificate, or sensitive production value is committed.
- [ ] The change belongs in Puppet rather than an incident-response or ad-hoc automation repository.
- [ ] External module versions are pinned.

## Verification

- [ ] `bundle exec rake` passes.
- [ ] Productive changes include unit tests.
- [ ] A no-op result has been reviewed on a representative disposable system.
- [ ] English documentation is updated.
- [ ] German documentation is updated where the operational procedure changed.

## Rollback

Describe how the change can be reverted safely.
