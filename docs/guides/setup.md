# GermanDactyl Setup (TUI)

GermanDactyl Setup ist ein Skript mit Textoberfläche (TUI), das in einer SSH-Sitzung läuft. Es installiert das Pterodactyl Panel inklusive deutscher Übersetzung (GermanDactyl) und auf Wunsch Wings, sodass du danach direkt deinen ersten Gameserver anlegen kannst. Auch im laufenden Betrieb hilft es dir: mit Updates, Backups, Analyse, Firewall und mehr, alles über ein Menü.

!!! warning "Testphase"
    GermanDactyl Setup befindet sich noch in der Testphase! Es können jederzeit unerwartete Fehler auftreten, auch bei Funktionen, die bereits stabil wirken. Nutze es zuerst auf einem Testserver, erstelle vor Updates und Änderungen immer ein Backup, die Verwendung erfolgt auf eigene Verantwortung.
    Startet das Skript bei dir nicht, eröffne bitte ein [Issue](https://github.com/pavl21/pterodactyl-gui-installer/issues).

!!! info "Voraussetzungen"
    - Debian 12 oder 13 bzw. Ubuntu 22.04, 24.04 oder 26.04 (RHEL, Rocky und Alma werden nicht unterstützt)
    - Root-Rechte (per `sudo` oder als `root`)
    - Eine Domain bzw. Subdomain, deren A-Eintrag auf den Server zeigt
    - Genügend Speicherplatz: Empfohlen sind mindestens 8 GB frei auf `/` (für Panel, Docker-Images und Gameserver)
    - Port 80 und 443 dürfen nicht von einem anderen Webserver belegt sein

    **Cloudflare:** Für das Panel darf der Proxy (orange Wolke) an bleiben, wenn du bei der Installation einen Cloudflare-API-Token angibst. Das Zertifikat wird dann per DNS-Challenge ausgestellt. Wings braucht dagegen immer *DNS only* (graue Wolke) und bei aktivem Proxy eine eigene Subdomain.

## Installation starten

Mit diesem Befehl startest du das Skript:

```shell
sudo bash -c "$(curl -fsSL https://setup.germandactyl.de/)"
```

Läuft auf dem Server schon Pterodactyl, öffnet sich stattdessen direkt die [Verwaltung](#die-verwaltung).

### Was beim ersten Start passiert

1. **Grundpakete:** Fehlende Hilfsprogramme (u. a. `whiptail`, `curl`, `dig`) werden installiert.
2. **Willkommensfenster:** Du bestätigst, dass Pakete installiert werden dürfen, du die Nutzungsbedingungen von Let's Encrypt akzeptierst und die Domain dir gehört.
3. **Vorprüfungen:** Das Skript prüft die IPv4-Verbindung, das Betriebssystem und die CPU-Architektur (amd64 und arm64), die Systemzeit (wird bei Bedarf per NTP synchronisiert), den freien Speicherplatz, ob der Server nur eine private IP hat (Heimnetz/NAT) und ob Port 80/443 frei sind. Läuft dort Apache, bietet es an, ihn zu deaktivieren.
4. **Installationsmenü:** Hier wählst du, was installiert wird.

| Auswahl | Wofür |
| --- | --- |
| Panel + Wings | Empfohlen: alles auf einem Server, sofort einsatzbereit |
| Nur Panel | Wings läuft auf einem anderen Server |
| Nur Wings | Das Panel läuft auf einem anderen Server |
| Pelican Panel + Wings (Beta) | Pelican, der Nachfolger von Pterodactyl |
| Nur Pelican-Wings | Pelican-Panel auf einem anderen Server |

!!! note "Pelican"
    Pelican ist noch eine Beta-Version. Die Verwaltungsfunktionen (Backups, Blueprint, phpMyAdmin usw.) sind nur für Pterodactyl vorgesehen.

### Welche Eingaben nötig sind

Für **Panel + Wings** und **Nur Panel** fragt dich das Skript der Reihe nach:

| Eingabe | Hinweis |
| --- | --- |
| Domain des Panels | Der A-Eintrag muss schon auf den Server zeigen, das wird geprüft |
| SSL-Verfahren | Wird nur bei einer Domain hinter dem Cloudflare-Proxy gefragt: Proxy ausschalten (Webroot) oder Cloudflare-API-Token (DNS-01) |
| E-Mail-Adresse | Für das Let's-Encrypt-Zertifikat und dein Administrator-Konto |
| Benutzername | Für das Administrator-Konto (das Passwort wird zufällig erzeugt) |
| Telemetrie | Ob das Panel anonyme Nutzungsdaten an die Pterodactyl-Entwickler senden darf |
| Panel-Version | Nur, wenn es für die neueste Version noch keine Übersetzung gibt: neueste Version auf Englisch oder neueste übersetzte Version |
| Domain für Wings | Standard ist die Domain des Panels, optional eine eigene Subdomain (bei Cloudflare-Proxy Pflicht) |
| Portbereich | Ports für Gameserver, Standard `25565-25600` (höchstens 1000 Ports, größer als 1024) |
| Absicherung | Firewall, fail2ban, automatische Sicherheitsupdates, tägliche Backups (alles standardmäßig an) |
| Blueprint | Optional: das Framework für Erweiterungen und Themes |

Danach siehst du eine **Zusammenfassung** aller Angaben. Erst wenn du bestätigst, beginnt die Installation. Sie dauert je nach Server 5 bis 20 Minuten. Bricht die SSH-Verbindung ab, wird sie unterbrochen. Starte das Skript bei einer instabilen Verbindung daher in `tmux` oder `screen`. Bricht ein späterer Schritt ab, setzt der nächste Start die Einrichtung mit deinen Angaben fort, statt neu zu installieren.

### Zugangsdaten am Ende

Am Ende erscheinen die Zugangsdaten für das Panel (Adresse, Benutzername, E-Mail, Passwort) und, falls du Backups aktiviert hast, das Passwort des Backup-Archivs.

!!! danger "Nur einmal sichtbar"
    Die Zugangsdaten werden **nur ein einziges Mal** angezeigt. Speichere sie sofort in deinem Passwortmanager. Auf Wunsch legt das Skript sie zusätzlich in `/root/germandactyl-zugangsdaten.txt` ab (nur für root lesbar). Lösche die Datei, sobald du die Daten sicher abgelegt hast.

## Die Verwaltung

Nach der Installation startest du die Verwaltung jederzeit mit `germandactyl`, kurz `gmd` (zusätzlich `gd`). Die Kurzformen werden nur angelegt, wenn der Befehl auf dem Server noch frei ist. `germandactyl` funktioniert immer. Der Befehl lädt jedes Mal die aktuelle Version des Skripts.

### Die Statuszeile

Über dem Hauptmenü zeigt die Statuszeile in zwei Zeilen, wie es deinem Server geht:

| Anzeige | Bedeutung |
| --- | --- |
| **Panel** vX.Y.Z | Installierte Version. Das Häkchen zeigt, dass alle Dienste laufen und das Panel antwortet |
| **Wings** | Läuft der Wings-Dienst? |
| **Zertifikat** | Restlaufzeit des SSL-Zertifikats. Unter 14 Tagen erscheint eine Warnung |
| **Backups** | Zeitpunkt des letzten erfolgreichen automatischen Backups, oder ein Hinweis, wenn es fehlgeschlagen ist, hängt oder noch keins existiert |
| **Firewall** | Ob die Firewall (UFW) aktiv ist |
| **Speicher** | Belegung der Festplatte, ab 90 % als Problem markiert |
| **Auto-Update** | Erscheint, wenn automatische Updates eingeschaltet sind |

Fehlgeschlagene oder übersprungene Updates erscheinen als zusätzliche Zeile. Findet das Skript Probleme, steht ganz oben der Eintrag **„Probleme gefunden – jetzt prüfen und beheben"**, der die Analyse startet. Gibt es eine neuere Panel- oder Wings-Version, erscheint **„Update verfügbar"** und du kannst das Update direkt von dort starten. Die Versionen werden höchstens einmal am Tag abgefragt.

### Hilfe & Analyse

| Menüpunkt | Was passiert |
| --- | --- |
| Analyse starten | Prüft System, Updates, nginx, SSL-Zertifikate (auch die tatsächlich ausgelieferten), Dienste, Panel, Wings, DNS und Backups. Optional misst sie die Internetgeschwindigkeit. Behebbare Probleme kannst du danach automatisch beheben lassen. |
| Ich habe mich ausgesperrt | Legt einen temporären Administrator an, damit du dich anmelden und dein Passwort ändern kannst. Löschen musst du das Konto danach selbst. |
| Das Panel ist fehlerhaft (reparieren) | Spielt die Panel-Dateien neu auf. Deine Daten bleiben erhalten, vorher gibt es automatisch eine Sicherung. |
| Das Panel ist nicht erreichbar | Prüft die Domain und stellt die Webserver-Konfiguration (nginx) wieder her. |
| SSL-Zertifikate prüfen/erneuern | Siehe unten. |
| Logs anzeigen | Zeigt die letzten 300 Zeilen von Panel, Wings, nginx, Queue-Dienst, automatischen Backups oder der letzten Aktion des Skripts. |
| Support-Paket erstellen | Packt Versionen, Dienststatus, Analyse, Konfiguration und Logs in ein Archiv unter `/root`. Passwörter, Schlüssel und Tokens werden entfernt, hochgeladen wird nichts. |

Unter **SSL-Zertifikate** findest du:

| Menüpunkt | Was passiert |
| --- | --- |
| Status anzeigen | Zeigt alle Zertifikate mit Restlaufzeit |
| Erneuerung testen (Dry-Run) | Probelauf der Erneuerung, ohne Limits von Let's Encrypt zu verbrauchen |
| Jetzt erneuern | Erneuert alle fälligen Zertifikate |
| Zertifikat neu ausstellen | Erzwingt ein neues Zertifikat für eine Domain deiner Wahl |
| Automatische Erneuerung einrichten/prüfen | Stellt sicher, dass der `certbot.timer` läuft |

### Aktualisieren

| Menüpunkt | Was passiert |
| --- | --- |
| Panel aktualisieren | Prüft zuerst, ob du Dateien des Panels selbst verändert hast (Themes, Addons). Du kannst sie sichern und danach wieder anwenden lassen. Vor dem Update entsteht automatisch eine Sicherung aus Dateien und Datenbank, schlägt das Update fehl, wird sie zurückgespielt. Ein Wechsel auf eine ältere Version ist nicht möglich. |
| Wings aktualisieren | Installiert die neueste passende Wings-Version. |
| Blueprint aktualisieren | Wendet Blueprint nach einem Update erneut an (nur wenn Blueprint installiert ist). |
| System-Pakete aktualisieren (apt) | Installiert Paket-Updates. Werden Docker-Pakete aktualisiert, starten alle Gameserver kurz neu. |
| Automatische Updates (Panel/Wings) | Richtet einen Timer ein, der Panel und/oder Wings zu einem festen Zeitpunkt aktualisiert. |

!!! warning "Automatische Updates sind standardmäßig aus"
    Beim Einschalten erscheint eine **rote Warnung**: Automatische Updates überschreiben eigene Änderungen am Panel (Themes, Plugins, eigene Patches). Erkennt die Prüfung solche Änderungen, wird das Update übersprungen, außer du wählst „eigene Änderungen wieder anwenden". Vor jedem Panel-Update gibt es eine Sicherung, die bei einem Fehler automatisch zurückgespielt wird. Während des Updates ist das Panel einige Minuten nicht erreichbar. Rückmeldungen findest du nur in der Statuszeile, in der Analyse und im Login-Hinweis, es werden keine E-Mails verschickt.

    Beim Einrichten wählst du, ob Panel, Wings oder beides aktualisiert wird, sowie Wochentag und Uhrzeit. Danach kannst du Status und Einstellungen ansehen, das Update sofort ausführen oder die Automatik ausschalten.

### Backups

Hier gibt es drei Bereiche: automatische Backups, manuelle Panel-Backups und manuelle Gameserver-Backups.

| Menüpunkt | Was passiert |
| --- | --- |
| Automatische Backups | Tägliche, inkrementelle und verschlüsselte Backups mit restic (siehe unten). |
| Panel-Backups (manuell) | Erstellt ein Backup aus Panel-Dateien, Konfiguration und Datenbank. Du kannst es auch wiederherstellen oder alle Backups löschen. |
| Server-Backups (manuell) | Dasselbe für die Daten deiner Gameserver (die Server werden dafür kurz gestoppt). |

Jedes manuelle Backup wird nach dem Erstellen auf Vollständigkeit geprüft und liegt unter `/opt/pterodactyl/backups`.

**Automatische Backups** sichern das Panel, alle Datenbanken samt Benutzern (auch die der Gameserver), Konfigurationen und auf Wunsch die Dateien der Gameserver. Nach dem ersten Lauf werden nur noch Änderungen gespeichert. Aufbewahrt werden 7 tägliche, 4 wöchentliche und 6 monatliche Stände, sonntags wird das Archiv auf Beschädigungen geprüft. Das Menü bietet Status, „Jetzt sichern", Wiederherstellen, Einstellungen (Gameserver mitsichern, Uhrzeit) und Deaktivieren.

=== "Speicherziele"

    | Ziel | Geeignet für |
    | --- | --- |
    | Lokaler Pfad | Ordner oder eingehängtes Laufwerk, z. B. `/mnt/backup` |
    | SFTP | Storage Box oder ein anderer Server per SSH (der Schlüssel muss ohne Passphrase in `/root/.ssh` liegen) |
    | S3 | Amazon S3, Backblaze B2, Wasabi, MinIO und andere |
    | rest-server | Der REST-Server von restic |

=== "Wiederherstellung"

    | Auswahl | Was wird wiederhergestellt |
    | --- | --- |
    | Panel | Dateien, Konfiguration und Panel-Datenbank, bei einem Fehler wird der vorherige Stand zurückgespielt |
    | Einzelne Datenbank | Zum Beispiel die Datenbank eines Gameservers |
    | Gameserver-Dateien | Ein einzelner oder alle Gameserver (Wings wird dafür kurz angehalten) |
    | Konfiguration | nginx, Zertifikate, Wings-Konfiguration, systemd-Units. Der aktuelle Stand wird vorher gesichert. |
    | Datenbank-Benutzer und Rechte | Nur auf Nachfrage |

!!! danger "Passwort des Archivs sicher aufbewahren"
    Das Backup-Archiv ist verschlüsselt. Ohne das Passwort lassen sich die Backups **nicht** wiederherstellen, auch dann nicht, wenn der Server ausfällt. Es wird dir am Ende der Installation einmal angezeigt. Bewahre es getrennt vom Server auf, zusammen mit deinen Zugangsdaten. Ein Backup-Ziel auf derselben Festplatte schützt nicht vor einem Festplattenausfall, nutze besser ein externes Ziel.

### Gameserver & Wings

| Menüpunkt | Was passiert |
| --- | --- |
| Wings installieren/verwalten | Installiert Wings, trägt es als Node im Panel ein und verbindet es. Ist Wings schon da, kannst du es neu starten, aktualisieren, das Log ansehen oder Swap einrichten. |
| Ports für Gameserver freigeben | Legt Ports bzw. einen Portbereich im Panel an und öffnet sie in der Firewall (TCP und UDP). |
| Swap-Speicher verwalten | Erstellt, vergrößert oder entfernt Swap-Speicher als Reserve bei knappem Arbeitsspeicher. |

!!! note "Docker und die Firewall"
    Die Ports laufender Gameserver öffnet Docker selbst, an der Firewall (UFW) vorbei. Sie erscheinen nicht in der Regelliste und lassen sich dort auch nicht schließen. Willst du einen Port sperren, entferne die Port-Zuweisung im Panel.

### Erweiterungen & Aussehen

Dieses Menü gibt es nur, wenn ein Panel auf dem Server liegt.

| Menüpunkt | Was passiert |
| --- | --- |
| Blueprint & Erweiterungen | Installiert Blueprint (falls noch nicht vorhanden), installiert hochgeladene `.blueprint`-Erweiterungen und wendet Blueprint erneut an. |
| Themes / Original-Oberfläche wiederherstellen | Verweist für Themes auf Blueprint und entfernt auf Wunsch ein altes Theme, um die Original-Oberfläche zurückzuholen. |

### Datenbanken

Auch dieses Menü gibt es nur mit Panel.

| Menüpunkt | Was passiert |
| --- | --- |
| phpMyAdmin installieren/aktualisieren | Installiert phpMyAdmin unter `/phpmyadmin` deiner Panel-Domain und legt einen Benutzer an. Es ist öffentlich erreichbar, verwende sichere Passwörter. |
| Database-Host für Gameserver einrichten | Öffnet MariaDB so, dass Gameserver eigene Datenbanken anlegen können, und zeigt dir die Werte für Admin → Databases. Die Datenbank des Panels selbst wird dafür nie verwendet. |

### Server & Sicherheit

| Menüpunkt | Was passiert |
| --- | --- |
| Firewall | Regeln anzeigen, Ports öffnen oder schließen, Firewall ein- oder ausschalten. Beim Einschalten werden SSH, 80 und 443 (mit Wings auch 8080, 2022 und die Gameserver-Ports) automatisch freigegeben. |
| fail2ban | Sperrt IP-Adressen nach wiederholt falschen SSH-Passwörtern. Gesperrte Adressen, z. B. deine eigene, kannst du hier entsperren. |
| Automatische Sicherheitsupdates | Installiert Sicherheitsupdates täglich von selbst, einschließlich PHP aus der Quelle des Panels. Docker-Pakete gehören bewusst nicht dazu, sonst würden alle Gameserver ungeplant neu starten. |
| SSH-Loginseite einrichten/entfernen | Zeigt nach dem SSH-Login eine Übersicht mit Updates, Laufzeit, Netzwerk, letztem Login und Hinweisen zu Backups und Updates. |

### Deinstallieren

Entfernt Panel und/oder Wings (mit Gameservern). Das Skript warnt vorher, bietet eine Sicherung an und verlangt zur Bestätigung einen festen Satz. nginx, MariaDB, PHP, Redis, Docker und vorhandene Zertifikate bleiben installiert, damit andere Dienste nicht beeinträchtigt werden. Wenn du nur die deutsche Übersetzung entfernen willst, lies [Deinstallation](../uninstall.md).

## Kurzbefehle im Terminal

Für häufige Aufgaben musst du das Menü nicht öffnen:

| Befehl | Was passiert |
| --- | --- |
| `gmd` | Öffnet die Verwaltung |
| `gmd analyse` | Startet die Analyse mit Dialogen |
| `gmd analyse --text` | Analyse als reiner Text, ohne Dialoge |
| `gmd analyse --text --fix` | Analyse als Text und behebt alle automatisch behebbaren Probleme |
| `gmd backup` | Öffnet die Backup-Verwaltung |
| `gmd update` | Öffnet das Update-Menü |
| `gmd update panel` / `wings` / `system` | Aktualisiert direkt das Panel, Wings oder die System-Pakete |
| `gmd ssl` | Öffnet die SSL-Zertifikatsverwaltung |
| `gmd wings` | Öffnet die Wings-Verwaltung |
| `gmd firewall` | Öffnet die Firewall-Verwaltung |
| `gmd logs` | Zeigt die Logs |
| `gmd status` | Zeigt die Statuszeile |
| `gmd hilfe` | Zeigt alle Kurzbefehle |

!!! tip "Gleichwertige Befehle"
    `germandactyl` und `gd` sind gleichwertig zu `gmd` (`gd` und `gmd` nur, wenn der Name auf dem Server noch frei war). Alle Beispiele funktionieren auch mit `germandactyl`, etwa `germandactyl update panel`.

Die Analyse lässt sich auch ohne Kurzbefehl starten, zum Beispiel per Cron oder SSH aus einem lokalen Checkout des Repositorys:

```shell
bash analyse.sh --text          # nur prüfen
bash analyse.sh --text --fix    # prüfen und Probleme beheben
```

Die Reihenfolge ist wichtig: `--fix` funktioniert nur direkt nach `--text`.

## Automatik und Sicherheit

- **Backups und Updates:** Das automatische Backup läuft täglich, standardmäßig um 04:00 Uhr. Automatische Panel- und Wings-Updates sind standardmäßig aus.
- **Login-Hinweis (MOTD):** Mit der SSH-Loginseite siehst du nach dem Anmelden, ob das letzte Backup oder Update fehlgeschlagen ist.
- **Logs:** Jede Installation und Aktion wird unter `/var/log/germandactyl-setup/` protokolliert, auch die der automatischen Backups und Updates.
- **Einstellungen:** Das Skript speichert seinen Zustand in `/etc/germandactyl/setup.conf`. Die Datei ist nur für root lesbar.
- **Geprüfte Patches:** Die deutsche Übersetzung wird nur angewendet, wenn die Prüfsumme der Patch-Datei zur Liste `patches/SHA256SUMS` passt. Eine Option zum Überspringen gibt es bewusst nicht.
- **Passwörter:** Zugangsdaten tauchen nie in der Prozessliste auf, und das Support-Paket entfernt Passwörter, Schlüssel und Tokens.

## Fehler melden

Hast du einen Fehler gefunden oder startet das Skript nicht? Eröffne ein [Issue](https://github.com/pavl21/pterodactyl-gui-installer/issues). Hänge am besten das **Support-Paket** an (Verwaltung → Hilfe & Analyse → Support-Paket erstellen). Es enthält die nötigen Infos, und Passwörter und Schlüssel sind bereits entfernt. Prüfe den Inhalt trotzdem kurz, bevor du die Datei weitergibst.

## Verwendete Projekte

Einige Teile des Skripts stammen von anderen Entwicklern oder nutzen deren Software im Hintergrund:

- **Blueprint** ([blueprint.zip](https://blueprint.zip)) ist das Framework für Erweiterungen und Themes.
- **restic** ([restic.net](https://restic.net)) verschlüsselt und speichert die automatischen Backups.
- **Let's Encrypt** stellt über Certbot kostenlose SSL-Zertifikate aus, die 90 Tage gültig sind. Die Erneuerung läuft automatisch über den `certbot.timer`, und GermanDactyl Setup prüft sie in der Analyse. [Zahlreiche Sponsoren](https://letsencrypt.org/de/sponsors/) machen das möglich.
- Die Dokumentation von Pterodactyl findest du unter [docs.pterodactyl.io](https://docs.pterodactyl.io).
