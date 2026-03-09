#!/bin/bash
# modules/06_extension_pack.sh - Extension Pack

set -euo pipefail

log_info "Instalando VirtualBox Extension Pack..."

VBOX_VER=$(vboxmanage --version | cut -d'r' -f1)
# Limpiar versión (a veces sale con guiones o avisos)
VBOX_VER=$(echo "$VBOX_VER" | grep -oP '^\d+\.\d+\.\d+')

EXT_URL="https://download.virtualbox.org/virtualbox/${VBOX_VER}/Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
EXT_FILE="/tmp/vbox-extpack.vbox-extpack"

log_info "Descargando versión $VBOX_VER..."
if wget -q "$EXT_URL" -O "$EXT_FILE"; then
    echo "y" | vboxmanage extpack install --replace "$EXT_FILE" > /dev/null
    log_ok "Extension Pack instalado."
    rm -f "$EXT_FILE"
else
    log_error "Fallo al descargar Extension Pack desde $EXT_URL"
fi
