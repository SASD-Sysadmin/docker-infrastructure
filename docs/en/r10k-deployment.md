# r10k deployment and environments

## Branch model

- `main`: integration branch; pull requests and CI converge here first.
- `production`: approved release branch; r10k maps it to the `production` environment.
- feature branches: may be tested in development, but are not automatically deployed by Milestone 3.

r10k maps branch names to directory environments. Therefore branch and environment names must match. The deployment wrapper rejects a different pair.

## Release flow

```bash
git checkout main
git pull --ff-only
bundle exec rake

git checkout production
git merge --ff-only main
git push origin production

sudo ./scripts/deploy-environment.sh   --environment production   --branch production
```

For a production promotion, prefer a signed/annotated version tag on the same commit.

## r10k configuration

`/etc/puppetlabs/r10k/r10k.yaml` defines the Git remote and the environment basedir detected from Puppet's active `codedir`. Purging is enabled at deployment, environment, and Puppetfile levels. Therefore generated or hand-edited content in a deployed environment is disposable.

## Deployment safety

The wrapper:

- validates environment/branch names;
- takes `/run/lock/sasd-puppet-r10k.lock`;
- deploys one explicit environment with `--puppetfile`;
- verifies required environment files;
- runs `puppet parser validate` on deployed manifests;
- records a timestamp under `/var/lib/sasd-puppet/deployments`.

Milestone 3 intentionally has no timer or webhook. A reviewed human action triggers production deployment. During server bootstrap, a stable copy of the wrapper is installed below `/usr/local/libexec/sasd-puppet/`, together with the manual `sasd-puppet-deploy.service` oneshot unit. It can be started explicitly with:

```bash
sudo systemctl start sasd-puppet-deploy.service
```

The unit is installed but not enabled and has no timer.

## Rollback

Move `production` to a previously tested commit, push it according to your branch protection policy, and redeploy. Do not repair generated environment files by hand.
