# Rollback

Milestone 2 arbeitet additiv: Pakete werden installiert und unter `/etc/sasd`
wird eine Markierungsdatei erzeugt. Dienste werden nicht geändert und Pakete
nicht entfernt.

Vor Apply sollte ein VM-Snapshot erstellt und der Git-Commit dokumentiert
werden. Ein Checkout eines älteren Tags deinstalliert neu hinzugekommene Pakete
nicht, weil keine Abwesenheit deklariert wird.

Die Markierungsdatei darf erst entfernt werden, wenn ihre Puppet-Verwaltung
deaktiviert ist. Paketentfernung bleibt bewusst manuell und muss vorher auf
Abhängigkeiten und tatsächliche Nutzung geprüft werden.
