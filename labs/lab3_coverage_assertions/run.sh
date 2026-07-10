#!/usr/bin/env bash
# =============================================================================
# run.sh — Lab 3 (coverage + assertions).
# Uso:
#   ./run.sh              → solución
#   ./run.sh starter      → starter
#   ./run.sh cov          → solución + genera reporte URG de coverage
#   ./run.sh urg          → abre el reporte HTML de coverage generado
#   ./run.sh verdi        → abre Verdi
#   ./run.sh clean
# =============================================================================

set -e
ACTION=${1:-solution}
SEED=${2:-1}
WORK=work_lab3

VCS_FLAGS="-full64 -sverilog -debug_access+all -kdb -lca -timescale=1ns/1ps -assert svaext"
COV_FLAGS="-cm line+cond+fsm+tgl+branch+assert -cm_dir cm.vdb"

case "$ACTION" in
    solution)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../contador.sv ../checker_sva.sv ../tb_solution.sv
        ./simv +ntb_random_seed=$SEED
        ;;
    starter)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS -o simv \
            ../contador.sv ../checker_sva.sv ../tb_starter.sv
        ./simv +ntb_random_seed=$SEED
        ;;
    cov)
        mkdir -p $WORK && cd $WORK
        vcs $VCS_FLAGS $COV_FLAGS -o simv \
            ../contador.sv ../checker_sva.sv ../tb_solution.sv
        ./simv +ntb_random_seed=$SEED -cm line+cond+fsm+tgl+branch+assert -cm_dir cm.vdb
        echo ""
        echo "[run.sh] Generando reporte de coverage con URG..."
        urg -dir cm.vdb -report cov_report
        echo "[run.sh] Reporte HTML en $WORK/cov_report/dashboard.html"
        ;;
    urg)
        if [ ! -f $WORK/cov_report/dashboard.html ]; then
            echo "[run.sh] No hay reporte de coverage. Corre './run.sh cov' primero."
            exit 1
        fi
        xdg-open $WORK/cov_report/dashboard.html 2>/dev/null || \
        firefox $WORK/cov_report/dashboard.html 2>/dev/null || \
        echo "[run.sh] Abre manualmente: $WORK/cov_report/dashboard.html"
        ;;
    verdi)
        cd $WORK
        verdi -sv -f ../contador.sv ../checker_sva.sv ../tb_solution.sv -ssf tb_contador.fsdb &
        ;;
    clean)
        rm -rf $WORK csrc simv simv.daidir ucli.key *.vcd *.fsdb *.log verdiLog novas.* DVEfiles cm.vdb cov_report urgReport
        ;;
    *)
        echo "Uso: $0 {solution|starter|cov|urg|verdi|clean}"
        exit 1
        ;;
esac
