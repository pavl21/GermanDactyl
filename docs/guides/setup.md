# GermanDactyl Setup (Beta)

Wir möchten mehr als eine Übersetzung bieten und haben uns die Mühe gemacht, den Kern einfacher zu gestalten: die Installation und Verwaltung von Pterodactyl.
Mit diesem Skript setzt du kinderleicht ein Pterodactyl Panel auf. Du brauchst dafür nur einen Linux-Server und eine eigene Domain.

!!! info "Voraussetzungen"
    - Ubuntu 22.04/24.04 oder Debian 11/12/13 (RHEL, Rocky und Alma werden nicht unterstützt)
    - Genügend Speicherplatz (ca. 1 GB für Panel und Wings)
    - Ein frisch aufgesetztes System, auf dem Port 80 nicht belegt ist

## Installation

!!! warning "Beta-Phase"
    Das Skript befindet sich in der Beta-Phase! Es können noch unerwartete Probleme auftreten, die Verwendung erfolgt auf eigene Verantwortung.
    Startet das Skript bei dir nicht, eröffne bitte ein [Issue bei uns](https://github.com/pavl21/GermanDactyl/issues).

Mit diesem Befehl startest du das Skript:

```shell
sudo bash -c "$(curl -sSL https://setup.germandactyl.de/)"
```


## Die Funktionen

### Panel-Installation mit simplen Angaben
![Bild](https://i.imgur.com/7163oVV.png)

Als Erstes kannst du Panel und Wings installieren. Mit nur wenigen Angaben, etwa der Domain und der E-Mail-Adresse für die SSL-Zertifikate von Let's Encrypt, führst du die Installation über eine grafische Oberfläche in einer SSH-Sitzung durch.

### Automatische Kontoerstellung
![Bild](https://i.imgur.com/lkv65jd.png)

Das Konto wird bei der Installation automatisch angelegt, damit du das nicht selbst tun musst. Am Ende bekommst du zufällig generierte Zugangsdaten.

### Wings ganz leicht integrieren
![Bild](https://i.imgur.com/Ca6BrLS.png)

Sobald das Pterodactyl Panel steht, geht es mit Wings weiter. Das kannst du direkt danach erledigen und brauchst nur zwei Angaben (Domain und E-Mail). Außerdem wird erklärt, wie du Wings als Node im Panel anlegst. Damit keine Fehler auftreten, prüft das Skript mit einigen Tests, ob alles richtig eingerichtet ist. Falls nicht, bekommst du (in den meisten Fällen) einen Lösungsvorschlag.

### Allgemeine Verwaltung von Pterodactyl
![Bild](https://i.imgur.com/uYh4sg4.png)

Im laufenden Betrieb möchtest du dir Verwaltung und Wartung sicher leicht machen. Dafür gibt es den Bereich Verwaltung/Wartung: Dort löst du mit einigen Tools häufige Probleme selbst oder installierst auf Wunsch Software und Themes.

!!! info "Info bei fehlerhaften Angaben"
    Es kann sein, dass Angaben fehlen oder nicht mehr stimmen. Sag uns gerne Bescheid, dann korrigieren wir das.

## Verwendete Projekte

Einige Teile des Skripts stammen von anderen Entwicklern oder nutzen deren Software im Hintergrund:

### Farbthemen
Die Farbthemen stammen von [SigmaProduction](https://github.com/Sigma-Production/PteroFreeStuffinstaller)

### Let's Encrypt
Für die SSL-Zertifikate wird Certbot verwendet. [Zahlreiche Sponsoren](https://letsencrypt.org/de/sponsors/) ermöglichen es, dass Let's Encrypt SSL-Zertifikate kostenlos bereitstellt. Die Zertifikate sind 90 Tage gültig und müssen danach erneuert werden – das erledigst du ganz einfach in der Problembehandlung des Skripts.
