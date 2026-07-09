# Security architecture

## Trust boundaries

The control repository can ultimately cause privileged changes on every enrolled node. A merged change, compromised dependency, deployment credential, or Puppet CA key can therefore have broad impact.

## Required controls before production

- protected production branch;
- required review by an authorized maintainer;
- signed or otherwise attributable changes where practical;
- pinned and reviewed dependencies;
- least-privilege r10k deployment credentials;
- restricted access to Puppet Server and CA keys;
- encrypted and separately governed secret storage;
- isolated testing before production promotion;
- backups with tested recovery;
- monitoring of compilation failures and stale agents;
- an emergency stop procedure.

## Certificate authority

The Puppet CA establishes node identity. Its private material must not be stored in this repository. The server milestone must document enrollment, signing, renewal, revocation, backup, restore, and compromise recovery.

## Hiera secrets

Plain YAML files in Git are suitable only for non-sensitive data. A later decision will select an encryption method and define who can decrypt values, where keys are stored, and how rotation works.

## External modules

Every dependency expands the trusted code base. Module review should cover publisher, source repository, release cadence, supported Puppet versions, license, open security issues, and whether the requested functionality justifies the dependency.
