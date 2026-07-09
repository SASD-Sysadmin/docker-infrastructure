# `profile` module

The `profile` module contains SASD-owned implementation classes. A profile manages one coherent technical capability and may wrap one or more third-party modules.

Milestone 1 provides only `profile::baseline`, an intentionally empty class used to prove compilation and test wiring. It changes no system state.

Rules:

- profiles may include or declare other profiles only when the dependency is technically unavoidable;
- profiles must never include roles;
- profile parameters should use typed Puppet signatures;
- environment-specific values should be obtained through Automatic Parameter Lookup/Hiera;
- every productive profile requires class documentation and unit tests;
- secrets must never be committed in clear text.
