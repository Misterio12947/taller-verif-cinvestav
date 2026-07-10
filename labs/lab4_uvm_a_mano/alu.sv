// =============================================================================
// alu.sv — DUT del Laboratorio 4.
//
// ALU 4-bit combinacional con 4 operaciones:
//   op = 2'b00  → ADD  : result = a + b
//   op = 2'b01  → SUB  : result = a - b
//   op = 2'b10  → AND  : result = a & b
//   op = 2'b11  → OR   : result = a | b
//
// Salidas:
//   result[3:0] — resultado (wrap-around en ADD/SUB)
//   zero        — flag: 1 si result == 0
//   carry       — flag: 1 si hubo carry-out en ADD (no válido en SUB/AND/OR)
//
// Es un DUT deliberadamente sencillo pero con riqueza suficiente para
// justificar constrained random + scoreboard con reference model.
// =============================================================================

module alu (
    input  logic       clk,       // solo para muestreo en el TB; la ALU es combinacional
    input  logic       rst_n,
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] op,
    output logic [3:0] result,
    output logic       zero,
    output logic       carry
);

    logic [4:0] add_ext;
    assign add_ext = {1'b0, a} + {1'b0, b};

    always_comb begin
        carry  = 1'b0;
        unique case (op)
            2'b00: begin           // ADD
                result = add_ext[3:0];
                carry  = add_ext[4];
            end
            2'b01: result = a - b; // SUB
            2'b10: result = a & b; // AND
            2'b11: result = a | b; // OR
            default: result = 4'b0;
        endcase
    end

    assign zero = (result == 4'b0);

endmodule
