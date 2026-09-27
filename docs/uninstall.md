# Deinstallation

Du möchtest zurück zur englischen Oberfläche? Das geht mit einem Befehl:

```shell
curl -sSL https://install.germandactyl.de/ | sudo bash -s -- -u
```

Liegt dein Panel nicht unter `/var/www/pterodactyl`, gib den Pfad mit `-d <pfad>` an.

## Manuell zurücksetzen

Die Oberfläche im offiziellen Release ist bereits fertig gebaut. Es reicht daher, das Release-Tarball **derselben
Version** erneut zu entpacken (im Beispiel 1.15.1):

```shell
cd /var/www/pterodactyl
php artisan down
curl -L https://github.com/pterodactyl/panel/releases/download/v1.15.1/panel.tar.gz | tar -xz
php artisan view:clear && php artisan config:clear
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan up
```

Stelle anschließend die Sprache in der `.env` (`APP_LOCALE=en`) und unter **Admin → Benutzer** wieder auf Englisch.
