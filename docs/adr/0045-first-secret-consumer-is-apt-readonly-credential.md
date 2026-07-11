# ADR 0045: First secret consumer is an APT read-only credential

The first consumer is restricted to one Debian APT auth file at a fixed path.
It neither configures repository trust nor installs packages. The credential
must be machine-scoped, replaceable, and read-only.
