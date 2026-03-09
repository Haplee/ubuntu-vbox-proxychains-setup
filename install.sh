#!/bin/bash
# install.sh - Script maestro (Orquestador)

set -euo pipefail

# Colores y logging
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[1;33m'
export NC='\033[0m' # No Color

log_info()  { echo -e "${NC}[INFO] $1"; }
log_ok()    { echo -e "${GREEN}[OK] $1${NC}"; }
log_warn()  { echo -e "${YELLOW}[WARN] $1${NC}"; }
log_error() { echo -e "${RED}[ERROR] $1${NC}"; }

export -f log_info log_ok log_warn log_error

# Directorio del script para rutas absolutas
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Directorio de logs
mkdir -p logs
LOG_FILE="logs/install_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Ayuda
show_help() {
    echo "Uso: sudo ./install.sh [opciones]"
    echo ""
    echo "Opciones:"
    echo "  --silent                  Modo no interactivo"
    echo "  --help                    Mostrar esta ayuda"
    echo ""
    exit 0
}

# Parsear argumentos simple
for arg in "$@"; do
    case $arg in
        --help) show_help ;;
        --silent) export SILENT_MODE=true ;;
    esac
done

log_info "=== UBUNTU VBOX & PROXYCHAINS SETUP ==="
log_info "Log guardado en: $LOG_FILE"

# Orquestación de módulos (usando SCRIPT_DIR)
source "$SCRIPT_DIR/modules/00_preflight.sh"
source "$SCRIPT_DIR/modules/01_detect_system.sh"
source "$SCRIPT_DIR/modules/02_install_deps.sh"
source "$SCRIPT_DIR/modules/03_virtualbox.sh"
source "$SCRIPT_DIR/modules/04_kernel_modules.sh"
source "$SCRIPT_DIR/modules/05_secure_boot.sh"
source "$SCRIPT_DIR/modules/06_extension_pack.sh"
source "$SCRIPT_DIR/modules/07_proxychains.sh"
source "$SCRIPT_DIR/modules/08_proxy_config.sh"
source "$SCRIPT_DIR/modules/09_aliases.sh"
source "$SCRIPT_DIR/modules/10_verify.sh"

log_ok "=== INSTALACIÓN TOTAL FINALIZADA ==="
