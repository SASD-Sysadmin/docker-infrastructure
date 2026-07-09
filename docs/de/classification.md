# Klassifizierung

In Milestone 2 weist `manifests/site.pp` jedem Knoten `role::baseline` zu. Das
Profil prüft anschließend anhand strukturierter `os`-Fakten, ob die Plattform
unterstützt wird. Dies ist eine kontrollierte Übergangslösung für ein kleines
Labor und nicht das endgültige Flottenmodell.

Später kann Puppet Server über vertrauenswürdige Zertifikatsnamen, ein geprüftes
Rollen-Fact oder einen External Node Classifier klassifizieren. Ein Knoten
bekommt eine primäre Rolle, Rollen kombinieren Profile und knotenspezifische
Hiera-Daten bleiben die Ausnahme.
