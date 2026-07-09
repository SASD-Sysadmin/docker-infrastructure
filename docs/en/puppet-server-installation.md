# Puppet Server installation

## Supported server platforms

Milestone 3 supports **Debian 12 amd64** and **Ubuntu 24.04 LTS amd64** as Puppet Server hosts. Debian 13 remains an agent platform but is not accepted by the server bootstrap because the server package/support matrix is narrower.

Minimum lab sizing:

- 2 CPU cores;
- 2 GiB RAM recommended, 1 GiB JVM heap configured by default;
- 10 GiB free disk space;
- stable FQDN and forward/reverse DNS;
- synchronized time.

## Pre-flight

Choose the final server certname before initializing the CA. Changing it later requires certificate regeneration. Confirm:

```bash
hostname -f
getent hosts puppet.example.test
ss -ltn | grep ':8140'
```

Back up the active paths reported by `puppet config print confdir`, `codedir`, `ssldir`, and `cadir`. The bootstrap refuses to regenerate an existing CA but it still changes configuration files and packages.


> Distribution packages can use `/etc/puppet`, while Puppet Core packages normally use `/etc/puppetlabs`. The scripts query Puppet for `confdir`, `codedir`, `ssldir`, `cadir`, and `environmentpath` instead of assuming one layout.

## Package sources

### Distribution packages

Default and credential-free:

```bash
sudo ./scripts/bootstrap-server.sh --server-name puppet.example.test
```

This is appropriate for a lab and depends on the versions maintained by the OS distribution.

### Puppet Core packages

Current Puppet Core Apt repositories require an API key. Store only the key in a root-only file:

```bash
sudo install -m 0600 /dev/null /root/puppet-core-api-key
sudoedit /root/puppet-core-api-key
sudo ./scripts/bootstrap-server.sh \
  --server-name puppet.example.test \
  --package-source puppet-core \
  --api-key-file /root/puppet-core-api-key
```

The key is written to `/etc/apt/auth.conf.d/apt-puppetcore.conf` with mode `0600`. It is never logged or passed on the command line.

## Bootstrap actions

The script:

1. validates platform, certname, environment, branch, and memory size;
2. installs prerequisites and selected package source;
3. suppresses premature service startup during a fresh package installation;
4. installs `puppetserver` and `r10k`;
5. detects Puppet's active `confdir` and writes its `puppet.conf` with autosigning disabled;
6. writes `/etc/puppetlabs/r10k/r10k.yaml`;
7. sets the JVM heap in `/etc/default/puppetserver`;
8. initializes a CA only when none exists;
9. deploys `production` through r10k;
10. enables and starts Puppet Server unless `--no-start` is supplied.

Existing configuration files receive a one-time `.pre-sasd` backup.

## Verification

```bash
sudo ./scripts/status-server.sh
sudo systemctl status puppetserver
sudo puppetserver ca list --all
sudo ss -ltnp | grep ':8140'
sudo journalctl -u puppetserver -b
```

Do not enroll agents until the displayed server certname, DNS names, and CA fingerprint have been reviewed.
