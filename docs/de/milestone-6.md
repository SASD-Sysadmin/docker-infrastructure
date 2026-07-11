# Milestone 6 — Knoten-Lebenszyklus, Flotten-Compliance und Secret-Grundlage

Milestone 6 macht die geprüften Hiera-Knotendateien zu einem kleinen,
Git-basierten Inventar und ergänzt kontrollierte Zustandsübergänge.

Enthalten sind `active`, `maintenance` und `retired`, ein lebenszyklusabhängiger
Agentdienst, Registrierungs- und Übergangsskripte, Inventar- und
Compliance-Auswertungen, ein abgesicherter Decommission-Ablauf sowie eine
bewusst noch nicht automatisch aktivierte Hiera-eyaml-Grundlage.

Puppet bleibt Sollzustandsverwaltung. Wartungsarbeiten und Reparaturen werden
nicht als beliebige `exec`-Ressourcen in Puppet verlagert.
