#!/usr/bin/env bash
#
# Erstellt aus den Änderungen im Patch-Modus die Datei patches/<version>.patch
# und verlässt den Patch-Modus (zurück auf main, Branch "patches" und Tag
# "base" werden gelöscht).
#
# Verwendung: ./scripts/createPatch.sh [version]
#   version  Panel-Version, z. B. v1.15.1 oder 1.15.1
#            (Standard: die Version, mit der startPatching.sh gestartet wurde;
#            sonst das neueste Release laut GitHub)

set -euo pipefail

readonly PANEL_REPO=pterodactyl/panel
readonly PANEL_DIRS=(resources app routes database public)

RED=$'\033[1;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
NORMAL=$'\033[0m'

success() { printf '%s✓ %s%s\n' "$GREEN" "$1" "$NORMAL"; }
warn()    { printf '%s⚠ %s%s\n' "$YELLOW" "$1" "$NORMAL" >&2; }
fail()    { printf '%s✗ %s%s\n' "$RED" "$1" "$NORMAL" >&2; exit 1; }

# Neuestes stabiles Release (ohne Pre-Releases wie v1.11.0-rc.2).
latest_version() {
    local tag
    tag=$(curl -fsSL "https://api.github.com/repos/$PANEL_REPO/releases/latest" 2>/dev/null \
        | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n 1) || true
    if [ -z "$tag" ]; then
        tag=$(git ls-remote --refs --tags "https://github.com/$PANEL_REPO.git" \
            | sed 's#.*refs/tags/##' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1) || true
    fi
    [ -n "$tag" ] || fail "Die neueste Panel-Version konnte nicht ermittelt werden. Gib sie als Parameter an, z. B. v1.15.1."
    printf '%s\n' "$tag"
}

cd "$(git rev-parse --show-toplevel)"

# --- Sicherheitsprüfungen ---------------------------------------------------

[ "$(git rev-parse --abbrev-ref HEAD)" = patches ] \
    || fail "Du bist nicht im Patch-Modus (Branch \"patches\"). Starte ihn mit ./scripts/startPatching.sh."
git show-ref --verify --quiet refs/tags/base \
    || fail "Der Tag \"base\" fehlt. Starte den Patch-Modus neu mit ./scripts/startPatching.sh."

mapfile -t rejects < <(find "${PANEL_DIRS[@]}" \( -name '*.rej' -o -name '*.orig' \) 2>/dev/null | sort)
if [ "${#rejects[@]}" -gt 0 ]; then
    printf '  %s\n' "${rejects[@]}" >&2
    fail "Es liegen noch .rej/.orig-Dateien herum (siehe oben). Arbeite sie ein und lösche sie, bevor du den Patch erstellst."
fi

# --- Version bestimmen --------------------------------------------------------

if [ $# -gt 0 ]; then
    version=$1
else
    # startPatching.sh legt den Commit "base <version>" an.
    version=$(git log -1 --format=%s base | sed -n 's/^base \(v.*\)$/\1/p')
    [ -n "$version" ] || version=$(latest_version)
fi
[[ $version == v* ]] || version="v$version"
patch_file="patches/$version.patch"

# --- Patch erstellen ----------------------------------------------------------

git add -- "${PANEL_DIRS[@]}"
if git diff --cached --quiet base -- "${PANEL_DIRS[@]}"; then
    fail "Es gibt keine Änderungen gegenüber dem Original. Es wurde kein Patch erstellt."
fi

# Alle Änderungen zu genau einem Commit zusammenfassen, damit der Patch aus
# einem einzigen Teil besteht.
git reset -q --soft base
git commit -q -m "Translations $version"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
git format-patch base..HEAD --stdout -- "${PANEL_DIRS[@]}" >"$tmp"
files=$(git diff --name-only base HEAD -- "${PANEL_DIRS[@]}" | wc -l)

# --- Patch-Modus verlassen ----------------------------------------------------

git checkout -q main
# Reste entfernen, die nicht in main gehören (z. B. von Git ignorierte Dateien).
for dir in "${PANEL_DIRS[@]}"; do
    rm -rf -- "$dir"
done

[ ! -e "$patch_file" ] || warn "$patch_file existiert bereits und wird überschrieben."
mv "$tmp" "$patch_file"
chmod 644 "$patch_file"
git tag -d base >/dev/null
git branch -q -D patches

success "Patch $patch_file erstellt ($files Dateien). Du bist wieder auf main."
echo ""
echo "Nächste Schritte:"
echo "  1. Trage $version in die Tabelle in patches/README.md ein."
echo "  2. Ergänze die Version in KNOWN_PATCHES in scripts/install.sh."
echo "  3. Committe alles: git add $patch_file patches/README.md scripts/install.sh && git commit"
