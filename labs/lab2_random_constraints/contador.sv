// =============================================================================
// contador.sv — DUT del Laboratorio 2 (idéntico al Lab 1).
// Contador 4-bit up/down con enable y reset asíncrono activo-bajo.
// =============================================================================

module contador (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    input  logic       up_down,
    output logic [3:0] count
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 4'b0000;
        else if (enable)
            count <= up_down ? (count + 4'b0001) : (count - 4'b0001);
    end

endmodule
