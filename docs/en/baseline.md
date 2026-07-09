# Baseline

Milestone 5 retains the conservative common baseline and adds opt-in application
profiles. `/etc/sasd/puppet-baseline.conf` records version `0.5.0`, platform,
trusted certname, and management mode. Central roles additionally write
`/etc/sasd/applications.d/assigned.conf` with non-secret intended role/profile
evidence.

Common packages include CA certificates, curl, Git, jq, Python 3, rsync, tree,
unzip, plus Debian-family process/open-file tools. Administration, development,
and container packages are installed only by roles that compose their profiles.

Central roles keep the Puppet agent service running only after remote certificate
authentication.
