# Übersetzungen einreichen

Vielen Dank, dass du GermanDactyl verbessern möchtest! So läuft ein Beitrag ab:

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
    ./scripts/createPatch.sh 1.15.1
    ```
    Der Patch landet unter `patches/v<version>.patch`.
5. **Pull Request** mit dem aktualisierten Patch eröffnen und kurz beschreiben, was du geändert hast.

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
