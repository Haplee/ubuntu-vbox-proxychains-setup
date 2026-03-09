#!/bin/bash
# tests/test_all.sh - Suite de pruebas básica

set -euo pipefail

echo "Iniciando tests de validación..."

test_cmd() {
    if command -v "$1" &>/dev/null; then
        echo "[PASS] $1 está instalado."
    else
        echo "[FAIL] $1 no encontrado."
    fi
}

test_cmd "vboxmanage"
test_cmd "proxychains4"
test_cmd "tor"

if lsmod | grep -q vboxdrv; then
    echo "[PASS] Módulo vboxdrv cargado."
else
    echo "[FAIL] Módulo vboxdrv no cargado."
fi

echo "Tests finalizados."
