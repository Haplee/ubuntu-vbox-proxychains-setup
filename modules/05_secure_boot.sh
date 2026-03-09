#!/bin/bash
# modules/05_secure_boot.sh - Manejo de Secure Boot y firma MOK

set -euo pipefail

if [[ "$SECURE_BOOT_STATUS" != "enabled" ]]; then
    log_info "Secure Boot no detectado como activo. Saltando firma de módulos."
    return 0
fi

log_info "Secure Boot activo detectado. Iniciando proceso de firma MOK..."

MOK_DIR="/var/lib/shim-signed/mok"
mkdir -p "$MOK_DIR"

if [[ ! -f "$MOK_DIR/MOK.priv" ]]; then
    log_info "Generando nueva clave MOK..."
    openssl req -new -x509 -newkey rsa:2048 \
      -keyout "$MOK_DIR/MOK.priv" \
      -outform DER \
      -out "$MOK_DIR/MOK.der" \
      -days 36500 \
      -subj "/CN=VirtualBox MOK $(hostname)/" \
      -nodes > /dev/null 2>&1
fi

# Registro de la clave
MOK_PASSWORD=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c 12)
log_warn "ACCIÓN REQUERIDA: Registro de clave MOK."
log_warn "Se te pedirá una contraseña. Usa: $MOK_PASSWORD"

# Importar clave
# En este entorno no usamos expect por simplicidad, informamos al usuario
mokutil --import "$MOK_DIR/MOK.der"

# Firmar módulos
SIGN_FILE=$(find /usr/src/linux-headers-$(uname -r) -name "sign-file" | head -1)
if [[ -n "$SIGN_FILE" ]]; then
    for mod in vboxdrv vboxnetflt vboxnetadp; do
        MOD_PATH=$(modinfo -n "$mod" 2>/dev/null)
        if [[ -n "$MOD_PATH" ]]; then
            "$SIGN_FILE" sha256 "$MOK_DIR/MOK.priv" "$MOK_DIR/MOK.der" "$MOD_PATH"
            log_info "Firmado: $mod"
        fi
    done
else
    log_error "No se encontró la utilidad sign-file. Instala linux-headers correctamente."
fi

log_ok "Firma de módulos completada. Recuerda realizar el 'Enroll MOK' al reiniciar."
