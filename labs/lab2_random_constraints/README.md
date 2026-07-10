# Laboratorio 2 — Constrained Random

**Duración estimada:** 20 minutos
**Ubicación en el curso:** Módulo 3, tras introducir el primer pilar (Constrained Random)

## Objetivo

Transformar el testbench directed del Lab 1 en un testbench aleatorio controlado. El estudiante escribirá su primera `class` en SystemVerilog, aprenderá a usar `rand` fields, `constraint` blocks y `randomize()`. Al terminar, generará más de 200 escenarios distintos con menos código del que ya tenía.

Este lab es el primer contacto con OO en verificación. En el Lab 4 esta misma `class` evolucionará hacia una `uvm_sequence_item`.

## Archivos

| Archivo | Rol |
|---------|-----|
| `contador.sv` | DUT (idéntico al Lab 1) |
| `tb_starter.sv` | Testbench inicial con TODOs |
| `tb_solution.sv` | Solución completa con 3 fases de estímulos |
| `run.sh` | Script VCS con soporte de seed reproducible |

## Cómo correr

```bash
cd labs/lab2_random_constraints

./run.sh starter          # Correr tu implementación
./run.sh                  # Correr la solución (seed=1)
./run.sh seed 42          # Correr solución con seed distinta
./run.sh verdi            # Abrir Verdi con las ondas
./run.sh clean
```

Cambiar la seed produce un patrón de estímulos completamente distinto. Prueben con 3 seeds diferentes y comparen — ese es el punto emocional del lab.

## Instrucciones paso a paso

**TODO #1 — Class `cnt_txn`**

Modelar una transacción del contador. Tres campos aleatorizables:
- `enable` (1 bit)
- `up_down` (1 bit)
- `repeticiones` (int, entre 1 y 5)

Estructura:

```systemverilog
class cnt_txn;
    rand bit enable;
    rand bit up_down;
    rand int repeticiones;

    constraint c_reps { repeticiones inside {[1:5]}; }
endclass
```

**TODO #2 — Ciclo de generación**

Dentro del `initial begin`, después del reset:

1. Instanciar un objeto de tipo `cnt_txn` con `new()`
2. Ciclo de 200 iteraciones que:
   - Llame `txn.randomize()` (devuelve 1 si tuvo éxito)
   - Aserte que el retorno fue exitoso
   - Llame `apply_txn(txn.enable, txn.up_down, txn.repeticiones)`

## Conceptos clave introducidos

**`rand` vs `randc`**
- `rand` — cada llamada a `randomize()` sortea nuevo valor de forma independiente
- `randc` — recorre todos los valores posibles antes de repetir (cyclic)

**`constraint` blocks**
- Son declarativos, no imperativos. El solver los resuelve simultáneamente.
- `inside {[1:5]}` — rango inclusivo
- `dist { A := 80, B := 20 }` — distribución ponderada (A cuatro veces más probable que B)

**`randomize() with { ... }`**
- Constraints extras aplicadas solo en esa llamada
- Útil para "empujar" la aleatoriedad a un subespacio del que quieres cobertura extra
- Ejemplo en la solución: fases 2 y 3 fuerzan overflow y underflow

**Semilla reproducible**
- `+ntb_random_seed=<N>` en la línea de comandos de `simv`
- Sin seed explícita, VCS usa una seed distinta cada corrida — bug encontrado hoy podría no reproducirse mañana
- Regla profesional: cada regression corre con seeds documentadas

## Errores comunes

1. **Olvidar `new()`.** Una `class` no existe hasta que la instancian. `txn.randomize()` sobre `null` da segfault en tiempo de simulación.

2. **Ignorar el retorno de `randomize()`.** Si las constraints son inconsistentes (ej. `x inside {[1:5]}; x > 10;`), `randomize()` regresa 0 pero el simulador no aborta automáticamente. Siempre `assert(ok)`.

3. **Constraint que hace el espacio vacío.** Ejemplo típico: `x inside {[1:5]}; x inside {[10:20]};`. El solver no puede satisfacer ambas. Debug: comentar constraints una por una.

4. **Confundir `==` con `inside`.** `x == {1,2,3}` no compila. `x inside {1,2,3}` sí.

5. **`rand int` sin constraint.** Sin `constraint`, se sortea en todo el rango de `int` — incluidos números negativos gigantes. Siempre acotar con `inside {[a:b]}`.

## Preguntas de reflexión

1. Con seed=1 el TB genera un patrón A. Con seed=42 genera un patrón B. ¿En cuál de los dos se encuentra más fácil un bug hipotético? La respuesta correcta es: no sabemos. Por eso corremos regressions con **cientos de seeds**.

2. Escribieron aproximadamente 15 líneas de código y probaron ~200 escenarios distintos. ¿Cuántas líneas tendría el equivalente directed?

3. Si el DUT tiene un bug que solo aparece con la secuencia exacta `up_down=1, 1, 0, 1, 1, 0, 0, 1`, ¿cuál es la probabilidad de que constrained random lo encuentre en 200 iteraciones? (Pista: es distinta de cero — ese es el punto).

4. Sin coverage, ¿cómo saben que sus 200 iteraciones cubrieron algo interesante y no dieron 200 vueltas al mismo estado? Esta pregunta se resuelve en el **Lab 3**.

## Puente al Lab 3

En el Lab 3 vamos a agregar dos cosas encima de este TB:
- Un `covergroup` que mida objetivamente qué estados del contador visitaron
- Una `assert property` que vigile automáticamente una regla del protocolo

El estudiante saldrá del Lab 3 sintiendo que la verificación se **automatizó sola**.
