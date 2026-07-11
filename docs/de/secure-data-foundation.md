# Secure-Data-Grundlage – aktiv in Milestone 11

Die per-Node-Hiera-eyaml-Hierarchie ist aktiv. Jeder Puppet-Compiler benötigt
vor Deployment von v0.11.0 `hiera-eyaml` 5.0.1 und das externe PKCS7-Paar.
Fehlende verschlüsselte Dateien sind für Knoten ohne Secret normal.

Hiera-eyaml schützt die Repository-Kopie. `lookup_options` wandelt das Kennwort
in `Sensitive` um und Sensitive-EPP redigiert übliche Reports. Im kompilierten
beziehungsweise gecachten Katalog kann der Klarwert trotzdem vorkommen. Daher
ist nur ein austauschbares maschinenbezogenes APT-Lesekennwort freigegeben.
