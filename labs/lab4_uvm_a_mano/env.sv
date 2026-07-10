// =============================================================================
// env.sv — Environment: crea, conecta y arranca todas las clases del TB.
//
// Responsabilidad única: orquestar. No implementa lógica de verificación;
// solo cablea las piezas y las corre en paralelo con fork/join.
//
// En UVM esto es un `uvm_env` con las fases build_phase / connect_phase / run_phase.
// =============================================================================

class alu_env;

    // Componentes
    alu_generator   gen;
    alu_driver      drv;
    alu_monitor     mon;
    alu_scoreboard  sb;

    // Canales de comunicación
    mailbox #(alu_transaction) gen2drv;
    mailbox #(alu_transaction) gen2sb;
    mailbox #(alu_transaction) mon2sb;

    // Handle al interface virtual
    virtual alu_if vif;

    // Configuración
    int num_trans;

    function new(virtual alu_if vif, int num_trans = 200);
        this.vif       = vif;
        this.num_trans = num_trans;
    endfunction

    // -------------------------------------------------------------------------
    // build: crear mailboxes y componentes
    // -------------------------------------------------------------------------
    function void build();
        gen2drv = new();
        gen2sb  = new();
        mon2sb  = new();

        gen = new(gen2drv, gen2sb, num_trans);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2sb);
        sb  = new(gen2sb, mon2sb);
    endfunction

    // -------------------------------------------------------------------------
    // run: correr todos los componentes en paralelo hasta que el generator
    // termine sus N transacciones.
    // -------------------------------------------------------------------------
    task run();
        fork
            gen.run();      // producirá N transacciones y termina
            drv.run();      // forever
            mon.run();      // forever
            sb.run();       // forever
        join_none

        // Esperar a que el generator termine y damos margen para que las
        // últimas transacciones lleguen al scoreboard.
        wait (gen2drv.num() == 0 && gen2sb.num() == 0 && mon2sb.num() == 0);
        repeat (5) @(vif.cb_tb);

        sb.report();
    endtask

endclass
