// =============================================================================
// alu_if.sv — Interface entre el testbench OO y el DUT (ALU).
//
// Empaqueta todas las señales del bus de la ALU en un solo objeto que las
// classes del TB (driver, monitor) accederán vía `virtual interface`.
//
// El clocking block asegura que estímulos y muestreo no tengan race
// conditions con el DUT (patrón industrial).
// =============================================================================

interface alu_if (input logic clk, input logic rst_n);

    // Señales
    logic [3:0] a;
    logic [3:0] b;
    logic [1:0] op;
    logic [3:0] result;
    logic       zero;
    logic       carry;

    // Clocking block del testbench: driver estimula en negedge, monitor
    // muestrea en posedge con skew de #1 para dejar propagar la combinacional.
    clocking cb_tb @(posedge clk);
        default input #1 output #1;
        output a, b, op;
        input  result, zero, carry;
    endclocking

    // Modport para el driver (escribe entradas)
    modport DRV (clocking cb_tb, input clk, rst_n);

    // Modport para el monitor (solo lee)
    modport MON (clocking cb_tb, input clk, rst_n);

endinterface
