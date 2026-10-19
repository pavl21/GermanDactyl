# Changelog

## [Unveröffentlicht] – Oktober 2026

### Behobene Fehler

- Nach einem Panel-Update konnte die deutsche Übersetzung veraltet bleiben, weil Reste der alten Übersetzung das Anwenden blockierten; der Installer erkennt, sichert und ersetzt diese Reste jetzt selbst.
- Stellen des Patches, die sich nicht anwenden lassen, werden jetzt in allen betroffenen Ordnern eingesammelt, unter `/var/backups/germandactyl` gesichert und am Ende des Installers genannt.
- Die Wiederholung des Builds bei einem OpenSSL-Fehler stützt sich nur noch auf die Ausgabe des aktuellen Laufs und nicht mehr auf ältere Logs.

### Neue Funktionen

- Mit `-y` startet der Installer ohne Wartezeit und beantwortet alle Rückfragen mit Ja.

### Sicherheit

- Der Patch wird nur angewendet, wenn seine SHA-256-Prüfsumme in der Liste `patches/SHA256SUMS` steht; sonst passiert nichts.
- Die Signaturen der Prüfsummenliste sind vollständig entfernt, weil es keinen Schlüssel dafür mehr gibt. Die Liste schützt damit vor beschädigten Downloads, nicht vor einer manipulierten Quelle.

### Verbesserungen und Texte

- Die README war durch vielfach verschachtelte Inhalte über 2 MB groß und ist neu geschrieben; sie verweist jetzt auch auf GermanDactyl Setup.
- Die Übersetzungskorrekturen gelten für alle vier Patches (Panel 1.11.2, 1.11.3, 1.12.2 und 1.15.1): Aus "erzwungen stoppen" wird "zwangsweise beenden", das Wort "Kurzcode" heißt jetzt einheitlich "Kürzel", die Spalte bei API-Schlüsseln heißt "Beschreibung", die Zeitverzögerung ist auf "höchstens 900 Sekunden" begrenzt und Fehlermeldungen der Eingabeprüfung beginnen mit einem großgeschriebenen Feldnamen.
- Die Übersichtsseite zu GermanDactyl Setup ist neu geschrieben und beschreibt Installation, Verwaltung, Kurzbefehle, Automatik und Sicherheit.
- In der Dokumentation sind tote Links ersetzt (u. a. zur Pterodactyl-Dokumentation und zur Lizenz), Schreibfehler korrigiert und Ubuntu 26.04 ergänzt.
- Backups heißen nach Version und Lauf (`install` im Namen); ältere Backups werden weiterhin gefunden.
- Ist die Übersetzung schon angewendet, erkennt der Installer das bereits vor dem Countdown.
- Die Node.js-Mindestversion liest der Installer aus dem Panel selbst (`package.json`) statt einen festen Wert zu verwenden.
- Yarn wird über Corepack ohne Nachfrage eingerichtet, sodass die Installation nicht bei einer Rückfrage hängen bleibt.
- Panels ohne `yarn.lock` (ab Pterodactyl 2.0) werden mit npm gebaut.
- Die Ausgabe jedes Build-Schritts wird ins Log `/var/log/germandactyl.log` geschrieben, damit Fehler leichter zu finden sind.

### Für Entwickler (CI, Tests, Skripte)

- Die CI prüft mit `verify-patches.yml`, dass alle Patches in `SHA256SUMS` stehen und unverändert sind, dass sich jeder Patch auf sein Upstream-Release anwenden lässt (`git apply --check`) und dass die gepatchten PHP-Dateien syntaktisch gültig sind (`php -l`).
- `createPatch.sh` erzeugt Patches als reinen `git diff` ohne Commit-Kopf; derselbe Stand ergibt damit immer dieselbe Datei. Am Ende zeigt das Skript eine Checkliste, welche Stellen zu einer neuen Version gehören.
- `createPatch.sh` kennt keine Signatur-Option mehr; die Prüfsummen werden direkt neu erzeugt.

### Hinweise zum Einsatz

- Bereits angewendete Übersetzungen aktualisiert der Installer nicht von allein: Die Korrekturen kommen mit einem Panel-Update bzw. einer neuen Anwendung des Patches.
- Die Skripte wurden mit einer Syntaxprüfung (`bash -n`) und mit shellcheck (Fehlerstufe) geprüft. Ein vollständiger Installationslauf mit den neuen Patches ist im Repository nicht belegt; teste zuerst auf einem Testserver.
- GermanDactyl Setup, das Einrichtungswerkzeug für den Server (eigenes Repository), ist noch in der Testphase.
