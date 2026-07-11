# Netzwerk- und DNS-Anforderungen

Agenten verbinden sich initiierend per TCP auf Port **8140** zum Puppet Server. Der Server benötigt ausgehendes HTTPS für Git und gegebenenfalls Puppet Forge beziehungsweise Paketquellen.

Der auf den Agenten konfigurierte Servername muss im Serverzertifikat als Certname oder DNS-Alternativname enthalten sein. Namen müssen deshalb vor der CA-Erzeugung feststehen.

Korrekte Zeit über NTP/chrony ist für TLS und Reports erforderlich. Die Firewall soll TCP/8140 nur aus vertrauenswürdigen Verwaltungsnetzen zulassen. Milestone 3 dokumentiert diese Regel, verwaltet die Firewall aber noch nicht.
