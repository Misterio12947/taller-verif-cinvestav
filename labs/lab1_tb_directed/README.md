# Laboratorio 1 — Testbench Directed

**Duración estimada:** 20 minutos
**Ubicación en el curso:** Módulo 2 (Anatomía de un testbench)

## Objetivo

Construir a mano un testbench directed clásico para un contador 4-bit up/down. Al terminar, el estudiante habrá identificado y escrito **las seis piezas universales** de cualquier testbench: reloj, reset, estímulo, DUT, checker y reporte.

Este lab es el punto de partida del curso. El código que produzcamos aquí se irá *transformando* en los siguientes labs: agregando randomización (Lab 2), coverage y assertions (Lab 3), y finalmente descomponiéndose en clases OO al estilo UVM (Lab 4).

## Archivos

| Archivo | Rol |
|---------|-----|
| `contador.sv` | DUT: contador 4-bit up/down con reset asíncrono |
| `tb_starter.sv` | Testbench inicial con TODOs para completar |
| `tb_solution.sv` | Solución completa (no abrir hasta terminar el starter) |
| `run.sh` | Script de compilación y ejecución con VCS |

## Cómo correr

```bash
cd labs/lab1_tb_directed

# Compilar y correr el starter (mostrará resultados incompletos)
./run.sh starter

# Compilar y correr la solución
./run.sh

# Abrir waveform en Verdi
./run.sh verdi

# Limpiar artefactos
./run.sh clean
```

## Instrucciones paso a paso

Abrir `tb_starter.sv` y completar tres TODOs:

**TODO #1 — Generador de reloj**
Un reloj de 100 MHz (periodo 10 ns). Inicializar `clk` en cero, luego togglearlo cada 5 ns con `always #5 clk = ~clk;`.

**TODO #2 — Secuencia de estímulos**
Aplicar el reset asíncrono, esperar 2 ciclos, liberar reset. Después cinco cuentas hacia arriba con `enable=1` y `up_down=1`, luego tres hacia abajo con `up_down=0`. El valor final esperado del contador es 2 (0 + 5 − 3).

**TODO #3 — Monitor rudimentario (opcional)**
Agregar un `always @(posedge clk) $display(...)` que imprima el valor de `count` en cada flanco. Este es el germen del *monitor* que veremos formalizado en el Módulo 4.

## Código esperado (referencia)

Una vez completado, el `tb_starter.sv` debe producir salida similar a la de `tb_solution.sv`:

```
[TB] Reset liberado en t=25
[TB][OK]    t=45  count=1
[TB][OK]    t=55  count=2
...
[TB] Valor final del contador = 2 (esperado: 2)
[TB] RESULTADO: PASS
```

## Errores comunes

Estos son los que aparecen cada semestre en el aula. Buscarlos primero:

1. **Olvidar inicializar `clk`.** Si `clk` queda en `x`, el `~clk` nunca togglea. Siempre `initial clk = 1'b0;` antes del `always #5`.

2. **Aplicar estímulos en `@(posedge clk)` en lugar de `@(negedge clk)`.** Cambiar entradas justo en el flanco activo genera race conditions. Regla: aplicar en `negedge`, muestrear en `posedge`.

3. **Reset síncrono cuando el DUT usa reset asíncrono.** Este DUT tiene `always_ff @(posedge clk or negedge rst_n)`. El reset baja en cualquier momento — no requiere reloj activo.

4. **Timescale mal declarado.** Sin `` `timescale 1ns/1ps ``, los `#5` se interpretan en la unidad por defecto del simulador y los tiempos salen mal.

5. **Comparar con `==` en lugar de `!==`.** El operador `==` regresa `x` si un operando tiene `x` o `z`, lo cual arruina el checker. Usar siempre `!==` en testbenches.

6. **No terminar con `$finish`.** Sin `$finish`, la simulación corre para siempre. El watchdog del `tb_solution.sv` lo cubre — asegúrense de tener uno.

## Preguntas de reflexión

Discutir en el aula tras completar el lab:

1. En este TB, el "checker" es una variable `expected` que actualizamos a mano. ¿Qué pasa si el DUT tiene 32 salidas y una máquina de estados de 16 estados? ¿Cuántas líneas tendría el checker?

2. Probamos exactamente **9 escenarios** (5 up + 3 down + 1 hold). El espacio real de estímulos es `(2^3) × ∞` (tres entradas por infinitos ciclos). ¿Qué porcentaje de ese espacio probamos?

3. Si el DUT tuviera un bug que solo aparece cuando `enable` cambia de 1 a 0 exactamente en el mismo ciclo que ocurre overflow, ¿este testbench lo encontraría?

4. ¿Qué pasa si el bug ocurre solo cuando `count == 4'b1111` y `up_down` cambia entre `negedge` y `posedge`? ¿Cómo lo probarías con directed testing?

Las respuestas honestas a estas preguntas motivan **exactamente** las técnicas del Módulo 3: constrained random, coverage, assertions y reference model.

## Puente al siguiente lab

En el **Lab 2** vamos a tomar este mismo testbench y reemplazar la secuencia manual `repeat(5) step(...); repeat(3) step(...);` por un generador aleatorio con `randomize()` y constraints. La sensación debe ser: *"con 5 líneas de código estoy probando 10,000 escenarios que jamás habría escrito a mano."*
