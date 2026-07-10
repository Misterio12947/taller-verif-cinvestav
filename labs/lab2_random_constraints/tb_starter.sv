// =============================================================================
// tb_starter.sv — TB con constrained random INICIAL (con TODOs).
//
// Objetivo del laboratorio:
//   Reemplazar los estímulos directed del Lab 1 por estímulos aleatorios
//   controlados con constraints. Esto es la primera vez que usamos:
//     - una `class` en SystemVerilog para modelar una transacción
//     - `rand` fields
//     - `randomize()` con y sin bloque de constraints
//     - `constraint` blocks reutilizables
// =============================================================================

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
// TODO #1: Modelar la transacción como una class
// -----------------------------------------------------------------------------
// Una transacción del contador tiene tres campos aleatorizables:
//   - enable   : 1 bit
//   - up_down  : 1 bit
//   - repeticiones : cuántos ciclos aplicar este estímulo (1 a 5)
//
// Pistas:
//   class cnt_txn;
//     rand bit enable;
//     rand bit up_down;
//     rand int repeticiones;
//     constraint c_reps { repeticiones inside {[1:5]}; }
//   endclass
// -----------------------------------------------------------------------------

// (Escribe aquí tu class cnt_txn)



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

    // Reloj 100 MHz
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // Task auxiliar: aplica un estímulo por N ciclos y chequea.
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
    // TODO #2: Generación aleatoria
    //   a) Instanciar un objeto cnt_txn.
    //   b) En un ciclo de 200 iteraciones:
    //        - Llamar txn.randomize()  ← devuelve 1 si tuvo éxito
    //        - Verificar el retorno con assert
    //        - Llamar apply_txn(txn.enable, txn.up_down, txn.repeticiones)
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
        num_trans = 0;

        // Reset
        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        // ------------- TODO #2 aquí -------------


        // ------------- fin TODO -----------------

        // Reporte final
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

    // Watchdog
    initial begin
        #200_000;
        $display("[TB][WATCHDOG] Timeout. Abortando.");
        $finish;
    end

endmodule
