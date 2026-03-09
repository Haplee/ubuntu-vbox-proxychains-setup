#!/bin/bash
# uninstall.sh - Script de desinstalación total

set -euo pipefail

# Colores básicos
RED='\033[0;31m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[ERROR] Este script debe ejecutarse con sudo.${NC}"
    exit 1
fi

echo -e "${RED}!!! PELIGRO: Esto eliminará VirtualBox y ProxyChains !!!${NC}"
read -p "¿Estás seguro? (y/n): " confirm
[[ $confirm != "y" ]] && exit 0

echo "Desinstalando VirtualBox..."
apt-get purge -y virtualbox* -qq
apt-get autoremove -y -qq

echo "Eliminando repositorios y claves..."
rm -f /etc/apt/sources.list.d/virtualbox.list
rm -f /usr/share/keyrings/oracle-virtualbox.gpg

echo "Desinstalando ProxyChains y Tor..."
apt-get purge -y proxychains* tor -qq

echo "Limpiando configuraciones y módulos..."
rm -f /etc/modules-load.d/virtualbox.conf
rm -f /etc/systemd/system/vboxdrv-load.service

echo "NOTA: Los aliases en los archivos .rc del usuario y las claves MOK no se eliminan automáticamente por seguridad."
echo "Desinstalación completada."
