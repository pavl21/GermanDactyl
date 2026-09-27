# Skripte

In diesem Ordner liegen die Skripte für die Installation von GermanDactyl und für das Erstellen neuer Patches.

| Skript | Zweck |
| --- | --- |
| [install.sh](install.sh) | Installiert GermanDactyl in einem bestehenden Panel oder entfernt es wieder (`-u`) |
| [startPatching.sh](startPatching.sh) | Wechselt in den Patch-Modus, um eine neue Panel-Version zu übersetzen |
| [createPatch.sh](createPatch.sh) | Erstellt aus den Änderungen den neuen Patch und verlässt den Patch-Modus |
| [installAddon.sh](installAddon.sh) | **[Nicht fertig]** Installiert ein Addon |

## install.sh

```bash
curl -fsSL https://install.germandactyl.de | sudo bash -s -- [Optionen]
```

| Option | Bedeutung |
| --- | --- |
| `-d <pfad>` | Pfad zum Panel (Standard: `/var/www/pterodactyl`) |
| `-v <version>` | Patch für diese Version verwenden, z. B. `-v 1.15.1`. Nötig bei Git-Installationen, die als `canary` erscheinen |
| `-u` | GermanDactyl entfernen und zurück zu Englisch wechseln |
| `-y` | Ohne 10 Sekunden Wartezeit starten |
| `-h` | Hilfe anzeigen |

Voraussetzungen: root-Rechte, PHP 8.2/8.3, etwa 2 GB RAM (inkl. Swap) für den Build. Node.js ≥ 22, Yarn und Git installiert das Skript unter Debian/Ubuntu bei Bedarf selbst. Auf anderen Systemen musst du sie vorher selbst installieren.

Das Skript

- lädt den passenden Patch und prüft ihn mit `git apply --check`. Ist er schon installiert, bricht es ohne Änderungen ab.
- sichert `app`, `resources`, `public`, `database`, `routes` und `config` nach `/var/backups/germandactyl/`.
- versetzt das Panel während der Arbeiten in den Wartungsmodus.
- wendet den Patch an und baut das Panel neu (`yarn install --frozen-lockfile`, `yarn run build:production`).
- setzt die Sprache auf Deutsch: `APP_LOCALE=de` in der `.env`, `settings::app:locale` in der Datenbank, und alle Benutzer mit Englisch werden auf Deutsch umgestellt.
- leert die Caches, setzt die Dateirechte und startet die Queue-Worker neu.

Schlägt der Build fehl, spielt das Skript das Backup automatisch zurück. Alle Ausgaben landen in `/var/log/germandactyl.log`.

## Neuen Patch erstellen

```bash
./scripts/startPatching.sh [version]   # z. B. v1.15.1, Standard: neuestes Release
# Übersetzungen in resources/, app/ usw. anpassen, .rej-Dateien einarbeiten und löschen
./scripts/createPatch.sh [version]     # Standard: Version aus startPatching.sh
```

`startPatching.sh` bricht ab, wenn du nicht auf `main` bist, dein Arbeitsverzeichnis nicht sauber ist oder der Branch `patches` bzw. der Tag `base` noch von einem früheren Lauf existiert. Anschließend wendet es den neuesten vorhandenen Patch an, der nicht neuer als die Zielversion ist.

`createPatch.sh` schreibt `patches/<version>.patch` (z. B. `patches/v1.15.1.patch`), wechselt zurück auf `main` und räumt den Patch-Modus auf. Danach trägst du die Version selbst in [`patches/README.md`](../patches/README.md) und in `KNOWN_PATCHES` in `install.sh` ein.
