# Operating model

## Milestone 1

Developers validate locally and through GitHub Actions. The only catalog is a workload-free baseline catalog. There is no unattended enforcement.

## Development flow

```text
feature branch -> bundle exec rake -> pull request -> review -> main
```

## Future production flow

```text
GitHub main -> r10k / Code Manager -> production environment
             -> Puppet Server -> authenticated agent catalogs
```

Agents will not clone the control repository. The server deploys code, compiles catalogs from trusted facts and Hiera, and serves them over authenticated TLS.

## Change boundary

Puppet owns persistent desired state. Incident diagnosis, temporary repairs, one-time migrations, and procedural troubleshooting remain outside this repository unless a durable baseline requirement emerges from them.
