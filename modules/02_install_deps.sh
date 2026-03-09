#!/bin/bash
# modules/02_install_deps.sh - Instalación de dependencias base

set -euo pipefail

log_info "Instalando dependencias base..."

DEPS=(
    wget curl gnupg2 lsb-release software-properties-common
    dkms build-essential openssl mokutil
    apt-transport-https ca-certificates
    linux-headers-$(uname -r)
)

apt-get update -qq
apt-get install -y "${DEPS[@]}" -qq > /dev/null

log_ok "Dependencias básicas instaladas."
