// =============================================================================
// checker_sva.sv — Módulo bind-able con propiedades SVA (assertions temporales).
//
// Vigila reglas del contador que son difíciles de chequear en un procedural:
//   P1: en reset, count debe estar en 0.
//   P2: si enable=0 y no hay reset, count no debe cambiar entre ciclos.
//   P3: si enable=1 y up_down=1, en el siguiente ciclo count = count_prev + 1.
//
// Se instancia como monitor pasivo. En un TB profesional esto va en un
// `bind` para acoplarse al DUT sin modificarlo.
// =============================================================================

module checker_sva (
    input logic       clk,
    input logic       rst_n,
    input logic       enable,
    input logic       up_down,
    input logic [3:0] count
);

    // -------------------------------------------------------------------------
    // Property 1: durante reset, count debe ser 0.
    // -------------------------------------------------------------------------
    property p_reset_clears_count;
        @(posedge clk) (!rst_n) |-> (count == 4'b0000);
    endproperty
    a_reset_clears: assert property (p_reset_clears_count)
        else $error("[SVA] P1 violada: count=%0d durante reset", count);

    // -------------------------------------------------------------------------
    // Property 2: con enable=0 (y sin reset), count no cambia.
    // Usamos $stable(count) que verdadero cuando el valor no cambió respecto
    // al ciclo anterior.
    // -------------------------------------------------------------------------
    property p_hold_when_disabled;
        @(posedge clk) disable iff (!rst_n)
            (!enable) |=> $stable(count);
    endproperty
    a_hold_disabled: assert property (p_hold_when_disabled)
        else $error("[SVA] P2 violada: count cambió con enable=0");

    // -------------------------------------------------------------------------
    // Property 3: con enable=1 y up_down=1, count aumenta en 1 al siguiente
    // flanco (con wrap-around natural).
    // -------------------------------------------------------------------------
    property p_increment_when_up;
        @(posedge clk) disable iff (!rst_n)
            (enable && up_down) |=> (count == $past(count) + 4'b0001);
    endproperty
    a_increment: assert property (p_increment_when_up)
        else $error("[SVA] P3 violada: count=%0d esperado=%0d", count, $past(count)+1);

    // -------------------------------------------------------------------------
    // Cover properties: le decimos al simulador que estos escenarios
    // "queremos verlos" durante la simulación. Aparecen en el reporte de
    // coverage como "covered" o "not covered".
    // -------------------------------------------------------------------------
    c_overflow:  cover property (
        @(posedge clk) (count == 4'b1111) ##1 (count == 4'b0000)
    );

    c_underflow: cover property (
        @(posedge clk) (count == 4'b0000) ##1 (count == 4'b1111)
    );

    c_toggle_dir: cover property (
        @(posedge clk) (enable && up_down) ##1 (enable && !up_down)
    );

endmodule
