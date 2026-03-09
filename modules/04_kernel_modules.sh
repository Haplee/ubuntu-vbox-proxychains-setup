#!/bin/bash
# modules/04_kernel_modules.sh - Gestión de módulos del kernel

set -euo pipefail

log_info "Compilando y cargando módulos del kernel..."

# Intentar compilación base
if ! /sbin/vboxconfig > /dev/null 2>&1; then
    log_warn "vboxconfig falló inicialmente. Verificando si es por Secure Boot..."
    # El manejo de Secure Boot se hará en el siguiente módulo si es necesario
fi

# Carga manual de módulos
for mod in vboxdrv vboxnetflt vboxnetadp; do
    if ! lsmod | grep -q "$mod"; then
        modprobe "$mod" || log_warn "No se pudo cargar el módulo: $mod"
    fi
done

# Persistencia
cat > /etc/modules-load.d/virtualbox.conf << EOF
vboxdrv
vboxnetflt
vboxnetadp
EOF

log_ok "Módulos del kernel procesados."
