// =============================================================================
// tb_top_starter.sv — Testbench INICIAL para completar durante el Lab 4.
//
// En este starter, casi todo el TB está esqueletado. El estudiante debe:
//   TODO #1: instanciar el DUT y conectar sus pines al interface
//   TODO #2: instanciar el environment y llamar build() + run()
//
// El objetivo es que ENTIENDA la orquestación mirándola en concreto:
//   - Cómo el tb_top usa el interface como puente
//   - Cómo el env se instancia y arranca
//   - Cómo las clases (declaradas en los otros .sv) hacen todo el trabajo
// =============================================================================

`timescale 1ns/1ps

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "env.sv"

module tb_top;

    logic clk;
    logic rst_n;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Interface (dado)
    alu_if vif (.clk(clk), .rst_n(rst_n));

    // -------------------------------------------------------------------------
    // TODO #1: instanciar el DUT `alu` conectando sus pines a `vif.*`
    //
    // Pistas:
    //   alu dut (
    //     .clk    (clk),
    //     .rst_n  (rst_n),
    //     .a      (vif.a),
    //     .b      (vif.b),
    //     .op     (vif.op),
    //     .result (vif.result),
    //     .zero   (vif.zero),
    //     .carry  (vif.carry)
    //   );
    // -------------------------------------------------------------------------



    // Declaración del environment (dado)
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

        if (!$value$plusargs("N=%d", num_trans)) num_trans = 200;

        // -------------------------------------------------------------------
        // TODO #2: construir el environment y arrancarlo.
        //
        // Pistas:
        //   env = new(vif, num_trans);
        //   env.build();
        //   env.run();
        // -------------------------------------------------------------------



        $finish;
    end

    initial begin
        #500_000;
        $display("[TB][WATCHDOG] Timeout. Abortando.");
        $finish;
    end

endmodule
