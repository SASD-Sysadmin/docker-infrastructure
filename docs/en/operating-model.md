# Operating model

`main` receives reviewed development, `test` is the pre-production environment,
and `production` is the approved desired state. Operators promote only through
both gates, deploy with r10k, and validate representative agents.

Central agents run through the native package service after certificate approval.
The Puppet Server's own `puppet_server` role installs compact reporting and a
periodic health timer. PuppetDB is optional and must not be treated as a casual
add-on because its availability can affect catalog processing.

Local mode remains a lab/fallback path. A node must never run standalone and
central enforcement concurrently.
