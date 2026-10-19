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
[offiziellen Dokumentation](https://docs.pterodactyl.io/docs/panel/updating) – dort stehen auch die Voraussetzungen
(z. B. PHP 8.2/8.3 und Composer 2). Hier die Kurzfassung, im Beispiel liegt das Panel unter `/var/www/pterodactyl`
und wird auf Version 1.15.1 aktualisiert:

```shell
cd /var/www/pterodactyl
php artisan down

curl -L https://github.com/pterodactyl/panel/releases/download/v1.15.1/panel.tar.gz | tar -xz
chmod -R 755 storage/* bootstrap/cache

composer install --no-dev --optimize-autoloader
php artisan view:clear && php artisan config:clear
php artisan migrate --seed --force
```

!!! warning "Version festlegen statt „latest“"
    Lade bewusst eine Version, für die es einen GermanDactyl-Patch gibt (im Beispiel 1.15.1), und nicht
    `releases/latest`. Das neueste Release hat womöglich noch keinen Patch.

Lass das Panel im Wartungsmodus. Die Schritte des offiziellen Updates, die danach kommen (`chown`,
`php artisan queue:restart`, `php artisan up`), erledigt der Installer im nächsten Schritt für dich.

## 2. GermanDactyl erneut ausführen

```shell
curl -fsSL https://install.germandactyl.de/ | sudo bash -s --
```

Der Installer wendet den Patch an, baut die Oberfläche, setzt die Rechte, startet die Queue-Worker neu und beendet
den Wartungsmodus. Liegt dein Panel woanders, hänge `-d <pfad>` an – alle Optionen findest du in der
[Installationsanleitung](../installation.md).

!!! info "Reste der alten Übersetzung"
    Das Entpacken des neuen Panels lässt Dateien der alten Übersetzung (z. B. `resources/lang/de`) liegen. Der
    Installer erkennt diese Reste und ersetzt sie selbst – du musst nichts löschen.

!!! tip "Ohne Rückfragen"
    Mit `-y` startet der Installer ohne Wartezeit und beantwortet Rückfragen automatisch mit Ja – auch die, ob ein
    nicht ganz passender Patch nur teilweise angewendet werden soll. Nutze es nur, wenn du das willst.

Wendest du den Patch stattdessen [manuell](../installation.md#patches-manuell-anwenden) an, stelle zusätzlich unter
**Admin → Einstellungen** die Standardsprache auf Deutsch (die Einstellung in der Datenbank überschreibt
`APP_LOCALE`).

## 3. Abschließen

Prüfe, ob das Panel wieder erreichbar ist. Hat der Installer **vor** dem Wartungsmodus abgebrochen, ist das Panel
noch im Wartungsmodus aus Schritt 1. Dann beendest du ihn selbst:

```shell
php artisan up
```

Installiere danach bei Bedarf deine Add-ons erneut und folge dabei der jeweiligen Anleitung.

Treten Probleme auf, schau in die [Fehlerbehebung](../troubleshooting.md).
