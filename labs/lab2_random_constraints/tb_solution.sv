// =============================================================================
// tb_solution.sv — Lab 2 COMPLETO.
//
// Muestra:
//   - class cnt_txn como primer paso hacia OO en verificación
//   - rand fields con constraints
//   - randomize() con retorno checked
//   - randomize() with { ... } para constraints extras al vuelo
//   - dist para controlar distribución (más up_down que hold)
//
// Con ~200 transacciones aleatorias, el TB prueba MILES de configuraciones
// distintas del contador — imposible de igualar con directed testing.
// =============================================================================

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
// Transacción del contador
// -----------------------------------------------------------------------------
class cnt_txn;
    rand bit enable;
    rand bit up_down;
    rand int repeticiones;

    // Constraint base: repeticiones entre 1 y 5
    constraint c_reps { repeticiones inside {[1:5]}; }

    // Distribución: 80% de las veces enable=1 (para que sí conteemos)
    constraint c_en_dist { enable dist { 1 := 80, 0 := 20 }; }

    // Función auxiliar para debug
    function string convert2string();
        return $sformatf("enable=%0d up_down=%0d reps=%0d",
                         enable, up_down, repeticiones);
    endfunction
endclass

// -----------------------------------------------------------------------------
module tb_contador;

    logic       clk;
    logic       rst_n;
    logic       enable;
    logic       up_down;
    logic [3:0] count;

    logic [3:0] expected;
    int         errores;
    int         num_trans;

    contador dut (.*);

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    task automatic apply_txn (input bit en, input bit ud, input int reps);
        num_trans++;
        for (int i = 0; i < reps; i++) begin
            @(negedge clk);
            enable  = en;
            up_down = ud;
            if (en) expected = ud ? (expected + 1) : (expected - 1);
            @(posedge clk);
            #1;
            if (count !== expected) begin
                $display("[TB][ERROR] t=%0t count=%0d expected=%0d", $time, count, expected);
                errores++;
            end
        end
    endtask

    // -------------------------------------------------------------------------
    initial begin
        cnt_txn txn;
        int ok;

        $dumpfile("tb_contador.vcd");
        $dumpvars(0, tb_contador);

        rst_n = 0; enable = 0; up_down = 0;
        expected = 0; errores = 0; num_trans = 0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;
        $display("[TB] Reset liberado en t=%0t", $time);

        // Semilla explícita para reproducibilidad — VCS usará +ntb_random_seed
        // si se especifica en la línea de comandos.
        txn = new();

        // ---------------------------------------------------------------------
        // Fase 1: 150 transacciones con las constraints por defecto.
        // ---------------------------------------------------------------------
        repeat (150) begin
            ok = txn.randomize();
            assert (ok) else $fatal(1, "randomize() falló");
            apply_txn(txn.enable, txn.up_down, txn.repeticiones);
        end

        // ---------------------------------------------------------------------
        // Fase 2: 30 transacciones inline-constrained para forzar overflow.
        // Forzamos enable=1 y up_down=1 para acumular hacia overflow.
        // ---------------------------------------------------------------------
        $display("[TB] --- Fase 2: forzando patrón de overflow ---");
        repeat (30) begin
            ok = txn.randomize() with {
                enable == 1;
                up_down == 1;
                repeticiones inside {[3:5]};
            };
            assert (ok);
            apply_txn(txn.enable, txn.up_down, txn.repeticiones);
        end

        // ---------------------------------------------------------------------
        // Fase 3: 30 transacciones forzando underflow (decrement).
        // ---------------------------------------------------------------------
        $display("[TB] --- Fase 3: forzando patrón de underflow ---");
        repeat (30) begin
            ok = txn.randomize() with {
                enable == 1;
                up_down == 0;
                repeticiones inside {[3:5]};
            };
            assert (ok);
            apply_txn(txn.enable, txn.up_down, txn.repeticiones);
        end

        // Reporte
        $display("");
        $display("=====================================================");
        $display("[TB] Transacciones aplicadas: %0d", num_trans);
        $display("[TB] Errores detectados: %0d", errores);
        $display("[TB] Valor final del contador = %0d", count);
        if (errores == 0)
            $display("[TB] RESULTADO: PASS");
        else
            $display("[TB] RESULTADO: FAIL");
        $display("=====================================================");
        $finish;
    end

    initial begin
        #500_000;
        $display("[TB][WATCHDOG] Timeout. Abortando.");
        $finish;
    end

endmodule
