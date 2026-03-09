# modules/10_verify.sh - Verificación final

set -euo pipefail

log_info "Ejecutando verificación final..."

echo -e "\n${NC}╔═══════════════════════════════════════════════════╗"
echo -e "║           VERIFICACIÓN FINAL DEL SISTEMA          ║"
echo -e "╠═══════════════════════════════════════════════════╣"

check() {
    local name="$1"
    local cmd="$2"
    if eval "$cmd" &>/dev/null; then
        printf "║  %-35s  [  ${GREEN}OK${NC}  ] ║\n" "$name"
    else
        printf "║  %-35s  [ ${RED}FAIL${NC} ] ║\n" "$name"
    fi
}

check "VirtualBox instalado"         "vboxmanage --version"
check "vboxdrv cargado"              "lsmod | grep -q vboxdrv"
check "Extension Pack activo"        "vboxmanage list extpacks | grep -q 'Oracle VM'"
check "ProxyChains disponible"       "command -v proxychains4 || command -v proxychains"
check "Tor Service activo"           "systemctl is-active tor"
check "Configuración en Shell"       "grep -q 'alias pc=' $SHELL_RC_FILE"

echo -e "╚═══════════════════════════════════════════════════╝\n"

log_ok "Instalación completada con éxito."
log_info "Por favor, reinicia la terminal o ejecuta: source $SHELL_RC_FILE"
