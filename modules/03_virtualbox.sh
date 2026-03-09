#!/bin/bash
# modules/03_virtualbox.sh - Instalación de VirtualBox

set -euo pipefail

log_info "Configurando repositorio de VirtualBox..."

# Clave GPG
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | \
    gpg --dearmor --yes -o /usr/share/keyrings/oracle-virtualbox.gpg

# Repo oficial
# Si la versión de Ubuntu es muy nueva, usamos jammy como fallback (según prompt)
REPO_CODENAME=$UBUNTU_CODENAME
# Ejemplo de validación básica de codename
if [[ "$UBUNTU_CODENAME" == "noble" ]]; then
    # Por ahora 7.1 soporta noble, pero si fallara se podría ajustar aquí
    REPO_CODENAME="noble"
fi

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $REPO_CODENAME contrib" \
    | tee /etc/apt/sources.list.d/virtualbox.list > /dev/null

apt-get update -qq

log_info "Instalando VirtualBox 7.1..."
apt-get install -y virtualbox-7.1 -qq > /dev/null

# Grupo de usuarios
if [[ -n "${SUDO_USER:-}" ]]; then
    usermod -aG vboxusers "$SUDO_USER"
    log_info "Usuario $SUDO_USER añadido al grupo vboxusers."
fi

log_ok "VirtualBox instalado correctamente."
