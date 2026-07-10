#!/usr/bin/env bash
# =============================================================================
# run.sh — Compila y corre el Lab 1 usando VCS.
# Uso:
#   ./run.sh              → corre tb_solution.sv
#   ./run.sh starter      → corre tb_starter.sv (para probar el TODO)
#   ./run.sh verdi        → abre Verdi con las ondas
#   ./run.sh clean        → limpia artefactos
# =============================================================================

set -e

ACTION=${1:-solution}
WORK=work_lab1

VCS_FLAGS="-full64 -sverilog -debug_access+all -kdb -lca -timescale=1ns/1ps"

case "$ACTION" in
    solution)
        echo "[run.sh] Compilando tb_solution.sv con VCS..."
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../contador.sv \
            ../tb_solution.sv
        echo "[run.sh] Ejecutando simulación..."
        ./simv
        echo ""
        echo "[run.sh] Waveform disponible en $WORK/tb_contador.vcd"
        ;;

    starter)
        echo "[run.sh] Compilando tb_starter.sv con VCS..."
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../contador.sv \
            ../tb_starter.sv
        echo "[run.sh] Ejecutando simulación..."
        ./simv
        ;;

    verdi)
        if [ ! -f $WORK/tb_contador.vcd ]; then
            echo "[run.sh] No hay VCD. Corre primero './run.sh' o './run.sh starter'."
            exit 1
        fi
        cd $WORK
        verdi -sv -f ../contador.sv ../tb_solution.sv -ssf tb_contador.fsdb &
        ;;

    clean)
        echo "[run.sh] Limpiando artefactos..."
        rm -rf $WORK csrc simv simv.daidir ucli.key *.vcd *.fsdb *.log verdiLog novas.* DVEfiles
        ;;

    *)
        echo "Uso: $0 {solution|starter|verdi|clean}"
        exit 1
        ;;
esac
