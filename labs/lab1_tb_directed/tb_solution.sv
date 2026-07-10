// =============================================================================
// tb_solution.sv — Testbench directed COMPLETO (solución del Lab 1).
//
// Muestra un TB tradicional con las 6 piezas universales:
//   1. Generación de reloj
//   2. Aplicación de reset
//   3. Secuencia directed de estímulos
//   4. Auto-checking manual con $display y una variable de referencia
//   5. Volcado de ondas (VCD/FSDB)
//   6. Terminación limpia con $finish
//
// Este será el punto de partida del Módulo 3 para agregarle randomización.
// =============================================================================

`timescale 1ns/1ps

module tb_contador;

    // -------------------------------------------------------------------------
    // 1. Señales y DUT
    // -------------------------------------------------------------------------
    logic       clk;
    logic       rst_n;
    logic       enable;
    logic       up_down;
    logic [3:0] count;

    // Modelo de referencia manual (nuestro "golden" en miniatura)
    logic [3:0] expected;
    int         errores;

    contador dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .enable  (enable),
        .up_down (up_down),
        .count   (count)
    );

    // -------------------------------------------------------------------------
    // 2. Generación de reloj: 100 MHz (periodo 10 ns)
    // -------------------------------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // 3. Tarea auxiliar: un ciclo con estímulos dados + chequeo
    // -------------------------------------------------------------------------
    task automatic step (input logic en, input logic ud);
        // Aplicamos estímulos justo después del flanco
        @(negedge clk);
        enable  = en;
        up_down = ud;

        // Actualizamos modelo de referencia
        if (en) expected = ud ? (expected + 1) : (expected - 1);

        // Esperamos siguiente flanco y comparamos
        @(posedge clk);
        #1; // pequeño delta para dejar propagar
        if (count !== expected) begin
            $display("[TB][ERROR] t=%0t  count=%0d  expected=%0d", $time, count, expected);
            errores++;
        end else begin
            $display("[TB][OK]    t=%0t  count=%0d", $time, count);
        end
    endtask

    // -------------------------------------------------------------------------
    // 4. Estímulos directed
    // -------------------------------------------------------------------------
    initial begin
        $dumpfile("tb_contador.vcd");
        $dumpvars(0, tb_contador);

        // Inicialización
        rst_n    = 1'b0;
        enable   = 1'b0;
        up_down  = 1'b0;
        expected = 4'b0000;
        errores  = 0;

        // Reset asíncrono por 2 ciclos
        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        $display("[TB] Reset liberado en t=%0t", $time);

        // 5 cuentas hacia arriba
        repeat (5) step(.en(1'b1), .ud(1'b1));

        // 3 cuentas hacia abajo
        repeat (3) step(.en(1'b1), .ud(1'b0));

        // Un ciclo sin enable (no debe cambiar)
        step(.en(1'b0), .ud(1'b1));

        // -----------------------------------------------------------------
        // 5. Reporte final
        // -----------------------------------------------------------------
        $display("");
        $display("=====================================================");
        $display("[TB] Simulación terminada.");
        $display("[TB] Valor final del contador = %0d (esperado: %0d)", count, expected);
        $display("[TB] Errores detectados: %0d", errores);
        if (errores == 0)
            $display("[TB] RESULTADO: PASS");
        else
            $display("[TB] RESULTADO: FAIL");
        $display("=====================================================");
        $finish;
    end

    // Watchdog: si algo se atora, salir
    initial begin
        #10_000;
        $display("[TB][WATCHDOG] Simulación excedió 10 us. Abortando.");
        $finish;
    end

endmodule
