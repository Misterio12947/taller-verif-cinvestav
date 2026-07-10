#!/usr/bin/env bash
# =============================================================================
# run.sh — Lab 4 (UVM a mano).
# Uso:
#   ./run.sh              → corre tb_top.sv (solución) con N=200
#   ./run.sh starter      → corre tb_top_starter.sv
#   ./run.sh N 1000       → corre solución con N=1000 transacciones
#   ./run.sh seed 42      → seed específica
#   ./run.sh verdi        → abre Verdi
#   ./run.sh clean
# =============================================================================

set -e
ACTION=${1:-solution}
N=${2:-200}
SEED=${2:-1}
WORK=work_lab4

VCS_FLAGS="-full64 -sverilog -debug_access+all -kdb -lca -timescale=1ns/1ps +incdir+.."

case "$ACTION" in
    solution)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../alu.sv ../alu_if.sv ../tb_top.sv
        ./simv +ntb_random_seed=1 +N=200
        ;;
    starter)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../alu.sv ../alu_if.sv ../tb_top_starter.sv
        ./simv +ntb_random_seed=1 +N=200
        ;;
    N)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../alu.sv ../alu_if.sv ../tb_top.sv
        ./simv +ntb_random_seed=1 +N=$N
        ;;
    seed)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../alu.sv ../alu_if.sv ../tb_top.sv
        ./simv +ntb_random_seed=$SEED +N=200
        ;;
    verdi)
        cd $WORK
        verdi -sv -f ../alu.sv ../alu_if.sv ../tb_top.sv -ssf tb_alu.fsdb &
        ;;
    clean)
        rm -rf $WORK csrc simv simv.daidir ucli.key *.vcd *.fsdb *.log verdiLog novas.* DVEfiles
        ;;
    *)
        echo "Uso: $0 {solution|starter|N <num>|seed <s>|verdi|clean}"
        exit 1
        ;;
esac
