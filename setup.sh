#!/usr/bin/env bash
# =============================================================================
# setup.sh — Arranque rápido del curso.
#
# Uso:
#   ./setup.sh docker       → construye la imagen Docker y arranca Slidev
#   ./setup.sh local        → npm install local (requiere Node 18+)
#   ./setup.sh dev          → arranca Slidev en modo dev (requiere setup local previo)
#   ./setup.sh build        → build estático para desplegar (dist/)
#   ./setup.sh pdf          → exporta a curso.pdf
# =============================================================================

set -e
ACTION=${1:-docker}

case "$ACTION" in
    docker)
        echo "[setup] Construyendo imagen Docker..."
        docker build -t verif-propedeutico .
        echo "[setup] Arrancando Slidev en http://localhost:3030"
        docker run --rm -it -p 3030:3030 -v "$PWD":/slides verif-propedeutico
        ;;
    local)
        echo "[setup] Instalando dependencias con npm..."
        npm install
        echo "[setup] Listo. Correr: ./setup.sh dev"
        ;;
    dev)
        if [ ! -d node_modules ]; then
            echo "[setup] node_modules no existe. Corriendo npm install primero..."
            npm install
        fi
        npx slidev slides.md --port 3030
        ;;
    build)
        if [ ! -d node_modules ]; then npm install; fi
        npx slidev build slides.md
        echo "[setup] Build listo en dist/"
        ;;
    pdf)
        if [ ! -d node_modules ]; then npm install; fi
        npx slidev export slides.md --output curso.pdf --format pdf
        echo "[setup] PDF generado: curso.pdf"
        ;;
    *)
        echo "Uso: $0 {docker|local|dev|build|pdf}"
        exit 1
        ;;
esac
