// =============================================================================
// scoreboard.sv — Compara lo observado por el monitor contra lo esperado
// según un reference model independiente.
//
// El reference model está incluido aquí como una función `predict()` — en
// proyectos reales podría ser un modelo en C++ vía DPI, o una clase separada.
//
// Emite PASS/FAIL por transacción y acumula errores para el reporte final.
//
// En UVM esto sería un `uvm_scoreboard` con `uvm_analysis_imp` conectados
// al monitor y al generator (para tener referencia).
// =============================================================================

class alu_scoreboard;

    mailbox #(alu_transaction) gen2sb;   // referencia (lo esperado)
    mailbox #(alu_transaction) mon2sb;   // observado (lo real)

    int num_pass;
    int num_fail;

    function new(mailbox #(alu_transaction) gen2sb,
                 mailbox #(alu_transaction) mon2sb);
        this.gen2sb   = gen2sb;
        this.mon2sb   = mon2sb;
        this.num_pass = 0;
        this.num_fail = 0;
    endfunction

    // -------------------------------------------------------------------------
    // Reference model: dada una transacción con a/b/op, calcula los outputs
    // esperados de la ALU. Es la spec traducida a código.
    // -------------------------------------------------------------------------
    function void predict(alu_transaction t);
        logic [4:0] add_ext;
        add_ext = {1'b0, t.a} + {1'b0, t.b};

        case (t.op)
            2'b00: begin t.result = add_ext[3:0]; t.carry = add_ext[4]; end
            2'b01: begin t.result = t.a - t.b;    t.carry = 1'b0; end
            2'b10: begin t.result = t.a & t.b;    t.carry = 1'b0; end
            2'b11: begin t.result = t.a | t.b;    t.carry = 1'b0; end
        endcase
        t.zero = (t.result == 4'b0);
    endfunction

    // -------------------------------------------------------------------------
    // Comparar una transacción esperada vs. una observada.
    // -------------------------------------------------------------------------
    function bit compare(alu_transaction exp, alu_transaction obs);
        bit ok = 1;
        if (exp.result !== obs.result) ok = 0;
        if (exp.zero   !== obs.zero  ) ok = 0;
        // carry solo importa en ADD
        if (exp.op == 2'b00 && exp.carry !== obs.carry) ok = 0;
        return ok;
    endfunction

    // -------------------------------------------------------------------------
    // Task principal: en cada ciclo, esperar una transacción del generator
    // y una del monitor, y compararlas.
    // -------------------------------------------------------------------------
    task run();
        alu_transaction exp, obs;
        forever begin
            gen2sb.get(exp);         // lo que se pidió
            mon2sb.get(obs);         // lo que salió
            predict(exp);            // llenar campos esperados

            if (compare(exp, obs)) begin
                num_pass++;
            end else begin
                num_fail++;
                $display("[SB][FAIL] esperado: %s", exp.convert2string());
                $display("          observado: %s", obs.convert2string());
            end
        end
    endtask

    // Reporte final
    function void report();
        $display("");
        $display("=====================================================");
        $display("[SB] Transacciones comparadas: %0d", num_pass + num_fail);
        $display("[SB] PASS: %0d", num_pass);
        $display("[SB] FAIL: %0d", num_fail);
        if (num_fail == 0)
            $display("[SB] RESULTADO: PASS");
        else
            $display("[SB] RESULTADO: FAIL");
        $display("=====================================================");
    endfunction

endclass
