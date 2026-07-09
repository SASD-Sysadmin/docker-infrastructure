# Baseline

Milestone 3 keeps the application baseline deliberately unchanged while changing its delivery model. It installs the conservative administration package list and manages `/etc/sasd/puppet-baseline.conf`.

The marker records:

- repository baseline version `0.3.0`;
- operating system and major version;
- trusted certificate name;
- `local-puppet-apply` or `puppet-server` management mode.

Only `package` and `file` resources are allowed by the milestone scope checker. Server installation and certificate operations are explicit control-plane scripts, not hidden catalog resources.
