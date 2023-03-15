!!! warning "Möglicherweise nicht mit allen Add-ons kompatibel"
    GermanDactyl verwendet Patches, um das Interface zu übersetzen.
    Solltest du vorher schon Plugins oder Themes installiert haben, welche das Interface bearbeiten, ist es möglich,
    dass einige Dateien nicht vom Patch bearbeitet werden können.

## Der einfache Weg

Füge einfach den folgenden Befehl in die Konsole deines Servers ein. GermanDactyl wird sich automatisch installieren.

=== ":material-flash: Normale Installation"
    ```shell
    curl -sSL https://install.germandactyl.de/ | sudo bash -s --
    ```

=== ":material-folder: Ordner auswählen"
    ```shell
    curl -sSL https://install.germandactyl.de/ | sudo bash -s -- -d /dein/pterodactyl/pfad
    ```

=== ":material-update: Version auswählen"
    ```shell
    curl -sSL https://install.germandactyl.de/ | sudo bash -s -- -v 1.11.2
    ```
    !!! warning "Nicht empfohlen"
        Das Anpassen der Version wird nicht empfohlen. Dies sollte nur eingesetzt werden, wenn die von Pterodactyl
        gemeldete Version nicht der Wahrheit entspricht.

## Patches manuell anwenden

Sollte die automatische Installation bei dir nicht funktionieren (z. B. weil deine Linux-Version nicht vom Skript
unterstützt ist), kannst du auf die manuelle Variante zurückgreifen.    
Folge dafür folgenden Schritten:

1. Lade zuerst den Patch passend zu deiner Version herunter   
    ```shell
    curl -sSL https://patch.germandactyl.de/1.11.2 -o /var/www/pterodactyl/germandactyl.patch #(1)
    ```
    1. Hier wird als Beispiel `/var/www/pterodactyl` verwendet. Passe diesen Ordner an deine Instanz an
   
2. Falls noch nicht getan, installiere NodeJS, git und yarn
    ```shell
    # Installiere NodeJS
    curl -sL https://deb.nodesource.com/setup_16.x | bash - 
    apt -y install nodejs
   
    # Installiere Yarn
    npm install -g yarn
   
    # Installiere git
    apt -y install git
    ```

3. Navigiere in deinen pterodactyl-Ordner und wende den Patch an  
    ```shell
    # Navigiere in deinen Ordner (1)
    cd /var/www/pterodactyl
   
    # Wende den Patch an (2)
    git apply --ignore-whitespace --ignore-space-change -C1 --apply --reject germandactyl.patch
    ```
    1. Hier wird als Beispiel `/var/www/pterodactyl` verwendet. Passe diesen Ordner an deine Instanz an
    2. Solltest du mit den Parametern nicht zufrieden sein, passe sie so an, dass sie für dich Sinn ergeben.   
       Eine Hilfe dazu findest du unter `git apply --help`
   
4. Kompiliere das Interface
    ```shell
    # Installiere alle Dependencies (falls noch nicht getan)
    yarn install
    
    # Erstelle einen Produktions-Build für das Interface
    yarn run build:production
   
    # Leere den Views-Cache und optimiere das Projekt
    php artisan view:clear
    php artisan optimize
    ```
   
Das wars. Nun hast du eine deutsche Version für dein Pterodactyl-Panel :)
