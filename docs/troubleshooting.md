Hier erscheinen bald häufig eingereichte Fehler und die dazu passende Lösung. Bitte gedulde dich noch ein wenig!

??? error "In diesem Ordner wurde keine pterodactyl-Instanz gefunden. Bitte verwende einen anderen Pfad."
    Dieser Fehler tritt meistens auf, wenn pterodactyl unter einem anderen Ordner als `/var/www/pterodactyl` installiert
    wurde. Ist das der Fall, füge ein `-d /dein/installations/ort` hinter den Befehl hinzu. Weiteres dazu 
    [in der Installationsanleitung](/installation/).   
    Ist der Ordner richtig angegeben und der Fehler erscheint trotzdem, vergewissere dich, dass die Zugriffsrechte
    korrekt eingestellt sind und der Nutzer die Datei `/config/app.php` lesen kann.

??? error "Bitte führe diesen Befehl als Superuser aus."
    Hast du das `sudo` vergessen? Dieser Fehler tritt nur auf, wenn der Befehl nicht als Superuser (`root`) ausgeführt
    wird. Überprüfe also, ob du auch wirklich als `root` angemeldet bist oder ob im One-Click-Installer das `sudo`
    angegeben wurde.

??? error "_xy_ konnte nicht gepatcht werden. Hat ein Addon diese Datei überschrieben?"
    Dieser Fehler könnte aufgrund folgenden Problemen auftreten:   
    1. Die angegebene Datei wurde bereits von GermanDactyl gepatcht und kann daher nicht überschrieben werden.   
    2. Du hast ein Addon / Theme installiert, welches Pterodactyl so anpasst, dass der Patch nicht weiß, wohin er sich
       anwenden kann.   
    Das ist nicht immer schlimm. Passiert das bei 2 - 3 Dateien lassen sich diese immer noch manuell bearbeiten oder
    gar ignorieren. Solltest du allerdings den Patch noch nicht angewendet haben und trotzdem viele dieser Fehler
    erhalten, überprüfe, ob ein Addon oder Theme den Patch blockiert oder du die richtige Version von GermanDactyl
    ausgewählt hast.
    
??? error "Das Panel ist nach dem Upgrade nur noch weiß"
    Das Problem hängt meist mit dem Theme zusammen, was du davor genutzt hast. Einige Themes oder Addons erstellen neue Dateien,
    die normalerweise nicht in Pterodactyl dabei ist. Die beste Lösung wäre, das du im Verzeichnis /var/www/pterodactyl 
    den Ordner ressources komplett löschst, sichere dir aber am besten vorher die Version als Backup, solltest du noch eigene
    Änderungen gemacht haben. Führe dann das Upgrade erneut durch.
