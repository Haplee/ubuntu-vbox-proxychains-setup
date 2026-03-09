# modules/09_aliases.sh - Configuración de Shell

set -euo pipefail

log_info "Configurando aliases en $SHELL_RC_FILE..."

ALIASES=(
    "alias pc='proxychains4'"
    "alias pcurl='proxychains4 curl'"
    "alias pwget='proxychains4 wget'"
    "alias pnmap='proxychains4 nmap -sT'"
)

# Añadir si no existen
for alias_cmd in "${ALIASES[@]}"; do
    if ! grep -qF "$alias_cmd" "$SHELL_RC_FILE" 2>/dev/null; then
        echo "$alias_cmd" >> "$SHELL_RC_FILE"
    fi
done

# Guard para scripts shell comunes si estamos en zsh
if [[ "$SHELL_TYPE" == "zsh" ]]; then
    # Evitar errores de bashismos en archivos cargados
    if ! grep -q "BASH_VERSION" "$SHELL_RC_FILE" 2>/dev/null; then
        sed -i '1i[ -z "$BASH_VERSION" ] && [ -n "$ZSH_VERSION" ] && setopt SH_WORD_SPLIT 2>/dev/null' "$SHELL_RC_FILE"
    fi
fi

log_ok "Aliases añadidos correctamente."
