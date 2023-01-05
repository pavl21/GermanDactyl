#!/bin/bash
# Downloads the newest version of pterodactyl & switches to patch mode

# Download the newest release from pterodactyl
wget -q -O - https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xvz resources app routes database

# Switch to patch mode
git reset --hard HEAD
git checkout -b patches
git add .
git commit -m "base"
git tag base

# Apply previous patch
patch_files=$(ls -1 patches/*.patch 2>/dev/null | wc -l)
if [ "$patch_files" != 0 ]; then
    patch=$(ls -t patches/*.patch | head -1)
    git apply --ignore-whitespace --ignore-space-change -C1 --apply --allow-empty --reject "$patch"

    rejected_files=$(find . \( -name "*.rej" -o -name "*.orig" \) | wc -l)
    if [ "$rejected_files" == 0 ]; then
        echo -e "\033[1;32m✓ Beim Patch-Vorgang traten keine Fehler auf.\033[0;39m"
    else
        echo -e "\033[1;31m✗ Folgende Dateien konnten nicht gepatcht werden und brauchen manuelle Übersetzungen:\033[0;39m"
    fi

    find . \( -name "*.rej" -o -name "*.orig" \) | while read -r file; do
        file_pretty=$(echo "$file" | cut -c 3-)
        echo -e "\033[1;31m✗ ${file_pretty%.*}\033[0;39m"
        rm "$file"
    done

fi

echo ""
echo "Patch-Modus betreten. Verändere jetzt keine Dateien mehr am Projekt, verändere nur noch Übersetzungen."
echo "Ab jetzt werden alle Veränderungen zum Patch hinzugefügt. Gib ./scripts/createPatch.sh ein, sobald du fertig bist"
