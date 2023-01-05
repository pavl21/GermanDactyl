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
    git apply --ignore-whitespace --ignore-space-change -C1 --inaccurate-eof --apply --allow-empty --reject "$patch"
    echo -e "\033[1;31m✗ Folgende Dateien konnten nicht gepatcht werden und brauchen manuelle Übersetzungen:\033[0;39m"
    found_files=no
    find . \( -name "*.rej" -o -name "*.orig" \) | while read -r file; do
        found_files=yes
        file_pretty=$(echo "$file" | cut -c 3-)
        echo -e "\033[1;31m✗ ${file_pretty%.*}\033[0;39m"
        rm "$file"
    done

    if [ "$found_files" == "no" ]; then
        echo -e "\033[1;31m✗ Alle Patches wurden sauber angewendet. Keine manuellen Eingriffe erforderlich."
    fi

fi
