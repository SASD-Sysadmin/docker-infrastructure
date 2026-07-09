# Network and DNS requirements

## Required connectivity

Agents initiate TCP connections to Puppet Server port **8140**. The server needs outbound HTTPS for Git and, depending on package/module sources, Puppet Forge/package repositories. Agents using distribution packages need their normal OS repositories.

## DNS

The name configured as `server` on every agent must be present in the Puppet Server certificate as its certname or DNS alternative name. Decide names before CA initialization.

Recommended records:

```text
puppet.example.test.  A/AAAA  <server address>
node01.example.test.  A/AAAA  <agent address>
```

Forward and reverse resolution should be consistent where operational policy requires it. Puppet itself relies primarily on the configured server name and certificates, but inconsistent DNS makes diagnosis and identity review harder.

## Time

TLS validity and report chronology depend on correct clocks. Provide NTP/chrony before enrollment.

## Firewall policy

Allow agents to reach server TCP/8140. Do not expose the port broadly to untrusted networks. Milestone 3 documents but does not manage firewall rules.

## Proxy

If Git, Forge, or package repositories require a proxy, configure it explicitly at the operating-system/tool level and ensure credentials are not embedded in the control repository.
