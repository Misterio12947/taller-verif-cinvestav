// =============================================================================
// driver.sv — Toma transacciones del mailbox y las aplica al DUT vía interface.
//
// Responsabilidad única: convertir una transaction (nivel abstracto) en
// wiggle de señales físicas del bus del DUT (nivel eléctrico).
//
// Usa `virtual interface` para acceder al bus sin acoplarse al TB específico.
//
// En UVM esta clase es un `uvm_driver #(T)`, con el mismo patrón:
//   forever begin
//     seq_item_port.get_next_item(t);
//     drive(t);
//     seq_item_port.item_done();
//   end
// =============================================================================

class alu_driver;

    virtual alu_if                vif;
    mailbox #(alu_transaction)    gen2drv;
    int                            num_driven;

    function new(virtual alu_if vif, mailbox #(alu_transaction) gen2drv);
        this.vif        = vif;
        this.gen2drv    = gen2drv;
        this.num_driven = 0;
    endfunction

    task run();
        alu_transaction t;
        // Inicializar señales
        vif.a  = '0;
        vif.b  = '0;
        vif.op = '0;

        forever begin
            gen2drv.get(t);          // bloqueante: espera transacción
            drive(t);
            num_driven++;
        end
    endtask

    // Aplicar una transacción al bus del DUT (un ciclo)
    task drive(alu_transaction t);
        @(vif.cb_tb);
        vif.cb_tb.a  <= t.a;
        vif.cb_tb.b  <= t.b;
        vif.cb_tb.op <= t.op;
    endtask

endclass
