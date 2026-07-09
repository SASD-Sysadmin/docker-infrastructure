# Architecture

## Scope

`puppet-software-baseline` is the source of truth for the desired software and configuration state of SASD-managed systems. It focuses on persistent configuration, not one-time operational procedures.

## Logical components

### Control repository

The Git repository contains environment manifests, organization-specific modules, Hiera data, dependency declarations, documentation, and future validation tooling.

### Puppet Server

The future central server will retrieve deployed environments through r10k, compile catalogs from manifests, modules, Hiera data, and node facts, and serve those catalogs to authenticated agents.

### Puppet Agents

Agents gather facts, authenticate using Puppet certificates, request a catalog, apply required changes, and report the result. They will not normally clone this repository.

### r10k

r10k will transform approved Git branches into Puppet environments and install dependencies declared in `Puppetfile`.

### PuppetDB

PuppetDB is optional for the first server milestone. It may later store facts, catalogs, and reports and enable inventory and cross-node queries.

## Code organization

The project will use the roles-and-profiles pattern:

- a **profile** owns the technical implementation of a coherent concern;
- a **role** composes profiles for a node purpose;
- a node should normally be assigned one role;
- Hiera supplies data to parameterized classes.

## Classification

The initial Hiera hierarchy anticipates an `sasd_role` fact, but its source is not yet selected. Options include a trusted external fact, an extension in the provisioning process, or another documented classifier. Productive code must not depend on it until the decision is finalized.

## Environments

The first repository branch is `main`. A future r10k design will define how approved and temporary branches map to Puppet environments. Production naming, promotion, retention, and deletion rules remain open design items.

## Failure domains

The architecture must account for:

- unavailable Git hosting;
- failed r10k deployment;
- Puppet Server outage;
- Puppet CA loss or compromise;
- invalid code that cannot compile a catalog;
- agent systems that stop checking in;
- dependencies removed or changed upstream.

Future server documentation will define local caching behavior, backup, recovery, monitoring, and emergency deployment suspension.
