#!/bin/bash
# Downloads the newest version of pterodactyl & switches to patch mode

# Download the newest release from pterodactyl
wget -q -O - https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xvz resources

# Switch to patch mode
git reset --hard HEAD
git checkout -b patches

# Apply previous patch
patch_files=$(ls -1 patches/*.patch 2>/dev/null | wc -l)
if [ "$patch_files" != 0 ]; then
    patch=$(ls -t patches/*.patch | head -1)
    git apply --ignore-whitespace --ignore-space-change -C1 --inaccurate-eof --apply --allow-empty --reject "$patch"
    find . -name \*.rej -print0 | xargs rm
    find . -name \*.orig -print0 | xargs rm
fi

git add .
git commit -m "base"
git tag base
