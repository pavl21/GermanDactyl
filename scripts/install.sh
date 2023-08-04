#!/usr/bin/env bash

# Colors
RED='\033[1;31m'
NORMAL='\033[0;39m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'

# Environment
DEFAULT_PATH=/var/www/pterodactyl
PATCH_SERVER=https://patch.germandactyl.de
FORCE_VERSION=none
USER_PATH=none

# Load user variables
while getopts "d:v:" o > /dev/null 2>&1; do
    # shellcheck disable=SC2220
    case "${o}" in
        d) USER_PATH=${OPTARG} ;;
        v) FORCE_VERSION=${OPTARG} ;;
    esac
done

function send_success() {
    echo -e "$GREEN✓ $1$NORMAL"
}

function send_info() {
    echo -e "$BLUEℹ  $1$NORMAL"
}

function send_warn() {
    echo -e "$YELLOW⚠ $1$NORMAL"
}

function send_error() {
    echo -e "$RED✗ $1$NORMAL"
    exit
}

function verify_pterodactyl_path() {
    VERSION=$(cat "$1/config/app.php" 2> /dev/null | grep "'version' =>" | cut -d\' -f4)
    PTERODACTYL_PATH=$1

    if [ "$VERSION" ]; then
        send_success "Es wurde eine Pterodactyl-Instanz mit der Version$BLUE v$VERSION$GREEN unter $BLUE$1$GREEN gefunden."
    else
        send_error "In diesem Ordner wurde keine Pterodactyl-Instanz gefunden. Bitte verwende einen anderen Pfad."
    fi
}

function load_pterodactyl_path() {
    if [ "$USER_PATH" == "none" ]; then
        send_warn "Es wurde kein Instanzort angegeben. Deine Pterodactyl-Instanz wird im default-Ordner gesucht."
        verify_pterodactyl_path $DEFAULT_PATH
    else
        if [ ! -d "$USER_PATH" ]; then
            send_error "Der von dir angegebene Ordner existiert nicht oder GermanDactyl hat darauf keinen Zugriff."
        fi

        verify_pterodactyl_path "$USER_PATH"
    fi
}

function search_patch() {
    if [ "$FORCE_VERSION" != "none" ]; then
        VERSION=$FORCE_VERSION
    fi

    PATCH="$PATCH_SERVER/$VERSION"

    STATUS=$(curl -s -I -L "$PATCH" | grep "HTTP/2" | tail -n 1 | tail -1 | cut -d$' ' -f2)

    if [ "$STATUS" == "404" ]; then
        send_error "Leider gibt es aktuell noch keinen Patch für diese Version ($BLUE v$VERSION$RED ). Wenn du eine andere Version erzwingen möchtest, füge $BLUE-v Version$RED hinzu. Dieser Schritt ist nicht empfohlen."
    fi

    send_success "Es wurde ein Patch mit der Version $BLUE$VERSION$GREEN gefunden. Der Patch wird in 10 Sekunden installiert..."
    send_info "Drücke Strg + C um den Vorgang abzubrechen."
    sleep 10
}

function install_deps() {

    if ! command -v "npm" &> /dev/null; then
        send_info "NPM konnte nicht gefunden werden. Node.JS wird installiert."
        curl -sL https://deb.nodesource.com/setup_16.x | bash - &> /dev/null
        apt -y install nodejs &> /dev/null
        send_success "Node.JS wurde installiert."
    fi

    if ! command -v "npm" &> /dev/null; then
        apt -y install npm &> /dev/null
    fi

    if ! command -v "yarn" &> /dev/null; then
        send_info "Yarn wurde nicht gefunden. Es wird nun installiert."
        npm install -g yarn &> /dev/null
        send_success "Yarn wurde installiert."
    fi

    if ! command -v "git" &> /dev/null; then
        send_info "Git wurde nicht gefunden. Es wird nun installiert."
        apt -y install git &> /dev/null
        send_success "Git wurde installiert."
    fi

}

function apply_patch() {
    send_info "Der Patch wird nun angewendet."
    curl -s -L "$PATCH" -o germandactyl.patch &> /dev/null
    git apply --ignore-whitespace --ignore-space-change -C1 --apply --reject germandactyl.patch &> /dev/null
}

function show_rejected() {
    find . \( -name "*.rej" -o -name "*.orig" \) | while read -r file; do
        file_pretty=$(echo "$file" | cut -c 3-)
        echo -e "$RED✗ ${file_pretty%.*} konnte nicht gepatcht werden. Hat ein Addon diese Datei überschrieben?$NORMAL"
        rm "$file"
    done
}

function compile_panel() {
    send_info "Das Panel wird nun erneut kompiliert. Das dauert einen Moment."
    yarn install &> "$PTERODACTYL_PATH/germandactyl.debug.log"
    NODE_OPTIONS=--openssl-legacy-provider yarn run build:production &> "$PTERODACTYL_PATH/germandactyl.debug.log"
    php artisan view:clear &> "$PTERODACTYL_PATH/germandactyl.debug.log"
    php artisan optimize &> "$PTERODACTYL_PATH/germandactyl.debug.log"
}

if [ $EUID -ne 0 ]; then
    send_error "Du hast mit diesem Account nicht genügend Rechte, um die Installation zu starten. Melde dich mit einem Superuser-Account an, um fortzufahren."
fi

load_pterodactyl_path
search_patch
install_deps
cd "$PTERODACTYL_PATH" || send_error "GermanDactyl konnte den Ordner der Instanz nicht betreten"
apply_patch
show_rejected
compile_panel

send_success "Der Patch wurde angewendet. Viel Spaß! :)"
