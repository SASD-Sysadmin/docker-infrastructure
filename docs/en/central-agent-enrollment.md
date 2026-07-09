# Central agent enrollment

## Identity rules

The certname is the long-lived Puppet identity. Use lowercase FQDN-like names containing only letters, digits, dots, underscores, and dashes. Never reuse one certname for two machines.

## Step 1: install and submit CSR

```bash
sudo ./scripts/bootstrap-central-agent.sh \
  --server puppet.example.test \
  --certname node01.example.test \
  --environment production
```

The script installs the agent, writes `puppet.conf`, disables periodic service execution, and runs `puppet ssl bootstrap --waitforcert 0`. A pending CSR is expected.

## Step 2: verify on the server

Before signing, verify that the request belongs to the intended machine through an independent channel: inventory, console session, DNS/IP assignment, and, where available, CSR fingerprints or attributes.

```bash
sudo ./scripts/list-certificates.sh
sudo ./scripts/sign-certificate.sh --certname node01.example.test
```

Never use bulk signing for normal enrollment.

## Step 3: activate

```bash
sudo ./scripts/activate-central-agent.sh --noop --enable-service
```

The no-op catalog must show only expected changes. Enforce manually once approved:

```bash
sudo ./scripts/activate-central-agent.sh --apply --enable-service
```

## Re-enrollment

When replacing a host, first clean the old CA identity with the explicit confirmation wrapper, then run `puppet ssl clean` on the agent and bootstrap again. See [certificate management](certificate-management.md).
