#!/bin/bash
# Looks up the newest panel version, creates the patch & leaves patch mode

# Define the patch version
version=$(git ls-remote --refs --sort="version:refname" --tags https://github.com/pterodactyl/panel/ | cut -d/ -f3- | tail -n1)

# Build a patch
git format-patch base..HEAD --stdout >> "patches/v$version.patch"
git tag -d base
git checkout main
git branch -D patches
