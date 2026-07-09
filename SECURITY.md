# Security Policy

## Supported versions

The project is currently scaffolding and has no supported production release. Security fixes will be applied to the default branch until a formal release policy is introduced.

## Reporting a vulnerability

Do not open a public issue for vulnerabilities, leaked credentials, private infrastructure details, or weaknesses that could expose managed systems. Use a private communication channel agreed with the SASD maintainers.

## Repository rules

Never commit:

- passwords or password hashes;
- private SSH, TLS, or Puppet CA keys;
- API keys or access tokens;
- production certificates or certificate signing requests containing sensitive identities;
- unencrypted Hiera secrets;
- database dumps or configuration backups containing credentials;
- real customer, employee, host, network, or inventory data that is not approved for publication.

The `.gitignore` file is only a convenience. It is not a security boundary. Every staged change must be reviewed before committing.

## Future Puppet Server safeguards

Before production use, the project should document and test:

- Puppet CA ownership and offline backup;
- certificate signing and revocation procedures;
- access control for r10k deployment;
- branch protection and mandatory review;
- dependency pinning and provenance;
- secure handling of Hiera secrets;
- server and PuppetDB backup and recovery;
- log retention and protection;
- monitoring for failed or stale agent runs;
- emergency suspension of deployments.

## Dependency security

External modules must be declared in `Puppetfile` with an explicit version or immutable commit reference. New dependencies should be reviewed for maintenance status, licensing, supported Puppet versions, and transitive risk.
