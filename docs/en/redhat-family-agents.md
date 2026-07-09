# AlmaLinux 9 and Rocky Linux 9 agents

## Prerequisites

- supported x86_64 or aarch64 host;
- DNS and TCP/8140 reachability to the Puppet Server;
- a Puppet Forge API key with Puppet Core package access;
- a root-owned key file with no group or world permissions;
- reviewed certname and node-data entry.

```bash
sudo install -o root -g root -m 0600 /dev/null /root/puppet-core-api-key
sudoedit /root/puppet-core-api-key
```

## Dry run

```bash
sudo ./scripts/bootstrap-central-agent.sh   --server puppet.example.test   --certname rocky01.example.test   --package-source puppet-core   --api-key-file /root/puppet-core-api-key   --dry-run
```

A dry run validates arguments and platform policy but deliberately does not read the API-key file.

## Install and submit CSR

```bash
sudo ./scripts/bootstrap-central-agent.sh   --server puppet.example.test   --certname rocky01.example.test   --environment production   --package-source puppet-core   --api-key-file /root/puppet-core-api-key
```

The script installs the EL9 Puppet Core release RPM, stores repository credentials in the generated repo file with mode `0600`, installs `puppet-agent`, disables periodic runs, writes `puppet.conf`, and submits the CSR.

Sign only the exact reviewed certname on the server, then activate with a no-op first.

## Repository credential lifecycle

The repository file contains reusable authentication data and requires restricted handling:

- restrict it to root;
- back it up only through the encrypted control-plane backup process if required;
- rotate the Forge API key outside Puppet and update each enrolled EL9 node;
- remove the repository or credential when the agent package source is retired;
- never include repo files in support bundles without redaction.
