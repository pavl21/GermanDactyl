# Patches

In diesem Ordner findest du alle Patches, sortiert nach Panel-Version. Jeder Patch übersetzt das Server- und das Adminpanel.

| Pterodactyl Panel | GermanDactyl-Patch |
| --- | --- |
| 1.11.2 | [v1.11.2](v1.11.2.patch) |
| 1.11.3 | [v1.11.3](v1.11.3.patch) |
| 1.12.2 | [v1.12.2](v1.12.2.patch) |
| 1.13.x, 1.14.x, 1.15.0 | kein eigener Patch – bitte das Panel auf 1.15.1 aktualisieren |
| 1.15.1 (aktuell) | [v1.15.1](v1.15.1.patch) |

Mit `-v <version>` kannst du im Installer einen anderen Patch erzwingen. Das geschieht auf eigenes Risiko, weil ein Patch für eine andere Panel-Version meist nicht vollständig passt.

Neue Patches erstellst du mit `./scripts/startPatching.sh [version]` und `./scripts/createPatch.sh [version]`. Die Anleitung findest du unter [Übersetzungen einreichen](https://germandactyl.de/guides/contribute/).

## Signatur

`SHA256SUMS` enthält die SHA-256-Prüfsummen aller Patches, `SHA256SUMS.asc` die GPG-Signatur dieser Liste,
`germandactyl-signing-key.asc` den öffentlichen Schlüssel (Fingerabdruck `2CB69766DC1E05E8D805D4C0DF5A303D401576B8`).
`install.sh` prüft beides vor jeder Installation. Nach jeder Änderung an einem Patch neu signieren:
`./scripts/createPatch.sh --sign`.

