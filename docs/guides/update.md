# Update ausführen

Pterodactyl hat ein neues Update bekommen? Mit dieser Anleitung ist das kein Problem.

!!! danger "Gibt es schon einen passenden GermanDactyl-Patch?"
    Nur weil ein Pterodactyl-Update erschienen ist, gibt es nicht automatisch auch schon einen GermanDactyl-Patch
    dafür. Prüfe vorher in der [Tabelle der unterstützten Versionen](../installation.md#unterstutzte-versionen), ob
    die neue Version bereits unterstützt wird. Falls nicht, hab noch etwas Geduld.

!!! warning "Das Update überschreibt die Übersetzung"
    Nach jedem Panel-Update ist das Panel wieder auf Englisch. Führe GermanDactyl danach einfach erneut aus.

## 1. Panel aktualisieren

Aktualisiere zuerst das Panel. Die ausführliche Anleitung findest du in der
[offiziellen Dokumentation](https://pterodactyl.io/panel/1.0/updating.html) – dort stehen auch die Voraussetzungen
(z. B. PHP 8.2/8.3 und Composer 2). Hier die Kurzfassung, im Beispiel liegt das Panel unter `/var/www/pterodactyl`:

```shell
cd /var/www/pterodactyl
php artisan down

curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xz
chmod -R 755 storage/* bootstrap/cache

composer install --no-dev --optimize-autoloader
php artisan view:clear && php artisan config:clear
php artisan migrate --seed --force
```

Beende den Wartungsmodus noch **nicht** – erst nach GermanDactyl (Schritt 3).

## 2. GermanDactyl erneut ausführen

```shell
curl -sSL https://install.germandactyl.de/ | sudo bash -s -- -y
```

Der Installer wendet den Patch an, baut die Oberfläche und setzt die Rechte. Liegt dein
Panel woanders, hänge `-d <pfad>` an – alle Optionen findest du in der [Installationsanleitung](../installation.md).

## 3. Abschließen

Starte die Queue-Worker neu und prüfe, ob das Panel wieder erreichbar ist:

```shell
php artisan queue:restart
php artisan up
```

Installiere danach bei Bedarf deine Add-ons erneut und folge dabei der jeweiligen Anleitung.

Treten Probleme auf, schau in die [Fehlerbehebung](../troubleshooting.md).
