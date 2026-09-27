# Fehlerbehebung

Hier findest du alle Lösungen, die wir kennen. Tritt bei dir ein unbekannter Fehler auf, eröffne ein
[Issue](https://github.com/pavl21/GermanDactyl/issues) und hänge einen Auszug aus `germandactyl.debug.log`
(im Panel-Ordner) an, damit wir dir helfen können.

??? error "In diesem Ordner wurde keine Pterodactyl-Instanz gefunden. Bitte verwende einen anderen Pfad."
    Dieser Fehler tritt meistens auf, wenn Pterodactyl nicht unter `/var/www/pterodactyl` installiert wurde. Ist das
    der Fall, hänge `-d /dein/panel/pfad` an den Befehl an. Mehr dazu [in der Installationsanleitung](installation.md).

    Stimmt der Pfad und der Fehler erscheint trotzdem, prüfe die Zugriffsrechte: Die Datei `config/app.php` im
    Panel-Ordner muss lesbar sein.

??? error "Du hast mit diesem Account nicht genügend Rechte, um die Installation zu starten."
    Hast du das `sudo` vergessen? Der Installer muss als `root` laufen. Prüfe, ob du als `root` angemeldet bist oder
    ob im Befehl `sudo bash` steht.

??? error "Leider gibt es aktuell noch keinen Patch für diese Version."
    Für deine Panel-Version gibt es keinen eigenen Patch. Schau in die
    [Tabelle der unterstützten Versionen](installation.md#unterstutzte-versionen). Bei 1.13.x, 1.14.x oder 1.15.0
    [aktualisierst du das Panel](guides/update.md) am besten auf 1.15.1.

    Meldet dein Panel die Version `canary`, wurde es per Git installiert. Gib die Version dann mit `-v <version>` an.

??? error "_xy_ konnte nicht gepatcht werden. Hat ein Add-on diese Datei überschrieben?"
    Dafür gibt es meist zwei Gründe:

    1. Die Datei wurde bereits von GermanDactyl gepatcht.
    2. Ein Add-on oder Theme hat Pterodactyl so verändert, dass der Patch die passende Stelle nicht findet.

    Bei zwei oder drei Dateien ist das nicht schlimm – du kannst sie manuell anpassen oder ignorieren. Bekommst du
    viele dieser Fehler, prüfe, ob ein Add-on oder Theme den Patch blockiert und ob die Patch-Version zu deinem Panel
    passt.

??? error "Der Build ist fehlgeschlagen"
    Der Installer stellt in diesem Fall automatisch das Backup wieder her – dein Panel bleibt also auf dem alten
    Stand. Häufige Ursachen:

    - **Zu wenig Arbeitsspeicher:** Der Build braucht mindestens 2 GB RAM. Lege bei Bedarf eine Swap-Datei an.
    - **Falsche Node-Version:** Prüfe mit `node -v`, ob Node.js 22 oder neuer installiert ist.

    Die genaue Fehlermeldung findest du in `germandactyl.debug.log` im Panel-Ordner. Die Backups liegen unter
    `/var/backups/germandactyl/`.

??? error "Das Panel ist nach dem Update oder der Installation nur noch weiß"
    Meist liegt das an einem Theme oder Add-on, das du vorher genutzt hast und das eigene Dateien mitbringt.

    Am saubersten ist es, das offizielle Release-Tarball deiner Panel-Version neu zu entpacken, wie in der
    [Deinstallation](uninstall.md#manuell-zurucksetzen) beschrieben. Sichere vorher eigene Änderungen. Führe
    danach GermanDactyl erneut aus.
