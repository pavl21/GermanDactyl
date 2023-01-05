#!/bin/bash
# Looks up the newest panel version, creates the patch & leaves patch mode

# Define the patch version
version=$(git ls-remote --refs --sort="version:refname" --tags https://github.com/pterodactyl/panel/ | cut -d/ -f3- | tail -n1)

# Build a patch
git add resources app routes database
git commit -m "Translations $version"
git format-patch base..HEAD --stdout > "patches/$version.patch"
git checkout main
git tag -d base
git branch -D patches
