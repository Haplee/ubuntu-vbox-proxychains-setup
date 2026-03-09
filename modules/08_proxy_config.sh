# modules/08_proxy_config.sh - Configuración de Proxy y Tor

set -euo pipefail

log_info "Configurando ProxyChains..."

# Instalar Tor por defecto para tener un proxy funcional inmediatamente
log_info "Asegurando servicio Tor para anonimato base..."
apt-get install -y tor -qq > /dev/null
systemctl enable tor --now > /dev/null

# Backup de config
cp "$PROXYCHAINS_CONF" "${PROXYCHAINS_CONF}.bak"

# Crear configuración dinámica con Tor por defecto
cat > "$PROXYCHAINS_CONF" << EOF
strict_chain
proxy_dns 
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5  127.0.0.1 9050
EOF

log_ok "Configuración de ProxyChains aplicada (Tor por defecto en 127.0.0.1:9050)."
