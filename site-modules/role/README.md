# `role` module

The `role` module describes the intended purpose of a node by composing profile classes. A node should normally receive one role.

Milestone 1 provides `role::baseline`, which includes the workload-free `profile::baseline`. It changes no packages, files, services, users, repositories, or commands.

Rules:

- roles compose profiles;
- roles do not directly manage operating-system resources;
- roles do not contain host-specific data;
- roles should not be nested casually;
- every productive role requires documentation and compilation tests.
