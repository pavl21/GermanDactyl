#!/usr/bin/env bash
#
# Startet den Patch-Modus: lädt ein Pterodactyl-Release, legt es als Commit
# "base" auf dem Branch "patches" ab und wendet den letzten vorhandenen Patch an.
#
# Verwendung: ./scripts/startPatching.sh [version]
#   version  Panel-Version, z. B. v1.15.1 oder 1.15.1
#            (Standard: neuestes Release laut GitHub)
#
# Danach die Übersetzungen anpassen und ./scripts/createPatch.sh ausführen.

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

# Höchster vorhandener Patch, der nicht neuer als die Zielversion ist.
previous_patch() {
    local target=${1#v} patch ver best=""
    while IFS= read -r patch; do
        ver=$(basename "$patch" .patch)
        ver=${ver#v}
        if [ "$(printf '%s\n%s\n' "$ver" "$target" | sort -V | head -n 1)" = "$ver" ]; then
            best=$patch
        fi
    done < <(find patches -maxdepth 1 -name 'v*.patch' | sort -V)
    printf '%s\n' "$best"
}

cd "$(git rev-parse --show-toplevel)"

# --- Sicherheitsprüfungen ---------------------------------------------------

[ "$(git rev-parse --abbrev-ref HEAD)" = main ] \
    || fail "Bitte wechsle zuerst auf den Branch main (git checkout main)."
[ -z "$(git status --porcelain)" ] \
    || fail "Dein Arbeitsverzeichnis ist nicht sauber. Committe oder verwirf deine Änderungen zuerst (git status)."
! git show-ref --verify --quiet refs/heads/patches \
    || fail "Der Branch \"patches\" existiert bereits. Läuft noch ein Patch-Vorgang? Sonst lösche ihn mit: git branch -D patches"
! git show-ref --verify --quiet refs/tags/base \
    || fail "Der Tag \"base\" existiert bereits. Läuft noch ein Patch-Vorgang? Sonst lösche ihn mit: git tag -d base"
for dir in "${PANEL_DIRS[@]}"; do
    [ ! -e "$dir" ] || fail "Der Ordner \"$dir\" existiert bereits. Bitte entferne ihn zuerst."
done

# --- Panel herunterladen ------------------------------------------------------

version=${1:-$(latest_version)}
[[ $version == v* ]] || version="v$version"
[[ $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || warn "$version sieht nicht wie eine stabile Version aus."

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

echo "Pterodactyl $version wird heruntergeladen …"
curl -fsSL -o "$tmp" "https://github.com/$PANEL_REPO/releases/download/$version/panel.tar.gz" \
    || fail "Das Release $version konnte nicht heruntergeladen werden. Gibt es diese Version?"
tar -xzf "$tmp" "${PANEL_DIRS[@]}" || fail "Das Release-Archiv konnte nicht entpackt werden."

# --- Patch-Modus betreten -----------------------------------------------------

git checkout -q -b patches
git add -- "${PANEL_DIRS[@]}"
git commit -q -m "base $version"
git tag base
success "Patch-Modus für $version vorbereitet (Branch \"patches\", Tag \"base\")."

# --- Vorherigen Patch anwenden -----------------------------------------------

patch=$(previous_patch "$version")
if [ -z "$patch" ]; then
    warn "Es wurde kein vorheriger Patch gefunden. Du startest ohne Übersetzungen."
else
    echo "Vorheriger Patch $patch wird angewendet …"
    git apply --ignore-whitespace --ignore-space-change --reject \
        --include='resources/*' --include='app/*' --include='routes/*' \
        --include='database/*' --include='public/*' "$patch" 2>/dev/null || true

    mapfile -t rejects < <(find "${PANEL_DIRS[@]}" -name '*.rej' | sort)
    if [ "${#rejects[@]}" -eq 0 ]; then
        success "Der Patch wurde ohne Fehler angewendet."
    else
        warn "Folgende Dateien konnten nicht vollständig gepatcht werden und müssen von Hand übersetzt werden:"
        for file in "${rejects[@]}"; do
            printf '%s  ✗ %s%s\n' "$RED" "${file%.rej}" "$NORMAL" >&2
        done
        warn "Die abgelehnten Stellen stehen in den .rej-Dateien. Lösche sie, bevor du createPatch.sh ausführst."
    fi
fi

echo ""
echo "Du bist jetzt im Patch-Modus. Ändere keine Dateien von GermanDactyl selbst, sondern nur noch Übersetzungen."
echo "Alle Änderungen in ${PANEL_DIRS[*]} landen im Patch. Führe ./scripts/createPatch.sh aus, sobald du fertig bist."
