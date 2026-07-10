// =============================================================================
// monitor.sv — Observa el bus del DUT y reconstruye transactions.
//
// Responsabilidad única: mirar el DUT (sin escribir nada) y publicar lo que
// ve como transactions al scoreboard.
//
// Es "pasivo" — nunca modifica el DUT. Solo lee y reporta.
//
// En UVM esta clase es un `uvm_monitor` que publica en un `uvm_analysis_port`.
// Aquí usamos un mailbox como port analógico.
// =============================================================================

class alu_monitor;

    virtual alu_if                vif;
    mailbox #(alu_transaction)    mon2sb;
    int                            num_observed;

    function new(virtual alu_if vif, mailbox #(alu_transaction) mon2sb);
        this.vif          = vif;
        this.mon2sb       = mon2sb;
        this.num_observed = 0;
    endfunction

    task run();
        alu_transaction t;
        forever begin
            @(vif.cb_tb);            // samplear en cada flanco
            // Ignorar el primer ciclo tras reset (valores basura)
            if (!vif.rst_n) continue;

            t = new();
            t.a      = vif.cb_tb.a;
            t.b      = vif.cb_tb.b;
            t.op     = vif.cb_tb.op;
            t.result = vif.cb_tb.result;
            t.zero   = vif.cb_tb.zero;
            t.carry  = vif.cb_tb.carry;

            mon2sb.put(t);
            num_observed++;
        end
    endtask

endclass
