// =============================================================================
// tb_starter.sv — Lab 3 INICIAL.
//
// Objetivo:
//   Sobre el TB constrained-random del Lab 2, agregar:
//     TODO #1: un covergroup que mida coverage funcional del contador
//     TODO #2: hacer `bind` del módulo `checker_sva` al DUT
//
// Al terminar, el reporte debe imprimir un porcentaje de coverage y las
// assertions SVA deben haberse ejecutado durante la simulación.
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
module tb_contador;

    logic       clk, rst_n, enable, up_down;
    logic [3:0] count;
    logic [3:0] expected;
    int         errores, num_trans;

    contador dut (.*);

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // TODO #1: covergroup
    //
    //   covergroup cg_contador @(posedge clk);
    //     cp_count: coverpoint count {
    //       bins low     = {[0:3]};
    //       bins mid     = {[4:11]};
    //       bins high    = {[12:15]};
    //     }
    //     cp_dir: coverpoint up_down iff (enable) {
    //       bins up   = {1};
    //       bins down = {0};
    //     }
    //     cross_count_dir: cross cp_count, cp_dir;
    //   endgroup
    //
    //   cg_contador cg_h;
    //
    //   Y en el initial: cg_h = new();
    // -------------------------------------------------------------------------



    // -------------------------------------------------------------------------
    // TODO #2: bind del checker SVA al DUT
    //
    //   Fuera del module o al inicio del module:
    //     bind contador checker_sva u_sva (.*);
    //
    //   Esto engancha las properties del checker sin modificar el DUT.
    // -------------------------------------------------------------------------



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

        // TODO: instanciar covergroup aquí

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;

        txn = new();
        repeat (200) begin
            ok = txn.randomize();
            assert (ok);
            apply_txn(txn.enable, txn.up_down, txn.repeticiones);
        end

        $display("=====================================================");
        $display("[TB] Transacciones aplicadas: %0d", num_trans);
        $display("[TB] Errores: %0d", errores);
        // TODO: imprimir cg_h.get_coverage()
        if (errores == 0) $display("[TB] RESULTADO: PASS");
        else               $display("[TB] RESULTADO: FAIL");
        $display("=====================================================");
        $finish;
    end

    initial begin #500_000; $finish; end

endmodule
