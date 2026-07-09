# Environments und Promotion

```text
main -> test -> production
```

r10k bildet jeden Branch auf das gleichnamige Puppet-Environment ab. Promotion
erfolgt ausschließlich per Fast-Forward.

```bash
./scripts/promote-environment.sh --from main --to test --full-validation
./scripts/promote-environment.sh --from main --to test --push
sudo ./scripts/deploy-environment.sh --environment test --branch test

./scripts/promote-environment.sh --from test --to production --full-validation
./scripts/promote-environment.sh --from test --to production --push
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Verboten sind Force-Pushes, direkte Promotion von `main` nach `production`,
abweichende Branch-/Environment-Namen und ungeprüfte automatische Deployments.
