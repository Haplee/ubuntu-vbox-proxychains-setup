#!/bin/bash
# modules/00_preflight.sh - Verificaciones previas

set -euo pipefail

log_info "Iniciando verificaciones previas..."

# 1. Verificar root/sudo
if [[ $EUID -ne 0 ]]; then
    log_error "Este script debe ejecutarse con sudo o como root."
    exit 1
fi

# 2. Verificar OS
if [[ ! -f /etc/debian_version ]]; then
    log_warn "El sistema no parece ser basado en Debian/Ubuntu. Se recomienda precaución."
    read -p "¿Deseas continuar de todos modos? (y/n): " cont
    [[ $cont != "y" ]] && exit 1
fi

# 3. Verificar arquitectura
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    log_warn "Arquitectura detectada: $ARCH. VirtualBox funciona mejor en x86_64."
fi

# 4. Verificar internet
log_info "Verificando conectividad a internet..."
if ! ping -c 1 8.8.8.8 &>/dev/null; then
    log_error "No hay conexión a internet. Se requiere para descargar paquetes."
    exit 1
fi

# 5. Verificar espacio en disco (mínimo 2GB en /)
FREE_SPACE=$(df / --output=avail -h | tail -1 | tr -dc '0-9')
# Nota: simplificación de detección de espacio para este ejemplo
if [[ $FREE_SPACE -lt 2 ]]; then
    log_warn "Poco espacio en disco detectado. Se recomiendan al menos 2GB libres."
fi

log_ok "Preflight completado con éxito."
