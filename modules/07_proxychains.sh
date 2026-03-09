# modules/07_proxychains.sh - Instalación de ProxyChains

set -euo pipefail

log_info "Instalando ProxyChains..."

# Preferir proxychains-ng si está disponible, si no proxychains4
if apt-cache show proxychains-ng &>/dev/null; then
    PKG="proxychains-ng"
elif apt-cache show proxychains4 &>/dev/null; then
    PKG="proxychains4"
else
    PKG="proxychains"
fi

apt-get install -y "$PKG" -qq > /dev/null

# Detectar binario y config
export PROXYCHAINS_BIN=$(command -v proxychains4 || command -v proxychains)
if [[ -f /etc/proxychains4.conf ]]; then
    export PROXYCHAINS_CONF="/etc/proxychains4.conf"
else
    export PROXYCHAINS_CONF="/etc/proxychains.conf"
fi

log_ok "ProxyChains instalado ($PKG)."
