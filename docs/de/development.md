# Entwicklungsumgebung

## Unterstützte Grundlage

Milestone 1 zielt auf Puppet 8 und Ruby 3.2 oder 3.3. Die Ruby-Werkzeuge sind in der `Gemfile` festgelegt.

## Vorbereitung

```bash
ruby --version
gem install bundler
./scripts/setup-development.sh
```

Bundler installiert die Abhängigkeiten unter `vendor/bundle`; dieses Verzeichnis wird nicht versioniert.

## Tägliche Befehle

```bash
make help
make validate
make spec
make catalog
make test
```

Oder direkt über Bundler:

```bash
bundle exec rake validate
bundle exec rake spec
bundle exec rake catalog
bundle exec rake
```

## Sichere lokale Puppet-Ausführung

```bash
./scripts/apply-local.sh          # standardmäßig No-op
./scripts/apply-local.sh --noop   # ausdrücklicher No-op
./scripts/apply-local.sh --apply  # ausdrückliche Anwendung
```

In Milestone 1 existieren keine Workload-Ressourcen. In späteren Milestones wird diese Unterscheidung betrieblich entscheidend.
## Reproduzierbare Open-Source-Testwerkzeuge

Das `Gemfile` fixiert Puppet 8.10.0, puppet-lint 5.1.1, RSpec-Puppet 5.0.0 und die zugehörigen Testwerkzeuge. Diese Festlegung beschreibt die öffentliche Ruby-Gem-Testumgebung des Repositorys; die produktiven Versionen von Puppet Server und Agent werden beim Server-Stepstone getrennt ausgewählt und geprüft.

