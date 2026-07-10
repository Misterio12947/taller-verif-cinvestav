// =============================================================================
// generator.sv — Produce transacciones aleatorias y las mete en un mailbox
// para que el driver las consuma.
//
// Responsabilidad única: crear transactions. No sabe nada del DUT.
//
// En UVM esto se descompone en `uvm_sequence` (qué generar) + `uvm_sequencer`
// (cómo entregarlas al driver). Aquí lo tenemos junto por simplicidad.
// =============================================================================

class alu_generator;

    // Mailbox de salida hacia el driver (canal FIFO thread-safe)
    mailbox #(alu_transaction) gen2drv;

    // Contador de transacciones a generar
    int num_trans;

    // Copia enviada al scoreboard (para que compare vs. lo observado)
    mailbox #(alu_transaction) gen2sb;

    function new(mailbox #(alu_transaction) gen2drv,
                 mailbox #(alu_transaction) gen2sb,
                 int num_trans = 200);
        this.gen2drv   = gen2drv;
        this.gen2sb    = gen2sb;
        this.num_trans = num_trans;
    endfunction

    // -------------------------------------------------------------------------
    // Método principal: correr el generator.
    // Crea N transactions, las aleatoriza, las manda al driver Y al scoreboard.
    // -------------------------------------------------------------------------
    task run();
        alu_transaction t;
        for (int i = 0; i < num_trans; i++) begin
            t = new();
            assert (t.randomize())
                else $fatal(1, "[GEN] randomize() falló");
            gen2drv.put(t);            // al driver, para aplicar al DUT
            gen2sb.put(t.clone());     // al scoreboard, para referencia
        end
        $display("[GEN] Terminó de generar %0d transacciones.", num_trans);
    endtask

endclass
