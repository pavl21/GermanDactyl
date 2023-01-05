Pterodactyl hat ein neues Update bekommen? Folge diesem Guide und die Installation wird kein Problem.

!!! danger "Gibt es schon ein GermanDactyl-Update?"
    Nur weil ein Pterodactyl-Update vorliegt, heißt das nicht, dass automatisch auch GermanDactyl schon aktualisiert 
    wurde. Vergewissere dich vorher [hier](https://github.com/pavl21/GermanDactyl/tree/main/patches), ob GermanDactyl
    schon für die neue Pterodactyl-Version verfügbar ist. Falls nicht, habe noch etwas Geduld.

## Installation des Panels

Zuerst muss das Panel auf die neuste Version gebracht werden. Eine detaillierte Zusammenfassung findest 
du [hier](https://pterodactyl.io/panel/updating.html). Hier nochmal eine kurze Zusammenfassung:

1. Schalte den Wartungsmodus ein
   ```shell
   cd /var/www/pterodactyl #(1)
   php artisan down
   ```
    1. Hier wurde als Beispiel `/var/www/pterodactyl` verwendet. Solltest du pterodactyl unter einem anderen Pfad
       installiert haben, ändere dies ab.

2. Lade das Update herunter
   ```shell
   curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
   ```
   ```shell
   chmod -R 755 storage/* bootstrap/cache
   ```

3. Installiere alle Dependency- und Datenbankupdates
   ```shell
   composer install --no-dev --optimize-autoloader
   ```
   ```shell
   php artisan migrate --seed --force
   ```

4. Löschen des Zwischenspeichers für kompilierte Vorlagen
   ```shell
   php artisan view:clear
   ```
   ```shell
   php artisan config:clear
   ```

5. Setze die Berechtigungen
   ```shell
   chown -R www-data:www-data /var/www/pterodactyl/* #NGINX oder Apache (nicht auf CentOS) 
   chown -R nginx:nginx /var/www/pterodactyl/* #NGINX auf CentOS
   chown -R apache:apache /var/www/pterodactyl/* #Apache auf CentOS
   ```

6. Neustart von Queue Workern
   ```shell
   php artisan queue:restart
   ```

7. Wartungsmodus beenden
   ```shell
   php artisan up 
   ```

## Installation von GermanDactyl

Jetzt wo Pterodactyl installiert ist können wir erneut die Patches anwenden, sodass das Panel wieder auf Deutsch
eingestellt wird.

??? warning "Hast du Probleme mit diesem Befehl?"
    Für den Fall, dass du Pterodactyl unter einem anderen Pfad installiert hast als `/var/www/pterodactyl` oder das
    Skript einfach nicht bei dir funktioniert, lohnt es sich, die 
    [Installationsanleitung](/installation/) mal anzusehen.

```shell
curl -sSL https://install.germandactyl.de/ | sudo bash -s --
```

## Installation deiner Add-ons

Jetzt kommt der Moment wo du alle Add-ons installieren kannst. Folge dafür der Anleitung des jeweiligen Add-ons.

## Fertig

Sowohl Pterodactyl als auch GermanDactyl wurden nun aktualisiert und können erneut verwendet werden. Sollten nun
weitere Probleme auftreten, schau dir den [Guide zur Fehlerbehebung](/troubleshooting/) an.
