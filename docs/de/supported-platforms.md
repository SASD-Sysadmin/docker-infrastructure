# Unterstützte Plattformen

| Betriebssystem | Release | Paketquelle | Puppet-Reihe |
|---|---|---|---|
| Debian | 12 Bookworm | Debian | 7.23 |
| Debian | 13 Trixie | Debian | 8.10 |
| Ubuntu | 24.04 LTS Noble | Ubuntu Universe | 8.4 |

Der Bootstrap prüft `/etc/os-release`; das Profil prüft Puppet-Fakten. Beide
Grenzen sind notwendig. Architekturen sind nicht fest codiert; die tatsächliche
Verfügbarkeit hängt von den Paketquellen der Distribution ab.
