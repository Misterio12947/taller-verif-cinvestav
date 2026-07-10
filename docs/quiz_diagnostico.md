# Quiz diagnóstico — Módulo 0

**Duración:** 10 minutos
**Modalidad:** individual, respuestas escritas
**Calificación:** no cuenta, es solo para calibrar el arranque

## Instrucciones

Responder por escrito lo que sepas. Si no sabes algo, dejarlo en blanco (no adivinar). No hay penalización — este quiz sirve para saber por dónde empezar.

## Preguntas

**1. En Verilog, ¿qué diferencia hay entre `reg` y `wire`?**

<details><summary>Respuesta esperada</summary>
`wire` es una red combinacional (conexión física). `reg` es una variable que puede mantener valor entre ejecuciones de un always block. En SV se prefiere `logic` para ambos casos, dejando que el compilador infiera el tipo real.
</details>

**2. Dibuja mentalmente un testbench para un `mux 2-a-1`. ¿Qué señales manejas?**

<details><summary>Respuesta esperada</summary>
Al menos: `a`, `b`, `sel`, `y`. Ideal si mencionan clock y monitor de `y`.
</details>

**3. ¿Qué es una máquina de estados finita?**

<details><summary>Respuesta esperada</summary>
Un sistema con un número finito de estados que transita entre ellos según entradas y estado actual. En hardware síncrono, la transición ocurre en el flanco de reloj.
</details>

**4. Si un `if` dentro de `always @(*)` no tiene `else`, ¿qué pasa?**

<details><summary>Respuesta esperada</summary>
Se infiere un **latch** — la salida mantiene su valor anterior cuando la condición no se cumple. Casi siempre es un bug. En simulación puede pasar; en síntesis genera latches con problemas de timing.
</details>

**5. En tus palabras: ¿qué es un FPGA?**

<details><summary>Respuesta esperada</summary>
Un chip programable en campo. Contiene lookup tables, flip-flops y ruteo configurable. Sirve para prototipar diseños digitales sin fabricar un chip.
</details>

**6. ¿Alguna vez encontraste un bug en tu diseño después de sintetizar? ¿Cómo lo encontraste?**

<details><summary>Respuesta esperada</summary>
Pregunta abierta. No hay respuesta correcta — sirve para saber si han visto discrepancias RTL vs post-síntesis.
</details>

**7. ¿Qué hace la palabra clave `initial`?**

<details><summary>Respuesta esperada</summary>
Ejecuta el bloque una sola vez al inicio de la simulación. No se sintetiza — solo existe en TB.
</details>

**8. Si tu diseño tiene 32 entradas binarias, ¿cuántas combinaciones posibles existen?**

<details><summary>Respuesta esperada</summary>
2^32 = **4,294,967,296** — más de 4 mil millones. A 1 μs por simulación son ~71 minutos exhaustivo. Con 64 entradas serían 584,000 años. **Este es el gancho emocional del curso.**
</details>

## Análisis para el instructor

**Si la mayoría responde 1-5 bien pero falla 7-8:**
El aula tiene bases sólidas de RTL/FPGA pero cero contexto de escala/verificación. Perfecto para el curso — arranca a ritmo normal.

**Si fallan 1-5:**
El aula está muy verde en Verilog. Considerar aumentar el ritmo de M2 (repaso) y bajar la velocidad de M4.

**Si responden 8 con "muchas" sin dar número:**
Perfecto — significa que intuyen la escala pero no han hecho el cálculo. Enfatizar el número exacto y su implicación (imposible probar todo).

**Discusión sugerida en aula (2-3 min):**
- Preguntar en voz alta: "¿alguien puede compartir su respuesta a la pregunta 8?"
- Cuando alguien diga "4 mil millones", pausar
- Preguntar: "y si tuvieran que probar cada una a 1 μs, ¿cuánto tardan?"
- La respuesta ("~71 minutos, más de una hora") + realización de que 64 entradas son 584 mil años = motivación emocional para todo el curso.
