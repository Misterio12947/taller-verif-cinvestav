# Laboratorio 3 — Functional Coverage + Assertions

**Duración estimada:** 25 minutos
**Ubicación en el curso:** Módulo 3, tras introducir los pilares 2 (Coverage) y 3 (Assertions)

## Objetivo

Sobre el testbench aleatorio del Lab 2, agregar dos capas que automatizan la verificación:

1. **Functional coverage** — una métrica objetiva de "qué escenarios sí visitamos".
2. **SystemVerilog Assertions (SVA)** — reglas temporales que el simulador vigila solo.

Al terminar, el estudiante entenderá por qué la industria mide "coverage" en vez de "líneas probadas" y por qué las assertions cambian el paradigma de debug: pasas de "leer waveforms buscando el error" a "el simulador te avisa cuándo ocurrió".

## Archivos

| Archivo | Rol |
|---------|-----|
| `contador.sv` | DUT (idéntico a Labs 1 y 2) |
| `checker_sva.sv` | Módulo con 3 assertions y 3 cover properties; se acopla al DUT vía `bind` |
| `tb_starter.sv` | Testbench inicial con TODOs para covergroup y bind |
| `tb_solution.sv` | Solución completa con reporte de coverage |
| `run.sh` | Script VCS con modos `cov` y `urg` para reporte HTML |

## Cómo correr

```bash
cd labs/lab3_coverage_assertions

./run.sh starter      # Corre tu implementación
./run.sh              # Corre la solución
./run.sh cov          # Corre + genera reporte URG de coverage
./run.sh urg          # Abre el reporte HTML en el navegador
./run.sh verdi        # Abre Verdi con las ondas
./run.sh clean
```

El modo `cov` es el importante: compila con `-cm line+cond+fsm+tgl+branch+assert`, corre la simulación, ejecuta `urg` (Unified Report Generator de Synopsys) y produce `cov_report/dashboard.html` — el mismo reporte que se ve en proyectos reales.

## Instrucciones paso a paso

**TODO #1 — Covergroup**

Dentro de `tb_contador`, definir un `covergroup` con:

```systemverilog
covergroup cg_contador @(posedge clk);
    cp_count: coverpoint count {
        bins low     = {[0:3]};
        bins mid_low = {[4:7]};
        bins mid_hi  = {[8:11]};
        bins high    = {[12:15]};
    }
    cp_dir: coverpoint up_down iff (enable) {
        bins up   = {1};
        bins down = {0};
    }
    cross_count_dir: cross cp_count, cp_dir;
endgroup

cg_contador cg_h;
```

Luego, dentro del `initial`, agregar `cg_h = new();` antes del ciclo de generación.

Al final, imprimir `cg_h.get_inst_coverage()` en el reporte.

**TODO #2 — Bind del checker SVA**

Fuera del `module tb_contador`, agregar:

```systemverilog
bind contador checker_sva u_sva (.*);
```

Esto acopla las 3 propiedades y 3 cover properties del `checker_sva.sv` al DUT, sin modificar el RTL. Es el patrón profesional para verificación no invasiva.

## Conceptos clave introducidos

### Code coverage vs Functional coverage

| Tipo | Qué mide | Cómo | Automático |
|------|----------|------|------------|
| **Line coverage** | Qué líneas del RTL se ejecutaron | Auto por VCS con `-cm line` | Sí |
| **Branch coverage** | Qué ramas de `if`/`case` se tomaron | Auto con `-cm branch` | Sí |
| **Toggle coverage** | Qué señales cambiaron 0→1 y 1→0 | Auto con `-cm tgl` | Sí |
| **FSM coverage** | Qué transiciones de estado ocurrieron | Auto con `-cm fsm` | Sí |
| **Condition coverage** | Qué combinaciones de operandos booleanos | Auto con `-cm cond` | Sí |
| **Functional coverage** | Qué **escenarios de la spec** se probaron | Manual con `covergroup` | No |

**Line coverage 100% no implica funcional 100%.** Ejemplo: puedes ejecutar cada línea del ALU **sin nunca haber sumado dos números negativos**. Line coverage dice "listo", pero la spec no está probada.

### Functional coverage con `covergroup`

- `coverpoint x` — mide qué valores de `x` ocurrieron
- `bins` — agrupamos valores en categorías conceptuales (`low`, `mid`, `high`)
- `iff (cond)` — solo cuenta cuando la condición se cumple (aquí: dir solo importa si enable=1)
- `cross A, B` — combinaciones de A y B; el más potente de todos

### SVA — SystemVerilog Assertions

Assertions **temporales** que el simulador verifica en cada ciclo. Sintaxis básica:

```systemverilog
property nombre;
    @(posedge clk) antecedente |-> consecuente;
endproperty
assert property (nombre) else $error("mensaje");
```

**Operadores temporales:**
- `|->` — "en el mismo ciclo": si antecedente entonces consecuente **ahora**
- `|=>` — "en el siguiente ciclo": si antecedente entonces consecuente **al próximo posedge**
- `##N` — "después de N ciclos"
- `##[a:b]` — "en algún ciclo entre a y b"
- `$stable(x)` — verdadero si `x` no cambió desde el ciclo anterior
- `$past(x)` — valor de `x` en el ciclo pasado
- `$rose(x)` / `$fell(x)` — flanco de subida/bajada

**`cover property`** — le dice al simulador "quiero ver que este escenario ocurra". Aparece en el reporte como "covered" o "not covered". Útil para saber si las secuencias interesantes están ocurriendo.

### `bind` — el pegamento no invasivo

```systemverilog
bind contador checker_sva u_sva (.*);
```

Instala una instancia del `checker_sva` **dentro** de cada instancia del módulo `contador` — sin editar el RTL. En proyectos reales, esto permite:
- Agregar checkers sin tocar código de diseño
- Reusar checkers entre múltiples DUTs
- Deshabilitar checkers en producción sin cambiar el RTL

## Errores comunes

1. **`covergroup` sin `new()`.** El covergroup se declara pero no se activa hasta que instancias con `new()`. Sin `new()`, `get_coverage()` regresa 0.

2. **Sample event mal escogido.** Si samplas en `@(posedge clk)` cuando `count` cambia solo en algunos ciclos, tu coverage es correcto pero **lento**. En DUTs con transacciones, sampleas en el evento de transacción, no en cada clk.

3. **Bins que no cubren el dominio completo.** Si `count` es 4-bit (0–15) y defines `bins low={[0:3]}, high={[12:15]}`, los valores 4–11 caen en un **implicit bin** o se ignoran. Siempre revisar coverage total.

4. **SVA sin `disable iff`.** En el `checker_sva.sv`, la Property 2 tiene `disable iff (!rst_n)`. Sin eso, durante reset la propiedad fallaría cada ciclo. Regla: toda SVA que asume el DUT operando debe deshabilitarse durante reset.

5. **Compilar sin `-assert svaext`.** VCS necesita el flag `-assert svaext` para procesar assertions concurrentes (SVA). Sin él, se ignoran silenciosamente. El `run.sh` de este lab ya lo trae.

6. **`bind` en el archivo equivocado.** El `bind` debe compilarse **junto** con el DUT y el checker. Si va en un archivo separado que no se pasa a VCS, no se aplica y las assertions nunca se ejecutan.

## Preguntas de reflexión

1. Corran el TB con `./run.sh cov` y abran el reporte HTML. ¿Qué porcentaje de `cross_count_dir` alcanzaron? Si es <100%, ¿qué combinaciones específicas faltaron?

2. Modifiquen la constraint de `cnt_txn` para forzar `enable=0` el 90% del tiempo (`dist { 1:=10, 0:=90 }`). Corran de nuevo. ¿Bajó el coverage? ¿Por qué?

3. La assertion P3 (`p_increment_when_up`) usa `|=>`. Si la cambian a `|->`, ¿qué pasa y por qué?

4. ¿Podrían escribir la assertion "el contador nunca visita el valor 7 dos veces consecutivas"? Es una assertion válida pero **restringe** el comportamiento — piénsenlo bien antes de escribirla en un TB real.

5. Coverage-driven verification: si su coverage está en 78% después de 300 transacciones, ¿qué hacen? ¿Corren más iteraciones? ¿Cambian las constraints? ¿Escriben tests directed adicionales?

## Puente al Módulo 4

Ya tienen todos los componentes conceptuales:
- Transacciones (`cnt_txn`)
- Estímulos aleatorios controlados
- Coverage funcional
- Assertions temporales
- Checker con reference model

Todo esto lo tienen **mezclado** dentro de un solo módulo. En el **Módulo 4** vamos a **separar** cada pieza en su propia `class`:
- `class transaction` — ya lo tienen
- `class generator` — el `randomize()` + mailbox
- `class driver` — el que aplica al DUT
- `class monitor` — el que observa el DUT
- `class scoreboard` — el que compara vs referencia
- `class environment` — el que orquesta todo

Esa reorganización es **exactamente** lo que UVM hace por ustedes. Al terminar Lab 4 dirán: *"UVM es esto pero con nombres formales."*
