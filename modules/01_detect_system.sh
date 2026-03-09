#!/bin/bash
# modules/01_detect_system.sh - Detección del entorno

set -euo pipefail

log_info "Detectando parámetros del sistema..."

export UBUNTU_VERSION=$(lsb_release -rs)
export UBUNTU_CODENAME=$(lsb_release -cs)
export KERNEL_VERSION=$(uname -r)
export ARCH=$(dpkg --print-architecture)

# Detectar Secure Boot
if command -v mokutil &>/dev/null; then
    SB_STATUS=$(mokutil --sb-state | awk '{print $2}')
else
    # Si no está mokutil, lo instalaremos en el siguiente módulo, 
    # por ahora asumimos desconocido o intentamos instalarlo.
    SB_STATUS="unknown"
fi
export SECURE_BOOT_STATUS=$SB_STATUS

# Detectar Shell
if [[ -n "$SHELL" ]]; then
    export SHELL_TYPE=$(basename "$SHELL")
else
    export SHELL_TYPE="bash"
fi

case "$SHELL_TYPE" in
    zsh)  export SHELL_RC_FILE="$HOME/.zshrc" ;;
    fish) export SHELL_RC_FILE="$HOME/.config/fish/config.fish" ;;
    *)    export SHELL_RC_FILE="$HOME/.bashrc" ;;
esac

log_info "Sistema detectado: Ubuntu $UBUNTU_VERSION ($UBUNTU_CODENAME)"
log_info "Kernel: $KERNEL_VERSION | Secure Boot: $SECURE_BOOT_STATUS"
