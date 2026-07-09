# Baseline

Milestone 4 retains the conservative package/file baseline and adds controlled
service consistency for centrally managed nodes. The marker contains version
`0.4.0`, platform, trusted certname, and management mode.

Common packages include CA certificates, curl, Git, jq, Python 3, rsync, tree,
unzip, plus Debian-family process/open-file tools. New packages require support
on every targeted platform or explicit Hiera separation.

`role::managed_agent` and `role::puppet_server` keep the Puppet agent service
running only after remote certificate authentication.
