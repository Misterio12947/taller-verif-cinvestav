// =============================================================================
// tb_starter.sv — Testbench directed INICIAL (con TODOs).
//
// Objetivo del laboratorio:
//   Completar los TODO marcados para tener un testbench directed clásico:
//     1. Generar el reloj.
//     2. Aplicar reset asíncrono.
//     3. Aplicar estímulos directed (up=5, down=3).
//     4. Chequear el valor esperado del contador con $display.
//
// Compilar con:  ./run.sh
// =============================================================================

`timescale 1ns/1ps

module tb_contador;

    // -------------------------------------------------------------------------
    // Señales del testbench
    // -------------------------------------------------------------------------
    logic       clk;
    logic       rst_n;
    logic       enable;
    logic       up_down;
    logic [3:0] count;

    // -------------------------------------------------------------------------
    // Instancia del DUT
    // -------------------------------------------------------------------------
    contador dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .enable  (enable),
        .up_down (up_down),
        .count   (count)
    );

    // -------------------------------------------------------------------------
    // TODO #1: Generador de reloj
    //   Periodo: 10 ns (frecuencia: 100 MHz)
    //   Pista: initial begin ... forever #5 clk = ~clk;
    // -------------------------------------------------------------------------



    // -------------------------------------------------------------------------
    // TODO #2: Secuencia de estímulos
    //   a) Inicializar todas las señales de entrada a un valor conocido.
    //   b) Aplicar reset asíncrono (rst_n = 0) por al menos 2 ciclos, luego liberar.
    //   c) Cuenta hacia arriba 5 ciclos con enable=1, up_down=1.
    //   d) Cuenta hacia abajo 3 ciclos con enable=1, up_down=0.
    //   e) $display del valor final y $finish.
    // -------------------------------------------------------------------------
    initial begin
        // Volcado de ondas para Verdi/GTKWave
        $dumpfile("tb_contador.vcd");
        $dumpvars(0, tb_contador);

        // a) Inicialización

        // b) Reset

        // c) 5 cuentas up

        // d) 3 cuentas down

        // e) Reporte final
        $display("[TB] Valor final del contador = %0d (esperado: 2)", count);
        $finish;
    end

    // -------------------------------------------------------------------------
    // TODO #3 (opcional, para discusión):
    //   Agregar un $display en cada flanco de clk que imprima el valor de count.
    //   Pista: usar always @(posedge clk) con $display("t=%0t count=%0d", $time, count);
    // -------------------------------------------------------------------------

endmodule
