// =============================================================================
// transaction.sv — Modela una operación de la ALU como un objeto.
//
// Contiene los estímulos (a, b, op) y los resultados esperados/observados
// (result, zero, carry). Es la "unidad de comunicación" que circula por
// todo el testbench: generator -> driver -> DUT -> monitor -> scoreboard.
//
// En UVM esta clase sería un `uvm_sequence_item` con las mismas responsabilidades.
// =============================================================================

class alu_transaction;

    // -------------------------------------------------------------------------
    // Campos aleatorizables (inputs de la ALU)
    // -------------------------------------------------------------------------
    rand bit [3:0] a;
    rand bit [3:0] b;
    rand bit [1:0] op;

    // -------------------------------------------------------------------------
    // Campos observados (outputs del DUT — los llenará el monitor)
    // -------------------------------------------------------------------------
    bit [3:0] result;
    bit       zero;
    bit       carry;

    // -------------------------------------------------------------------------
    // Constraints
    // -------------------------------------------------------------------------
    // Por defecto todas las operaciones son igual de probables.
    constraint c_op_dist { op dist { 2'b00 := 25, 2'b01 := 25,
                                     2'b10 := 25, 2'b11 := 25 }; }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------
    function string op_str();
        case (op)
            2'b00: return "ADD";
            2'b01: return "SUB";
            2'b10: return "AND";
            2'b11: return "OR ";
            default: return "???";
        endcase
    endfunction

    function string convert2string();
        return $sformatf("a=%0h b=%0h op=%s -> result=%0h zero=%0b carry=%0b",
                         a, b, op_str(), result, zero, carry);
    endfunction

    // Copia profunda (patrón UVM)
    function alu_transaction clone();
        alu_transaction c = new();
        c.a      = this.a;
        c.b      = this.b;
        c.op     = this.op;
        c.result = this.result;
        c.zero   = this.zero;
        c.carry  = this.carry;
        return c;
    endfunction

endclass
