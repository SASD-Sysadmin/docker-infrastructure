# Compliance and drift

Puppet convergence is the primary consistency mechanism. Milestone 5 adds supporting evidence but does not claim that a marker file replaces Puppet reports or the package database.

## Evidence sources

1. Signed node identity and allowlisted role classification.
2. Compiled catalog and configuration version.
3. Puppet report status and event counts.
4. `/etc/sasd/puppet-baseline.conf` for baseline/version evidence.
5. `/etc/sasd/applications.d/assigned.conf` for intended role/profile evidence.
6. Distribution package database for installed package versions.

## Review pattern

- no-op before first apply or role expansion;
- apply only after reviewing package additions/removals;
- confirm a second run reports no changes;
- inspect compact report freshness centrally;
- investigate repeated changes as drift or non-idempotent code;
- never use Puppet to hide a recurring failure with an arbitrary repair command.

## Package compliance

`check_package_policy.rb` enforces sorted non-empty groups, valid package-name syntax, no duplicates inside a group, and no ownership overlap between groups. Platform availability is then verified by container integration and representative test nodes.
