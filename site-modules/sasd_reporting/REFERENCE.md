# Reference

## Report processor `sasd_json`

Writes atomic, mode `0640` JSON summaries containing node, environment,
configuration version, run status, timestamps, noop state, and aggregate event
counts. The destination can be overridden by the environment variable
`SASD_PUPPET_REPORT_DIR` in the Puppet Server service environment.
