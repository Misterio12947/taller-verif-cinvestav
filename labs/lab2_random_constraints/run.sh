#!/usr/bin/env bash
# =============================================================================
# run.sh — Lab 2 (constrained random).
# Uso:
#   ./run.sh              → tb_solution.sv con seed=1
#   ./run.sh starter      → tb_starter.sv
#   ./run.sh seed 42      → tb_solution.sv con seed=42 (reproducibilidad)
#   ./run.sh verdi        → abre Verdi
#   ./run.sh clean
# =============================================================================

set -e
ACTION=${1:-solution}
SEED=${2:-1}
WORK=work_lab2

VCS_FLAGS="-full64 -sverilog -debug_access+all -kdb -lca -timescale=1ns/1ps"

case "$ACTION" in
    solution)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv ../contador.sv ../tb_solution.sv
        ./simv +ntb_random_seed=$SEED
        ;;
    starter)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv ../contador.sv ../tb_starter.sv
        ./simv +ntb_random_seed=$SEED
        ;;
    seed)
        SEED=${2:-1}
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv ../contador.sv ../tb_solution.sv
        echo "[run.sh] Corriendo con seed=$SEED"
        ./simv +ntb_random_seed=$SEED
        ;;
    verdi)
        cd $WORK
        verdi -sv -f ../contador.sv ../tb_solution.sv -ssf tb_contador.fsdb &
        ;;
    clean)
        rm -rf $WORK csrc simv simv.daidir ucli.key *.vcd *.fsdb *.log verdiLog novas.* DVEfiles
        ;;
    *)
        echo "Uso: $0 {solution|starter|seed <N>|verdi|clean}"
        exit 1
        ;;
esac
