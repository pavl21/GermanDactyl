#!/usr/bin/env bash
#
# Erstellt aus den Änderungen im Patch-Modus die Datei patches/<version>.patch
# und verlässt den Patch-Modus (zurück auf main, Branch "patches" und Tag
# "base" werden gelöscht).
#
# Verwendung: ./scripts/createPatch.sh [--no-sign] [version]
#             ./scripts/createPatch.sh --sign
#   version    Panel-Version, z. B. v1.15.1 oder 1.15.1
#              (Standard: die Version, mit der startPatching.sh gestartet wurde;
#              sonst das neueste Release laut GitHub)
#   --sign     Nur patches/SHA256SUMS neu erzeugen und signieren
#   --no-sign  Patch erstellen und patches/SHA256SUMS erneuern, aber nicht
#              signieren (für Beiträge ohne Projektschlüssel; der Maintainer
#              signiert später mit --sign)
#
# Signiert wird mit GPG. Den Schlüssel wählst du über die Umgebungsvariable
# GERMANDACTYL_SIGNING_KEY (Fingerabdruck); sonst nimmt GPG den Standardschlüssel.
# Die Signatur muss vom Projektschlüssel stammen, dessen Fingerabdruck in
# scripts/install.sh steht – sonst lehnt der Installer die Patches ab.

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

# Erzeugt patches/SHA256SUMS für alle Patches und signiert die Liste
# (patches/SHA256SUMS.asc). install.sh wendet nur Patches an, deren Prüfsumme
# in dieser signierten Liste steht.
# Beides entsteht zuerst in einem Temp-Ordner und wird erst nach erfolgreicher
# Signatur nach patches/ verschoben – scheitert etwas, bleibt patches/ unverändert.
# Mit sign=0 (--no-sign) wird nur SHA256SUMS erneuert; die alte Signatur passt
# dann nicht mehr dazu.
sign_patches() {
    local sign=$1 patches=() key_opts=() expected_fpr status
    local sums="$workdir/SHA256SUMS" sig="$workdir/SHA256SUMS.asc"

    mapfile -t patches < <(find patches -maxdepth 1 -name 'v*.patch' -printf '%f\n' | sort -V)
    [ "${#patches[@]}" -gt 0 ] || fail "Im Ordner patches/ liegen keine Patches."

    (cd patches && sha256sum -- "${patches[@]}") >"$sums"

    if [ "$sign" = 0 ]; then
        mv "$sums" patches/SHA256SUMS
        warn "Die Liste patches/SHA256SUMS wurde ohne Signatur erneuert. patches/SHA256SUMS.asc passt jetzt nicht mehr dazu,
  und install.sh lehnt die Patches ab, bis der Maintainer sie signiert hat: ./scripts/createPatch.sh --sign"
        return
    fi

    command -v gpg >/dev/null 2>&1 || fail "gpg wurde nicht gefunden. Installiere GnuPG oder verwende --no-sign.
  Die Prüfsummenliste patches/SHA256SUMS wurde nicht verändert."

    if [ -n "${GERMANDACTYL_SIGNING_KEY:-}" ]; then
        key_opts=(--local-user "$GERMANDACTYL_SIGNING_KEY")
    else
        warn "GERMANDACTYL_SIGNING_KEY ist nicht gesetzt. GPG verwendet den Standardschlüssel."
    fi
    if ! gpg --batch --yes --armor --detach-sign "${key_opts[@]}" --output "$sig" "$sums"; then
        fail "Das Signieren ist fehlgeschlagen. Ohne gültige Signatur lehnt install.sh die Patches ab!
  Die Prüfsummenliste patches/SHA256SUMS wurde nicht verändert.
  Signiere mit dem Projektschlüssel: GERMANDACTYL_SIGNING_KEY=<Fingerabdruck> ./scripts/createPatch.sh --sign
  Hast du keinen Schlüssel, erstelle Patches mit --no-sign."
    fi

    status=$(gpg --batch --status-fd 1 --verify "$sig" "$sums" 2>/dev/null) \
        || fail "Die gerade erstellte Signatur lässt sich nicht prüfen."
    expected_fpr=$(sed -n 's/^readonly SIGNING_KEY_FPR="\([0-9A-F]*\)".*/\1/p' scripts/install.sh)
    if [ -n "$expected_fpr" ] && ! grep -Eq "^\[GNUPG:\] VALIDSIG .*\b$expected_fpr\b" <<<"$status"; then
        fail "Die Signatur stammt nicht vom Projektschlüssel $expected_fpr (siehe scripts/install.sh).
  Die Prüfsummenliste patches/SHA256SUMS wurde nicht verändert."
    fi

    mv "$sig" patches/SHA256SUMS.asc
    mv "$sums" patches/SHA256SUMS
    success "patches/SHA256SUMS für ${#patches[@]} Patches erstellt und signiert."
}

# --- Optionen -----------------------------------------------------------------

sign_only=0
do_sign=1
version=""
for arg in "$@"; do
    case "$arg" in
        --sign)    sign_only=1 ;;
        --no-sign) do_sign=0 ;;
        -h|--help) sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        fail "Unbekannte Option: $arg" ;;
        *)         [ -z "$version" ] || fail "Es darf nur eine Version angegeben werden."
                   version=$arg ;;
    esac
done
[ "$sign_only" = 0 ] || [ "$do_sign" = 1 ] || fail "--sign und --no-sign schließen sich aus."
[ "$sign_only" = 0 ] || [ -z "$version" ] || fail "--sign erstellt keinen Patch und braucht keine Version."

cd "$(git rev-parse --show-toplevel)"

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

if [ "$sign_only" = 1 ]; then
    sign_patches 1
    echo ""
    echo "Committe beides: git add patches/SHA256SUMS patches/SHA256SUMS.asc && git commit"
    exit 0
fi

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

if [ -z "$version" ]; then
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

# Reiner "git diff" (kein format-patch: ohne Commit-Kopf, Datum und Autor), mit
# festen Optionen, damit derselbe Stand immer denselben Patch ergibt –
# unabhängig von der Git-Konfiguration des Aufrufers.
tmp="$workdir/patch"
git diff --binary --no-color --no-ext-diff --no-textconv --no-renames \
    --diff-algorithm=myers --abbrev=7 --src-prefix=a/ --dst-prefix=b/ \
    base HEAD -- "${PANEL_DIRS[@]}" >"$tmp"
[ -s "$tmp" ] || fail "Der Patch ist leer. Es wurde kein Patch erstellt."
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
sign_patches "$do_sign"
echo ""
echo "Nächste Schritte:"
echo "  1. Trage $version in die Versionstabelle ein (README.md, docs/installation.md, patches/README.md)"
echo "     und passe die Zeile \"Aktuelle Panel-Version\" in README.md und docs/index.md an."
echo "  2. Ergänze die Version in KNOWN_PATCHES in scripts/install.sh."
echo "  3. Prüfe, dass der Patch-Server patch.germandactyl.de die neue Version ausliefert"
echo "     (curl -fsSL https://patch.germandactyl.de/${version#v} | head -n 1)."
if [ "$do_sign" = 1 ]; then
    echo "  4. Committe alles: git add $patch_file patches/SHA256SUMS patches/SHA256SUMS.asc patches/README.md README.md docs scripts/install.sh && git commit"
else
    echo "  4. Committe alles: git add $patch_file patches/SHA256SUMS patches/README.md README.md docs scripts/install.sh && git commit"
    echo "  5. Der Maintainer signiert danach mit ./scripts/createPatch.sh --sign (bis dahin lehnt install.sh den Patch ab)."
fi
