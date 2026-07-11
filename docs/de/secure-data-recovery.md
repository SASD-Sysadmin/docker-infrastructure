# Recovery verschlüsselter Daten

Für ein nutzbares Recovery werden Control Repository, passendes PKCS7-Paar und
ein erfolgreicher Entschlüsselungsnachweis benötigt. Das Control-Plane-Backup
enthält `/etc/sasd-puppet`, sofern vorhanden.

1. Backup nur isoliert prüfen und entpacken.
2. Öffentliches und privates PKCS7-Material lokalisieren.
3. RSA-Moduli vergleichen und einen isolierten Roundtrip durchführen.
4. Bei der Probe keine Live-Pfade oder Dienste verändern.
5. Auf einem Ersatz-Compiler Gem und Schlüssel wiederherstellen, `test`
   deployen, den Secret-Verbraucher kompilieren und erst danach promovieren.

Bei Verlust des privaten Schlüssels sind vorhandene Werte nicht wiederherstellbar.
Das externe Kennwort muss ersetzt und mit einem neuen Paar verschlüsselt werden.
