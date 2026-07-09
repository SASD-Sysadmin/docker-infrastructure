# Validierung

`bundle exec rake` führt Format-, Struktur-, Link-, Secret-, Puppet-, RSpec- und Katalogprüfungen sowie alle Bootstrap-Dry-Runs aus. CI testet Puppet 7.23 und 8.10. Eine echte Serverinstallation wird nicht in öffentlicher CI erzeugt, weil Paketquellen Zugangsdaten verlangen können und eine dort erzeugte CA den produktiven Vertrauensprozess nicht sinnvoll prüft.
