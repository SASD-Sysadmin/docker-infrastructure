# Baseline

Milestone 7 behält die konservative Paket-/Datei-Basis und die geprüften
Anwendungsprofile. `/etc/sasd/puppet-baseline.conf` enthält Version `0.9.0`,
Plattform, Verwaltungsart und vertrauenswürdigen Certname.

Zentrale Rollen schreiben zusätzlich den Anwendungsnachweis unter
`/etc/sasd/applications.d/assigned.conf` und den Lebenszyklusnachweis unter
`/etc/sasd/lifecycle.d/state.conf`. Diese Dateien enthalten keine Secrets und
ersetzen weder Puppet-Reports noch die Paketdatenbank.
