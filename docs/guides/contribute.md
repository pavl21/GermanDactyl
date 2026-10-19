# Übersetzungen einreichen

Vielen Dank, dass du GermanDactyl verbessern möchtest! So läuft ein Beitrag ab:

!!! info "Voraussetzungen"
    Die Skripte brauchen Linux mit bash ≥ 4.4, GNU coreutils/find, git und gpg (gpg nur zum Signieren durch den
    Maintainer). Unter macOS oder BSD laufen sie nicht zuverlässig.

1. **Forke** das [Repository](https://github.com/pavl21/GermanDactyl) und klone deinen Fork.
2. **Arbeitsstand vorbereiten:** Das Skript lädt die passende Panel-Version und wendet den vorhandenen Patch an.
    ```shell
    ./scripts/startPatching.sh 1.15.1
    ```
    Ohne Versionsangabe wird die neueste Panel-Version verwendet.
3. **Übersetzen:** Die deutschen Sprachdateien liegen in `resources/lang/de`, fest eingebaute Texte findest du in
   den Vorlagen unter `resources/`. Halte dich an die Richtlinien unten.
4. **Patch erstellen:**
    ```shell
    ./scripts/createPatch.sh --no-sign 1.15.1
    ```
    Der Patch landet unter `patches/v<version>.patch`. `--no-sign` brauchst du, weil nur der Maintainer den
    Signaturschlüssel hat.
5. **Pull Request** mit dem aktualisierten Patch eröffnen und kurz beschreiben, was du geändert hast.

!!! info "Signatur"
    Neue oder geänderte Patches müssen signiert werden, sonst lehnt der Installer sie ab. Das übernimmt der
    Maintainer beim Merge mit `./scripts/createPatch.sh --sign` (als Maintainer lässt du `--no-sign` weg und
    setzt `GERMANDACTYL_SIGNING_KEY`). In deinem Pull Request darf der Workflow
    „Patches prüfen“ deshalb fehlschlagen.

## Richtlinien

- Wir sprechen die Nutzer mit **Du** an.
- Kurze, klare Texte – lieber natürlich als wortwörtlich übersetzt.
- Achte auf korrekte Rechtschreibung und einheitliche Begriffe.

### Glossar

| Englisch | Deutsch |
| --- | --- |
| Node | die Node |
| Allocation | Port-Zuweisung |
| Backup | Backup |
| Egg / Nest | Egg / Nest (unübersetzt) |
| Subuser | Unterbenutzer |
| Account | Konto |

Fragen? Komm gerne [in unseren Discord](https://discord.gg/6R38NnTCct).
