// =============================================================================
// contador.sv — DUT del Laboratorio 1
// Contador 4-bit up/down con enable y reset asíncrono activo-bajo.
//
// Comportamiento:
//   - rst_n = 0                → count = 0000 (asíncrono)
//   - enable = 0               → count se mantiene
//   - enable = 1, up_down = 1  → count incrementa
//   - enable = 1, up_down = 0  → count decrementa
//   - Wrap-around natural en overflow/underflow.
// =============================================================================

module contador (
    input  logic       clk,
    input  logic       rst_n,      // reset asíncrono, activo-bajo
    input  logic       enable,
    input  logic       up_down,    // 1 = cuenta hacia arriba, 0 = hacia abajo
    output logic [3:0] count
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
        end else if (enable) begin
            if (up_down)
                count <= count + 4'b0001;
            else
                count <= count - 4'b0001;
        end
    end

endmodule
