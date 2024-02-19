
# GermanDactyl Setup - (Beta)

Wir möchten mehr als eine Übersetzung bieten, und haben uns die Mühe gemacht den Kern einfacher zu gestalten: Die Installation und Verwaltung von Pterodactyl.
Mithilfe dieses Scriptes kannst du kinderleicht ein Pterodactyl Panel aufsetzen, du benötigst dazu nur einen Linux Server und eine eigene Domain.

!!! info "Voraussetzungen"
    - Debian 11, andere sind nicht mit Whiptail kompaibel
    - Genügend Speicherplatz (ca. 1GB für das Panel und Wings)
    - Ein frisch aufgesetztes System, wo Port 80 nicht verwendet wird.

## Installation

!!! warning "Beta-Phase"
    Das Script befindet sich in der Beta-Phase! Es können noch unerwartet Probleme auftreten, die Verwendung unterliegt deiner Verantwortung.

Mit diesem Befehl kannst du das Script starten:
```
curl -sSL https://setup.germandactyl.de/ | sudo bash -s --
```


## Die Funktionen

### Panel-Installation mit simplen Angaben
![Bild](https://i.imgur.com/7163oVV.png)

Das erste, was man tun kann, ist die Installation des Panel und Wings. Mit nur einigen Angaben, wie die Domain oder E-Mail Adresse für die SSL-Zertifikate von Let's Encrypt, kann man über eine grafische Übersicht in einer SSH-Sitzung die Installation durchführen.

### Automatische Account-Erstellung
![Bild](https://i.imgur.com/lkv65jd.png)

Der Account wird bei der Installation automatisch angelegt, damit du das nicht tun musst. Du bekommst am Ende eigene zufällig generierte Zugangsdaten.

### Wings ganz leicht integrieren
![Bild](https://i.imgur.com/Ca6BrLS.png)

Sobald das Pterodactyl Panel steht, kann mit der Installation von Wings fortgefahren werden. Das kannst du direkt nach danach machen und benötigst nur 2 Angaben (Domain und E-Mail). Zudem wird auch erklärt, wie du Wings als Node im Panel erstellst. Und damit keine Fehler auftreten, prüft das Script mit einigen Tests ob du alles richtig gemacht hast. Wenn nicht, wird dir eine Problemlösung gegeben (nicht bei jedem Fall).

### Allgemeine Verwaltung von Pterodactyl
![Bild](https://i.imgur.com/uYh4sg4.png)

Nach dem Aufsetzen einiger Server in Pterodactyl oder dem Betrieb im allgemeinen fragt man sich schon, wie man sich die Verwaltung und Wartung leicht machen kann. Dafür haben wir die Pterodactyl Verwaltung/Wartung. Dort kannst du mit Tools einige allgemeine Probleme selbst lösen oder Software bzw. Themes auf Wunsch integrieren.

<br>

!!! info "Info bei fehlerhaften Angaben"
    Es kann sein, das Angaben fehlen. Diesem Fehler gehen wir gerne nach und korrigieren es, sofern wir davon erfahren.

# Verweise auf Teile des Scripts

Einige Teile des Scripts stammen von anderen Entwicklern, hier wird dann der Entwickler erwähnt. Hierzu gehören auch die, die im Hintergrund verwendet werden.

## Color-Themes
Die Farbthemen bei den Themes stammen von dem Entwickler  [SigmaProduction](https://github.com/Sigma-Production/PteroFreeStuffinstaller)

## Let's Encrypt
Damit die SSL Zertifikate zur Verfügung gestellt werden können, wird Certbot verwendet. [Mehr als 100 Sponsoren](https://letsencrypt.org/de/sponsors/), darunter auch Google und Amazon, ermöglichen es, das SSL Zertifikate kostenlos zur Verfügung gestellt werden können. Hierbei gilt zu beachten, das die bereitgestellten Zertifikate 90 Tage gelten, danach müssen sie erneuert werden. Das kannst du aber in der Problembehandlung ganz einfach erneuern lassen. 
