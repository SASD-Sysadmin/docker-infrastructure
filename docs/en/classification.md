# Node classification

Hiera supplies `sasd::role`. `manifests/site.pp` maps the value through an explicit case allowlist. Milestone 3 accepts only `baseline`.

A per-node file is named after the trusted certificate name:

```text
data/nodes/node01.example.test.yaml
```

```yaml
---
sasd::role: baseline
```

Do not dynamically `include` arbitrary class names read from Hiera. A new role requires a manifest case branch, role class, profile composition, tests, documentation, and release review.
