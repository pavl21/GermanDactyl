# Skripte

In diesem Ordner liegen die Skripte für die Installation von GermanDactyl und für das Erstellen neuer Patches.

| Skript | Zweck |
| --- | --- |
| [install.sh](install.sh) | Installiert GermanDactyl in einem bestehenden Panel oder entfernt es wieder (`-u`) |
| [startPatching.sh](startPatching.sh) | Wechselt in den Patch-Modus, um eine neue Panel-Version zu übersetzen |
| [createPatch.sh](createPatch.sh) | Erstellt aus den Änderungen den neuen Patch und verlässt den Patch-Modus |

## install.sh

```bash
curl -fsSL https://install.germandactyl.de | sudo bash -s -- [Optionen]
```

| Option | Bedeutung |
| --- | --- |
| `-d <pfad>` | Pfad zum Panel (Standard: `/var/www/pterodactyl`) |
| `-v <version>` | Patch für diese Version verwenden, z. B. `-v 1.15.1`. Nötig bei Git-Installationen, die als `canary` erscheinen |
| `-u` | GermanDactyl entfernen und zurück zu Englisch wechseln |
| `-y` | Ohne Wartezeit starten und Rückfragen mit Ja beantworten |
| `-h` | Hilfe anzeigen |

Voraussetzungen: root-Rechte, PHP 8.2/8.3, etwa 2 GB RAM (inkl. Swap) für den Build. Node.js (Mindestversion laut `package.json` des Panels, ab 1.12 Node.js ≥ 22), Yarn und Git installiert das Skript unter Debian/Ubuntu bei Bedarf selbst. Auf anderen Systemen musst du sie vorher selbst installieren.

Das Skript

- lädt den passenden Patch und prüft seine Signatur: Die SHA-256-Prüfsumme muss in der signierten Liste `patches/SHA256SUMS` stehen (geprüft mit `gpgv` gegen den im Skript hinterlegten Schlüssel). Stimmt etwas nicht, bricht das Skript ohne Änderungen ab.
- prüft, ob der Patch schon angewendet ist (`git apply --reverse --check`). Ist er installiert, bricht es ohne Änderungen ab – noch vor der Wartezeit und vor dem Installieren von Abhängigkeiten.
- prüft den Patch mit `git apply --check`.
- sichert `app`, `resources`, `public`, `database`, `routes` und `config` nach `/var/backups/germandactyl/` (`panel-<version>-install-<zeit>.tar.gz`, bei der Deinstallation `-uninstall-`).
- versetzt das Panel während der Arbeiten in den Wartungsmodus.
- wendet den Patch an und baut das Panel neu (`yarn install --frozen-lockfile`, `yarn run build:production`; Panels mit `package-lock.json` und ohne `yarn.lock` baut es mit `npm ci` und `npm run build:production`).
- speichert nach erfolgreichem Build eine Kopie des Patches für die Deinstallation.
- setzt die Sprache auf Deutsch: `APP_LOCALE=de` in der `.env`, `settings::app:locale` in der Datenbank, und alle Benutzer mit Englisch werden auf Deutsch umgestellt.
- leert die Caches, setzt die Dateirechte und startet die Queue-Worker neu.

Schlägt der Build fehl, spielt das Skript das Backup automatisch zurück. Alle Ausgaben landen in `/var/log/germandactyl.log`.

## Neuen Patch erstellen

```bash
./scripts/startPatching.sh [version]   # z. B. v1.15.1, Standard: neuestes Release
# Übersetzungen in resources/, app/ usw. anpassen, .rej-Dateien einarbeiten und löschen
./scripts/createPatch.sh [--no-sign] [version]   # Standard: Version aus startPatching.sh
```

Die Skripte laufen unter Linux und brauchen bash ≥ 4.4, GNU coreutils/find, git und gpg (gpg nur zum Signieren).

`startPatching.sh` bricht ab, wenn du nicht auf `main` bist, dein Arbeitsverzeichnis nicht sauber ist oder der Branch `patches` bzw. der Tag `base` noch von einem früheren Lauf existiert. Anschließend wendet es den neuesten vorhandenen Patch an, der nicht neuer als die Zielversion ist.

`createPatch.sh` schreibt `patches/v<version>.patch` (z. B. `patches/v1.15.1.patch`) als reinen `git diff` mit festen Optionen (derselbe Stand ergibt immer denselben Patch), wechselt zurück auf `main` und räumt den Patch-Modus auf. Am Ende zeigt es eine Checkliste: Die Version gehört in die Versionstabellen (`README.md`, `docs/installation.md`, `patches/README.md`), in die Zeile „Aktuelle Panel-Version“ (`README.md`, `docs/index.md`), in `KNOWN_PATCHES` in `install.sh`, und der Patch-Server `patch.germandactyl.de` muss die Version ausliefern.

## Patches signieren

`createPatch.sh` erzeugt nach jedem neuen Patch `patches/SHA256SUMS` und signiert die Liste mit GPG (`patches/SHA256SUMS.asc`). Beides entsteht zuerst in einem Temp-Ordner und landet erst nach erfolgreicher Signatur in `patches/`; die Signatur muss vom Projektschlüssel aus `install.sh` stammen. Nur signieren (z. B. nach einer Korrektur an einem Patch):

```bash
GERMANDACTYL_SIGNING_KEY=<Fingerabdruck> ./scripts/createPatch.sh --sign
```

Wer keinen Schlüssel hat (z. B. bei einem Beitrag), nutzt `--no-sign`: Dann wird nur `SHA256SUMS` erneuert, die alte Signatur passt nicht mehr dazu, und der Maintainer signiert später mit `--sign`.

Der Workflow „Patches prüfen“ verhindert, dass unsignierte oder veränderte Patches nach `main` gelangen – der Installer würde sie sonst ablehnen.
