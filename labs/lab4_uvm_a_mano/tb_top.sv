// =============================================================================
// tb_top.sv — Módulo top del testbench.
//
// Responsabilidades del top:
//   1. Generar reloj y reset
//   2. Instanciar el DUT y el interface
//   3. Construir el environment y arrancarlo
//
// Nota: el `tb_top` es el único `module` del testbench. Todo lo demás son
// clases. Este es exactamente el patrón de un TB UVM.
// =============================================================================

`timescale 1ns/1ps

// Includes de las clases (compilan en un solo archivo lógico)
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "env.sv"

module tb_top;

    // -------------------------------------------------------------------------
    // Reloj y reset
    // -------------------------------------------------------------------------
    logic clk;
    logic rst_n;

    initial clk = 1'b0;
    always #5 clk = ~clk;   // 100 MHz

    // -------------------------------------------------------------------------
    // Interface + DUT
    // -------------------------------------------------------------------------
    alu_if vif (.clk(clk), .rst_n(rst_n));

    alu dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .a      (vif.a),
        .b      (vif.b),
        .op     (vif.op),
        .result (vif.result),
        .zero   (vif.zero),
        .carry  (vif.carry)
    );

    // -------------------------------------------------------------------------
    // Environment
    // -------------------------------------------------------------------------
    alu_env env;

    initial begin
        int num_trans;
        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_top);

        // Reset
        rst_n = 1'b0;
        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        $display("[TB] Reset liberado en t=%0t", $time);

        // Configuración: N transacciones (default 200)
        if (!$value$plusargs("N=%d", num_trans)) num_trans = 200;

        // Construir y correr el environment
        env = new(vif, num_trans);
        env.build();
        env.run();

        $finish;
    end

    // Watchdog
    initial begin
        #500_000;
        $display("[TB][WATCHDOG] Timeout. Abortando.");
        $finish;
    end

endmodule
