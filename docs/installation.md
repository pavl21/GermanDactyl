# Installation

!!! warning "Möglicherweise nicht mit allen Add-ons kompatibel"
    GermanDactyl verwendet Patches, um die Oberfläche zu übersetzen. Hast du vorher schon Plugins oder Themes
    installiert, die die Oberfläche verändern, kann es sein, dass einige Dateien nicht gepatcht werden können.

## Voraussetzungen

- Pterodactyl Panel, installiert nach der [offiziellen Anleitung](https://pterodactyl.io/panel/1.0/getting_started.html) (Release-Tarball)
- Ubuntu 22.04/24.04 oder Debian 11/12/13
- PHP 8.2 oder 8.3
- Node.js ≥ 22 (wird bei Bedarf automatisch installiert)
- Mindestens 2 GB RAM (oder entsprechend Swap) für den Build
- Root-Rechte

!!! info "Panel per Git installiert?"
    Wurde das Panel per Git statt per Release-Tarball installiert, meldet es die Version `canary`. Dann musst du die
    Version mit `-v <version>` angeben.

## Unterstützte Versionen

| Pterodactyl Panel | GermanDactyl-Patch |
| --- | --- |
| 1.11.2 | v1.11.2 |
| 1.11.3 | v1.11.3 |
| 1.12.2 | v1.12.2 |
| 1.13.x, 1.14.x, 1.15.0 | kein eigener Patch |
| 1.15.1 (aktuell) | v1.15.1 |

Nutzt du 1.13.x, 1.14.x oder 1.15.0, [aktualisiere dein Panel](guides/update.md) am besten zuerst auf 1.15.1.

## Der einfache Weg

Füge den folgenden Befehl in die Konsole deines Servers ein. GermanDactyl installiert sich dann automatisch.

=== ":material-flash: Normale Installation"
    ```shell
    curl -sSL https://install.germandactyl.de/ | sudo bash -s --
    ```

=== ":material-folder: Ordner auswählen"
    ```shell
    curl -sSL https://install.germandactyl.de/ | sudo bash -s -- -d /var/www/pterodactyl -y
    ```

=== ":material-update: Version erzwingen"
    ```shell
    curl -sSL https://install.germandactyl.de/ | sudo bash -s -- -v 1.15.1
    ```
    !!! warning "Auf eigenes Risiko"
        Nutze `-v` nur, wenn die vom Panel gemeldete Version nicht stimmt (z. B. `canary`). Ein Patch für eine andere
        Panel-Version passt meist nicht vollständig.

### Optionen

| Option | Bedeutung |
| --- | --- |
| `-d <pfad>` | Pfad zum Panel (Standard: `/var/www/pterodactyl`) |
| `-v <version>` | Patch-Version erzwingen |
| `-y` | ohne 10-Sekunden-Wartezeit starten |
| `-u` | GermanDactyl deinstallieren (zurück auf Englisch), siehe [Deinstallation](uninstall.md) |
| `-h` | Hilfe anzeigen |

### Was der Installer macht

1. **Prüfungen:** Root-Rechte, Panel-Pfad, Panel-Version, Distribution (Debian/Ubuntu), Node.js ≥ 22 (sonst wird Node 22 über NodeSource installiert) und Yarn.
2. **Backup** nach `/var/backups/germandactyl/`.
3. **Wartungsmodus** einschalten.
4. **Patch** herunterladen, prüfen und anwenden.
5. **Sprache umstellen:** Panel-Standardsprache und alle bestehenden Benutzer auf Deutsch, neue Benutzer bekommen ebenfalls Deutsch.
6. **Build** der Oberfläche mit Yarn.
7. **Cache leeren** und **Rechte setzen**, danach Wartungsmodus beenden.

Schlägt der Build fehl, wird das Backup automatisch wiederhergestellt. Alle Ausgaben landen in
`/var/log/germandactyl.log` (Fallback: `germandactyl.debug.log` im Panel-Ordner).

!!! tip "Sprache pro Benutzer"
    Unter **Admin → Benutzer** kannst du die Sprache einzelner Benutzer wieder auf Englisch stellen. Die fest
    eingebauten Oberflächentexte bleiben jedoch deutsch.

## Patches manuell anwenden

Funktioniert die automatische Installation bei dir nicht (z. B. weil deine Distribution nicht unterstützt wird),
kannst du den Patch auch manuell anwenden. Im Beispiel liegt das Panel unter `/var/www/pterodactyl`.

1. Lege ein Backup an und lade den Patch passend zu deiner Panel-Version herunter:
    ```shell
    cd /var/www/pterodactyl
    tar czf /root/panel-backup.tar.gz .
    curl -fsSL https://patch.germandactyl.de/1.15.1 -o /tmp/germandactyl.patch
    ```

2. Installiere bei Bedarf Node.js 22, Yarn und Git:
    ```shell
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs git
    npm install -g yarn
    ```

3. Prüfe den Patch und wende ihn an:
    ```shell
    git apply --check /tmp/germandactyl.patch
    git apply --reject /tmp/germandactyl.patch
    ```

4. Baue die Oberfläche neu und leere den Cache:
    ```shell
    yarn install --frozen-lockfile
    yarn run build:production
    php artisan view:clear && php artisan config:clear
    chown -R www-data:www-data /var/www/pterodactyl/*
    ```

5. Stelle die Sprache ein: `APP_LOCALE=de` in der `.env` setzen und unter **Admin → Benutzer** die Sprache der
   Benutzer auf Deutsch stellen.

Das war's – dein Pterodactyl Panel ist jetzt auf Deutsch. :)
