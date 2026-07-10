// =============================================================================
// tb_solution.sv — Lab 3 COMPLETO.
//
// Sobre el TB del Lab 2 agregamos:
//   - covergroup con coverpoints, bins y cross
//   - bind del checker_sva al DUT (assertions temporales)
//   - reporte de coverage al final
//
// Al final el TB muestra:
//   - transacciones aplicadas
//   - errores
//   - porcentaje de functional coverage alcanzado
//   - status de las cover properties
// =============================================================================

`timescale 1ns/1ps

class cnt_txn;
    rand bit enable;
    rand bit up_down;
    rand int repeticiones;
    constraint c_reps  { repeticiones inside {[1:5]}; }
    constraint c_en    { enable dist { 1 := 80, 0 := 20 }; }
endclass

// -----------------------------------------------------------------------------
// Bind del checker fuera del module (patrón profesional).
// El checker_sva se acopla al DUT sin modificarlo.
// -----------------------------------------------------------------------------
bind contador checker_sva u_sva (
    .clk     (clk),
    .rst_n   (rst_n),
    .enable  (enable),
    .up_down (up_down),
    .count   (count)
);

// -----------------------------------------------------------------------------
module tb_contador;

    logic       clk, rst_n, enable, up_down;
    logic [3:0] count;
    logic [3:0] expected;
    int         errores, num_trans;

    contador dut (.*);

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // Functional coverage
    // -------------------------------------------------------------------------
    covergroup cg_contador @(posedge clk);
        option.per_instance = 1;

        // Bins de rangos del contador
        cp_count: coverpoint count {
            bins low     = {[0:3]};
            bins mid_low = {[4:7]};
            bins mid_hi  = {[8:11]};
            bins high    = {[12:15]};
            bins zero    = {0};
            bins max_val = {15};
        }

        // Dirección solo importa cuando enable=1
        cp_dir: coverpoint up_down iff (enable) {
            bins up   = {1};
            bins down = {0};
        }

        // Enable en sí mismo
        cp_en: coverpoint enable {
            bins active   = {1};
            bins inactive = {0};
        }

        // Cross: combinación rango × dirección
        // Esto es lo que da PODER al functional coverage:
        // no solo "visité el valor 15", sino "visité el valor 15 mientras
        // el DUT estaba contando hacia arriba".
        cross_count_dir: cross cp_count, cp_dir;
    endgroup

    cg_contador cg_h;

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

        cg_h = new();

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;

        txn = new();
        repeat (300) begin
            ok = txn.randomize();
            assert (ok);
            apply_txn(txn.enable, txn.up_down, txn.repeticiones);
        end

        // ---------------------------------------------------------------------
        // Reporte
        // ---------------------------------------------------------------------
        $display("");
        $display("=====================================================");
        $display("[TB] Transacciones aplicadas: %0d", num_trans);
        $display("[TB] Errores: %0d", errores);
        $display("[TB] Functional coverage: %.2f%%", cg_h.get_inst_coverage());
        $display("[TB]   cp_count coverage:      %.2f%%", cg_h.cp_count.get_coverage());
        $display("[TB]   cp_dir coverage:        %.2f%%", cg_h.cp_dir.get_coverage());
        $display("[TB]   cross_count_dir cov:    %.2f%%", cg_h.cross_count_dir.get_coverage());
        if (errores == 0)
            $display("[TB] RESULTADO: PASS");
        else
            $display("[TB] RESULTADO: FAIL");
        $display("=====================================================");
        $finish;
    end

    initial begin #500_000; $finish; end

endmodule
