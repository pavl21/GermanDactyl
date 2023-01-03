#!/bin/bash
# Downloads the newest version of pterodactyl & switches to patch mode

# Go to the root of the project
cd ..

# Download the newest release from pterodactyl
wget -q -O - https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xvz resources

# Switch to patch mode
git reset --hard HEAD
git checkout -b patches
git add .
git commit -m "base"
git tag base
