# Entwicklung

Der Code unterstützt Puppet 7.23 bis Puppet 8.x. CI testet Puppet 7.23 mit Ruby
3.1 und Puppet 8.10 mit Ruby 3.3. Lokal ist Puppet 8.10 voreingestellt:

```bash
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

Für einen Puppet-7-Lauf:

```bash
PUPPET_GEM_VERSION=7.23.0 bundle install
PUPPET_GEM_VERSION=7.23.0 bundle exec rake
```

Jede Änderung umfasst Code, Hiera, Tests, englische und deutsche Dokumentation
sowie Rollback-Hinweise. Rollen kombinieren Profile; Profile besitzen Ressourcen.
Neue Ressourcentypen benötigen eine Architekturentscheidung und eine Anpassung
der Scope-Prüfung. `exec` ist kein Ersatz für deklaratives Design.
