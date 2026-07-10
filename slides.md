---
theme: seriph
title: Curso Propedéutico de Functional Verification
info: |
  ## Curso Propedéutico de Functional Verification
  CINVESTAV Zacatenco — Departamento de Ingeniería Eléctrica
  Instructor: Ing. Cesar Otamendi
  Duración: 6 horas
class: text-center
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
mdc: true
---

# Functional Verification

## Curso Propedéutico

<div class="mt-8 text-sm opacity-80">
  <p>CINVESTAV Zacatenco · Departamento de Ingeniería Eléctrica</p>
  <p>Instructor: <strong>Ing. Cesar Otamendi</strong></p>
  <p>Duración: 6 horas · Preparatorio al Bootcamp Synopsys</p>
</div>

<div class="abs-br m-6 flex gap-2 text-xs opacity-60">
  <span>Presiona <kbd>Space</kbd> para avanzar</span>
</div>

<!--
Presentación del curso (2 minutos):

- Bienvenida cálida. Este NO es un curso de UVM todavía.
- Objetivo: llegar al Bootcamp con la MENTALIDAD correcta.
- Regla del aula: si algo no se entiende, se para. Es un curso propedéutico,
  no una carrera contra el reloj.
- Verificación es 70% del esfuerzo de un chip moderno. Vale la pena entenderlo bien.

Duración total: 6 horas con un break intermedio de 15 min.
-->

---
layout: two-cols
---

# ¿Qué van a llevarse hoy?

Al terminar estas 6 horas ustedes van a poder responder — sin dudar — preguntas como:

- ¿Por qué existe Functional Verification?
- ¿Qué problema resuelve UVM?
- ¿Qué hacen VCS, Verdi, Design Compiler?
- ¿Qué es un `driver`, un `monitor`, un `scoreboard`?
- ¿Qué diferencia un `code coverage` de un `functional coverage`?
- ¿Cómo viajan los datos dentro de un testbench moderno?

::right::

<div class="pl-8">

## Lo que NO van a aprender hoy

- Sintaxis completa de UVM
- Macros avanzadas, factory override, RAL
- Sequences complejas
- Uso profundo de las herramientas Synopsys

<div class="pro-tip mt-4">
Eso es el Bootcamp de la próxima semana. Hoy construimos la <b>intuición</b>. Sin intuición sólida, el Bootcamp se siente como aprender chino en dos días.
</div>

</div>

<!--
Recalcar: hoy es MAPA, no ejecución. La ejecución viene la próxima semana.
El error clásico es aventar a los estudiantes a UVM sin este puente conceptual.
Nosotros vamos a construir el puente.
-->

---
layout: default
---

# Agenda de las 6 horas

<div class="text-sm">

| Módulo | Tema | Duración |
|--------|------|----------|
| **M0** | Kick-off y quiz diagnóstico | 15 min |
| **M1** | ¿Por qué existe Functional Verification? | 45 min |
| **M2** | Anatomía de un testbench | 60 min |
| **M3** | Los 4 pilares de la verificación moderna | 75 min |
| ☕ | **Break** | 15 min |
| **M4** | Construyendo UVM a mano — sin UVM | 90 min |
| **M5** | Ahora sí: ¿qué es UVM? | 60 min |
| **M6** | El flujo ASIC y el ecosistema Synopsys | 30 min |
| **M7** | Cierre, quiz final, puente al Bootcamp | 15 min |

</div>

<div class="mt-4 pro-tip">
La estrella del curso es <b>M4</b>. Ahí van a construir con sus manos las piezas que UVM organiza. Cuando lleguen a <b>M5</b> van a decir <i>"¡ah, UVM solo empaqueta lo que ya hice!"</i>
</div>

<!--
Timing crítico:
- Si M1 se alarga (siempre pasa por la discusión de "cuánto cuesta un bug"),
  recortar de M6, NO de M4.
- El break es sagrado. 15 min completos. Los estudiantes procesan mejor.
-->

---
layout: section
---

<div class="module-badge">MÓDULO 0 · 15 min</div>

# Kick-off y Diagnóstico

## Antes de arrancar, veamos qué saben ya

<!--
Objetivo del módulo 0: crear ambiente, poner el diagnóstico, y establecer
la analogía-ancla del curso (DUT = fábrica, verificación = calidad).
-->

---
layout: default
---

# Quiz diagnóstico rápido (10 min)

Respondan por escrito o mentalmente. No hay calificación — es solo para calibrar el arranque.

<div class="text-sm mt-4">

1. En Verilog, ¿qué diferencia hay entre `reg` y `wire`?
2. Dibuja mentalmente un testbench para un `mux 2-a-1`. ¿Qué señales manejas?
3. ¿Qué es una máquina de estados finita?
4. Si un `if` dentro de `always @(*)` no tiene `else`, ¿qué pasa?
5. En tus palabras: ¿qué es un FPGA?
6. ¿Alguna vez encontraste un bug en tu diseño **después** de sintetizar? ¿Cómo lo encontraste?
7. ¿Qué hace la palabra clave `initial`?
8. Si tu diseño tiene 32 entradas binarias, ¿cuántas combinaciones posibles existen?

</div>

<QuestionBox>
Pregunta abierta al aula: <b>¿Cuántas combinaciones probaron en su último testbench?</b>
</QuestionBox>

<!--
El punto de la pregunta 8 es que digan "4 mil millones" y del silencio
saquen ellos mismos la conclusión de que probar todo es imposible.
Esa es la semilla emocional del curso completo.

Timing: 8-10 min para responder, 2 min para comentar en voz alta.
-->

---
layout: default
---

# La analogía-ancla del curso

<div class="two-col mt-8">

<div>

## El DUT es una fábrica 🏭

- Recibe **materia prima** (inputs)
- La transforma con **procesos internos** (lógica)
- Entrega **producto terminado** (outputs)

Todo lo demás — el testbench, el checker, el coverage — es la **infraestructura de calidad** que rodea a la fábrica.

</div>

<div>

## ¿Y la verificación?

- **QA** que revisa cada lote
- **Auditores** que comparan contra especificación
- **Sensores** que vigilan que nada se salga de rango
- **Reportes** que documentan qué se probó y qué no

</div>

</div>

<Analogy>
Sin QA, una fábrica puede producir 10 millones de piezas defectuosas antes de que alguien se dé cuenta. En silicon, ese error cuesta <b>~10 millones de dólares</b> por respin.
</Analogy>

<!--
Esta analogía se va a repetir MUCHAS veces en el curso.
Cada vez que introducimos una pieza nueva (driver, monitor, scoreboard),
la ubicamos dentro de esta fábrica.

- Driver → operario que alimenta la línea
- Monitor → cámara de seguridad
- Scoreboard → auditor externo
- Coverage → hoja de verificación de QA
- Assertion → alarma anti-incendios
-->

---
layout: section
---

<div class="module-badge">MÓDULO 1 · 45 min</div>

# ¿Por qué existe Functional Verification?

## Los números que nadie enseña en la carrera

<!--
Este módulo es EMOCIONAL antes que técnico. El objetivo es que el estudiante
sienta el peso económico y humano de un bug en silicio, y entienda por qué
la industria invierte tanto en verificación.

Si al final de M1 dicen "wow, esto es serio", ganamos.
-->

---
layout: default
---

# El costo real de un bug en silicio

<div class="two-col mt-6">

<div>

## Bug en FPGA

- Cambias el RTL
- Recompilas: 10 minutos
- Reprogramas la board: 30 segundos
- **Costo: café + tiempo**

## Bug en ASIC ya fabricado

- Necesitas **rediseñar el mask set**
- Volver a fabricar: 3–6 meses
- **Costo: $5M – $50M USD**
- Pierdes ventana de mercado

</div>

<div>

```mermaid {scale: 0.8}
flowchart TD
  A[Bug encontrado<br/>en RTL] --> B{¿Cuándo?}
  B -->|Pre-síntesis| C["💰 1x costo<br/>(minutos)"]
  B -->|Post-síntesis| D["💰 10x costo<br/>(horas)"]
  B -->|Post-tape-out| E["💰💰💰 10,000x<br/>(meses + millones)"]
  B -->|En campo| F["💥 catástrofe<br/>reputacional"]

  style C fill:#c8e6c9
  style D fill:#fff9c4
  style E fill:#ffcdd2
  style F fill:#b71c1c,color:#fff
```

</div>

</div>

<Analogy>
Un bug encontrado antes del tape-out cuesta como <b>corregir un typo antes de imprimir un libro</b>. Después del tape-out, cuesta como <b>llamar a devolver 100,000 libros ya distribuidos en librerías</b>.
</Analogy>

<!--
Casos famosos que se pueden mencionar:
- Pentium FDIV bug (1994): $475M USD para Intel
- ARM Cortex-A9 errata: cambios de silicon en varias tandas
- NVIDIA Fermi respin: retraso de 6 meses

No profundizar, solo mencionar para dar peso. Los estudiantes googlean después.
-->

---
layout: default
---

# La "Verification Gap"

## El problema estructural que da origen a toda esta disciplina

<div class="mt-6">

```mermaid {scale: 0.75}
flowchart LR
  subgraph tiempo[" A lo largo de los años "]
    A["📈 Complejidad<br/>del chip<br/>crece 2× cada 18 meses<br/>(Moore)"] 
    B["📉 Capacidad de<br/>verificación manual<br/>crece linealmente"]
  end
  A -.-> C["🕳️ VERIFICATION<br/>GAP"]
  B -.-> C
  C --> D["Necesitamos<br/>metodologías<br/>automatizadas"]
  D --> E["Randomization<br/>Coverage<br/>Assertions<br/>UVM"]

  style A fill:#e3f2fd
  style B fill:#ffebee
  style C fill:#fff59d
  style E fill:#c8e6c9
```

</div>

<QuestionBox>
Si tu diseño tiene <b>32 entradas</b>, hay <b>4,294,967,296</b> combinaciones posibles. A 1 μs por simulación son <b>~71 minutos</b>. Con 64 entradas serían <b>584,542 años</b>. ¿Se puede probar todo?
</QuestionBox>

<!--
Momento clave. Aquí les cae el veinte de que "probar todo" es imposible
y por eso la disciplina inventó otras estrategias:
- Constrained random en vez de exhaustivo
- Coverage en vez de "todos los casos"
- Assertions en vez de checks manuales

Este slide justifica TODO lo que viene después. Volverán a él mentalmente.
-->

---
layout: default
---

# El 70% que nadie ve

## Distribución típica del esfuerzo en un proyecto ASIC moderno

<div class="mt-6">

```mermaid {scale: 0.85}
pie showData
  title Esfuerzo en un proyecto ASIC
  "Verificación funcional" : 55
  "Diseño RTL" : 20
  "Síntesis / PnR / Sign-off" : 15
  "Arquitectura y specs" : 10
```

</div>

<div class="text-sm mt-4">

**Fuente:** *Wilson Research Group / Siemens EDA Functional Verification Study*, edición 2022.

- El equipo de verificación es **más grande** que el equipo de diseño en la mayoría de compañías.
- Un verification engineer senior gana **igual o más** que un design engineer senior.
- La escasez de talento en verificación es **peor** que en RTL design.

</div>

<div class="pro-tip">
Cuando ustedes salgan al mercado laboral, van a competir por posiciones de <b>Design Verification Engineer</b> — y hay muchas más vacantes que de RTL.
</div>

<!--
Cierre motivacional del bloque económico. Ahora que entienden POR QUÉ,
podemos hablar de CÓMO.

Preguntar al aula: "¿Cuántos habían escuchado que verificación era la
mayor parte del esfuerzo?" Casi ninguno levanta la mano. Ese es el punto.
-->

---
layout: default
---

# FPGA testing vs. ASIC verification

## No son lo mismo. Y la diferencia importa mucho.

<div class="text-sm">

| Aspecto | FPGA testing (lo que ya hacen) | ASIC verification (lo que van a aprender) |
|---------|-------------------------------|-------------------------------------------|
| **Iteración** | Recompilar en minutos | Un solo tape-out; no hay segunda oportunidad barata |
| **Estímulos** | Directed, escritos a mano | Constrained random + coverage-driven |
| **Detección** | Ver LEDs, oscilo, ILA | Automatizada: scoreboard + assertions |
| **Escala del TB** | Un `initial begin` con 20 líneas | Ambiente OO con miles de líneas |
| **Metodología** | Ad-hoc, cada quien la suya | Estandarizada: UVM (IEEE 1800.2) |
| **Métrica de "listo"** | "Ya prende el LED" | Functional coverage al 100% |
| **Herramientas** | Vivado / Quartus + ModelSim | VCS + Verdi + VC Formal + SpyGlass |
| **Costo del bug** | Recompilar | Millones de dólares |

</div>

<Analogy>
FPGA testing es como <b>probar una receta en tu cocina</b>. ASIC verification es como <b>certificar que una fábrica va a producir 10 millones de latas de comida sin envenenar a nadie</b>.
</Analogy>

<!--
Este slide es clave para NO ofender el conocimiento previo del estudiante.
Su experiencia de FPGA es válida y útil — solo hay que expandirla.

Recalcar: no es que FPGA testing esté "mal". Es que ASIC verification
es una liga distinta con estándares mucho más altos.
-->

---
layout: default
---

# ¿Por qué un testbench manual ya no basta?

<div class="two-col mt-4">

<div>

## Testbench manual clásico

```verilog
initial begin
  a = 4'b0000; b = 4'b0001; #10;
  a = 4'b0001; b = 4'b0010; #10;
  a = 4'b0011; b = 4'b0100; #10;
  // ... 20 líneas más ...
  $finish;
end
```

**Problemas:**
- Solo prueba lo que el ingeniero **imaginó**
- Los bugs viven en los casos **no imaginados**
- No hay métrica de "qué tanto probé"
- No escala: ¿y si son 200 señales?

</div>

<div>

## Lo que necesitamos

- 🎲 Estímulos **aleatorios pero razonables** (constrained random)
- 📊 Métrica objetiva de **qué se probó** (coverage)
- 👮 Reglas que se vigilan **solas** (assertions)
- 🧾 Comparación automática contra un **modelo de referencia**
- 🔁 Poder correr **millones de escenarios sin escribir cada uno**

</div>

</div>

<Gotcha>
Un TB manual con 50 casos directed no encuentra el bug que ocurre cuando <code>a=0xFF</code> llega <b>exactamente</b> un ciclo antes de que <code>reset</code> se libere y <code>b</code> sea impar. Ese caso <b>nunca lo escribes a mano</b> — pero constrained random lo encuentra en la simulación #3,712.
</Gotcha>

<!--
Este slide siembra los 4 pilares que veremos en M3:
- Constrained random
- Coverage
- Assertions
- Reference model

Menciónenlos aquí de pasada. Volveremos a ellos en detalle.
-->

---
layout: default
---

# Ejemplo real: los bugs que sí importan

## No son los que crees

<div class="text-sm mt-4">

**Bugs fáciles** (los que encuentras con un TB manual):
- Reset no funciona
- Un `case` sin `default`
- Bit de signo mal manejado

**Bugs difíciles** (los que solo encuentras con verificación moderna):
- El pipeline se rompe cuando llegan **3 stall consecutivos** con la cache miss al vuelo
- El árbitro pierde una request si **dos masters** piden en **el mismo ciclo** que se libera un semáforo
- El FIFO reporta `full` un ciclo tarde solo cuando se llenó por un **write burst tras un flush parcial**
- La FSM se atora en un estado inalcanzable solo con esta **secuencia exacta** de 47 eventos

</div>

<QuestionBox>
¿Cuántas veces creen que un ingeniero humano escribiría a mano la secuencia exacta de <b>47 eventos</b> del último bug? Respuesta: <b>cero</b>. Por eso existe la verificación aleatoria dirigida.
</QuestionBox>

<!--
Este slide es el más "adulto" del módulo. Los estudiantes salen entendiendo
que los bugs REALES no se encuentran leyendo el RTL — se encuentran corriendo
millones de escenarios aleatorios con checkers automáticos.

Ese es el corazón de la verificación moderna.
-->

---
layout: default
---

# Resumen del Módulo 1

<div class="mt-6">

## Lo que quedó claro (esperamos)

1. Un bug post-tape-out cuesta **millones de dólares** — por eso invertimos tanto en verificación
2. Existe una **verification gap**: la complejidad crece exponencial, nuestra capacidad de escribir TBs no
3. Verificación es el **~70%** del esfuerzo de un proyecto ASIC moderno
4. FPGA testing y ASIC verification son **ligas distintas**
5. Los bugs interesantes **no** los encuentras con un `initial begin` — necesitas otra metodología

</div>

<div class="mt-6 pro-tip">
En el siguiente módulo vamos a abrir el capó de un testbench: qué piezas tiene, qué hace cada una, y por qué la anatomía es la misma sin importar la escala.
</div>

<QuestionBox>
Antes de avanzar: <b>¿Alguna pregunta o duda del módulo 1?</b>
</QuestionBox>

<!--
Pausa deliberada. Si nadie pregunta, TÚ preguntas:
"¿Alguien puede explicarme con sus palabras qué es la verification gap?"

Si la respuesta es sólida, seguimos. Si no, repites el slide del gap.
No pases a M2 con dudas abiertas de M1.

Timing acumulado: 60 min (15 M0 + 45 M1). Vamos en tiempo.
-->

---
layout: end
---

# Fin del Módulo 1

## Siguiente: Anatomía de un testbench

<div class="mt-8 text-sm opacity-70">
Vamos a las piezas concretas. Con código.
</div>

---
layout: section
---

<div class="module-badge">MÓDULO 2 · 60 min</div>

# Anatomía de un testbench

## Las seis piezas universales, sin importar la escala

<!--
M2 arranca aterrizado en código. Los estudiantes ya vieron POR QUÉ (M1);
ahora ven QUÉ hay dentro de un TB.

La tesis del módulo: sin importar si es un TB de 20 líneas o de 20,000,
las piezas son las mismas seis. Cambia la organización, no la esencia.
Esto siembra M4 (donde construyen las piezas OO) y M5 (donde UVM las organiza).
-->

---
layout: default
---

# El testbench que ya conocen

Este es el testbench que probablemente escribieron en sus cursos de FPGA:

```verilog
`timescale 1ns/1ps
module tb;
    logic clk = 0;
    logic rst_n, enable, up_down;
    logic [3:0] count;

    contador dut (.clk(clk), .rst_n(rst_n), .enable(enable),
                  .up_down(up_down), .count(count));

    always #5 clk = ~clk;

    initial begin
        rst_n = 0; enable = 0; up_down = 1;
        #20 rst_n = 1;
        #10 enable = 1;
        #100 $finish;
    end
endmodule
```

<QuestionBox>
Sin ver el código otra vez: ¿cuántas piezas conceptualmente distintas identifican en este testbench?
</QuestionBox>

<!--
Dar 90 segundos para que respondan. Respuestas típicas: "estímulos, reloj,
DUT". La mayoría se les escapa el checker (no hay) y el reporte (solo $finish).
Ese es exactamente el punto: los TB clásicos están incompletos.
-->

---
layout: default
---

# Las seis piezas universales

Todo testbench — desde el más simple hasta uno UVM de 50,000 líneas — se compone de estas seis piezas. Cambia el empaquetado, no la función.

```mermaid {scale: 0.75}
flowchart LR
  subgraph tb["TESTBENCH"]
    direction TB
    CLK["1. Reloj y reset<br/>(infraestructura)"]
    STIM["2. Estímulo<br/>(qué entra al DUT)"]
    MON["3. Observación<br/>(qué sale del DUT)"]
    CHK["4. Checker<br/>(¿está bien lo que salió?)"]
    REF["5. Referencia<br/>(¿qué debería salir?)"]
    RPT["6. Reporte<br/>(pass/fail + métricas)"]
  end

  STIM --> DUT["DUT<br/>(la fábrica)"]
  DUT --> MON
  MON --> CHK
  REF --> CHK
  CHK --> RPT

  style DUT fill:#576574,color:#fff
  style CLK fill:#e3f2fd
  style STIM fill:#bbdefb
  style MON fill:#c8e6c9
  style CHK fill:#ffcdd2
  style REF fill:#e1bee7
  style RPT fill:#fff9c4
```

<Analogy>
Piensen en una <b>prueba de manejo</b>. Reloj/reset = las reglas de tiempo y punto de partida. Estímulo = el examinador que da instrucciones. DUT = el candidato manejando. Observación = las cámaras del auto. Checker = el examinador comparando con reglamento. Referencia = el reglamento oficial. Reporte = el acta final: aprobado o reprobado.
</Analogy>

<!--
Este diagrama es LA imagen mental que queremos que se lleven del curso.
Volverán a él varias veces. En M4 lo van a implementar pieza por pieza
con classes. En M5 verán que UVM la reimplementa con nombres formales.
-->

---
layout: default
---

# Pieza 1 — Reloj y reset

## Infraestructura temporal del testbench

<div class="two-col mt-4">

<div>

**Reloj**
- Casi todo diseño digital moderno es síncrono
- El TB debe generar un reloj estable antes que cualquier otra cosa
- Regla: inicializar la variable, luego togglearla

```verilog
initial clk = 1'b0;
always #5 clk = ~clk;  // 100 MHz
```

**Reset**
- Puede ser síncrono o asíncrono (distinta lógica)
- Activo-bajo o activo-alto (convención local)
- Duración típica: al menos 2 ciclos completos

```verilog
initial begin
  rst_n = 1'b0;
  repeat (2) @(posedge clk);
  rst_n = 1'b1;
end
```

</div>

<div>

<div class="gotcha">
Olvidar el <code>initial clk = 1'b0;</code> es el error #1 en labs de primer año. Sin él, <code>~clk</code> siempre da <code>x</code> y el TB nunca arranca. En Verdi se ve como un waveform completamente rojo.
</div>

<div class="pro-tip mt-4">
En proyectos reales, el reloj se genera en un <b>clocking block</b> o dentro de una <b>interface</b> — lo veremos en M4. Por ahora, un <code>always #5</code> alcanza.
</div>

</div>

</div>

<!--
Este slide es el más "código básico". Si el aula lo domina, avanzar rápido.
Si hay dudas, aprovechar para preguntar quién ha visto un waveform con clk=x.
La mayoría dice que sí y se ríe. Es un rite of passage.
-->

---
layout: default
---

# Pieza 2 — Estímulo

## Qué hacemos entrar al DUT

Es la parte más "creativa" del TB — y la más peligrosa. En un TB directed, cada estímulo lo escribimos a mano:

```verilog
initial begin
  // Cinco cuentas hacia arriba
  repeat (5) begin
    @(negedge clk);
    enable  = 1'b1;
    up_down = 1'b1;
  end
  // Tres cuentas hacia abajo
  repeat (3) begin
    @(negedge clk);
    up_down = 1'b0;
  end
end
```

<div class="two-col mt-4">

<div>

**Ventajas de estímulos directed**
- Exactamente el escenario que quieres
- Fácil de debuggear
- Bueno para casos límite conocidos
- Bueno para regression suites de bugs pasados

</div>

<div>

**Desventajas**
- Solo pruebas lo que imaginas
- Escala mal (miles de líneas para un DUT mediano)
- Baja diversidad de estímulos
- No exploras el espacio combinatorio

</div>

</div>

<Analogy>
Directed es como <b>estudiar con guía</b>: sabes exactamente qué preguntas van a caer. Constrained random (M3) es como <b>estudiar el temario completo</b>: no controlas qué te preguntan pero cubres todo.
</Analogy>

---
layout: default
---

# Pieza 3 — Observación

## Cómo sabemos qué está haciendo el DUT

En un TB tradicional, "observar" es casi trivial: las salidas están conectadas al TB y podemos leerlas con `$display`. Pero conceptualmente ya es una **pieza distinta**:

```verilog
always @(posedge clk) begin
  $display("t=%0t count=%0d", $time, count);
end
```

<div class="mt-4">

Esta es la semilla del **Monitor** que veremos en M4. Su trabajo:

- Observar el DUT **sin modificarlo** (nunca escribe entradas)
- Convertir la actividad de bajo nivel (bits en el bus) a información de alto nivel (transacciones, eventos)
- Publicar lo que ve para que el checker lo consuma

</div>

<Analogy>
El monitor es una <b>cámara de seguridad</b>: mira todo, no toca nada, y envía las grabaciones a quien deba revisarlas.
</Analogy>

<QuestionBox>
En el TB del contador, ¿el monitor observa una <b>señal individual</b> (<code>count</code>) o una <b>transacción</b> (un evento tipo "hubo una cuenta hacia arriba con enable=1")? En un TB moderno queremos lo segundo. ¿Por qué es más útil?
</QuestionBox>

<!--
Respuesta esperada: porque una "transacción" tiene contexto y es comparable
contra un modelo de referencia. Una señal aislada no dice si el DUT está bien.

Este es un puente conceptual clave hacia M4.
-->

---
layout: default
---

# Pieza 4 — Checker

## La pregunta central: ¿está bien lo que salió?

<div class="mt-4">

Sin checker, un TB solo demuestra que **el DUT no explota**. No demuestra que hace lo correcto.

Un checker rudimentario a mano:

```verilog
logic [3:0] expected = 0;
int errores = 0;

always @(posedge clk) begin
  if (rst_n && enable)
    expected <= up_down ? expected + 1 : expected - 1;
end

always @(posedge clk) begin
  #1;  // dejar propagar
  if (count !== expected) begin
    $display("[ERROR] count=%0d esperado=%0d", count, expected);
    errores++;
  end
end
```

</div>

<div class="pro-tip">
La variable <code>expected</code> es un <b>reference model en miniatura</b>. En un DUT complejo (una CPU, un decodificador H.264), el reference model es un modelo <b>C++, Python o SystemVerilog</b> que reproduce la funcionalidad del DUT y el checker compara ciclo a ciclo. En M4 llamaremos a esto <b>scoreboard</b>.
</div>

<!--
Si no hay checker, el TB es DECORATIVO. Es una de las cosas que más
sorprende a los estudiantes: "escribí 200 líneas y no verifico nada".

Esa realización motiva todo M3 y M4.
-->

---
layout: default
---

# Pieza 5 — Referencia (Golden / Reference Model)

## ¿Qué debería salir del DUT?

<div class="two-col mt-4">

<div>

**Reference Model** = una implementación **independiente** de la especificación funcional. Sirve como "verdad" contra la cual comparar.

**Formas típicas:**
- Variable simple (como `expected` del slide anterior)
- Función/task en SystemVerilog
- Modelo en C/C++ vía DPI
- Modelo en Python vía cocotb
- Modelo comportamental en SV separado del RTL

</div>

<div>

```mermaid {scale: 0.75}
flowchart LR
  STIM["Estímulo"] --> DUT["DUT<br/>(RTL)"]
  STIM --> REF["Reference<br/>Model"]
  DUT --> CHK["Checker<br/>(comparador)"]
  REF --> CHK
  CHK --> V{{"¿Iguales?"}}
  V -->|Sí| PASS["PASS"]
  V -->|No| FAIL["FAIL + log"]

  style DUT fill:#576574,color:#fff
  style REF fill:#e1bee7
  style CHK fill:#ffcdd2
  style FAIL fill:#ffcdd2
  style PASS fill:#c8e6c9
```

</div>

</div>

<Analogy>
El reference model es el <b>profesor que ya resolvió el examen</b>. El DUT es el <b>alumno</b>. El checker es el <b>calificador</b> que compara respuesta por respuesta. Si difieren, alumno reprueba (bug en RTL) — <i>o</i> el profesor está mal (bug en el reference).
</Analogy>

<div class="gotcha">
En proyectos reales, cuando difieren <b>hay que investigar cuál está mal</b>. A veces es el reference. Esos días son frustrantes pero son parte del trabajo.
</div>

---
layout: default
---

# Pieza 6 — Reporte y terminación

## Cómo cerramos la simulación con conclusiones claras

<div class="mt-4">

Un TB profesional siempre termina con un reporte legible por humanos **y** por scripts CI/CD:

```verilog
final begin
  $display("=========================================");
  $display("[TB] Transacciones probadas: %0d", num_trans);
  $display("[TB] Errores: %0d", errores);
  $display("[TB] Coverage alcanzado: %.1f%%", $get_coverage());
  if (errores == 0)
    $display("[TB] RESULTADO: PASS");
  else
    $display("[TB] RESULTADO: FAIL");
  $display("=========================================");
end
```

</div>

<div class="mt-4">

**Elementos importantes:**
- **Watchdog:** si algo se atora, terminar con `$finish` tras un timeout
- **Formato parseable:** los CI systems buscan strings como `RESULTADO: PASS`
- **Códigos de salida:** `$finish(0)` vs `$finish(1)` distingue OK de fallo
- **Log estructurado:** separadores visuales facilitan el debug post-mortem

</div>

<div class="pro-tip">
En UVM esto se automatiza con el <code>uvm_report_server</code>. Ustedes solo escriben <code>`uvm_info</code>, <code>`uvm_error</code>, y el framework hace el reporte final. Otro ejemplo de <b>UVM organizando lo que ya haríamos a mano</b>.
</div>

---
layout: default
---

# SystemVerilog para verificación — una probadita

## No es Verilog + azúcar; es un lenguaje distinto para verificar

<div class="text-sm mt-4">

Verilog es para **diseñar**. SystemVerilog **para verificación** agrega construcciones que serían absurdas en RTL:

| Construcción | Para qué sirve | Ejemplo mental |
|--------------|----------------|----------------|
| `class`, `virtual`, `extends` | Programación OO en el TB | Un `driver` es una clase |
| `randomize()`, `constraint` | Estímulos aleatorios controlados | "Generar `addr` entre 0 y 4095, alineado a 4" |
| `covergroup`, `coverpoint` | Métrica objetiva de qué se probó | "¿Probamos todos los opcodes?" |
| `assert property`, `cover property` | Reglas temporales que se vigilan solas | "REQ nunca sin GNT en ≤3 ciclos" |
| `interface`, `modport`, `clocking` | Empaquetar buses y sincronización | El bus AXI-Lite es una interface |
| `mailbox`, `semaphore`, `event` | Comunicación entre procesos del TB | El generator manda transacciones al driver |
| `program` block | Región del scheduler libre de races con RTL | El TB "vive" en un program block |

</div>

<QuestionBox>
De todo esto, ¿algo ya vieron en su carrera? La mayoría dice que <code>class</code> les suena de C++/Java, pero jamás lo aplicaron a hardware. Ese es exactamente el shift mental que hacemos hoy.
</QuestionBox>

<!--
NO enseñar sintaxis todavía. Solo sembrar: "esto existe, sirve para X".
En M3 y M4 lo aterrizamos con código real. Aquí solo el mapa mental.
-->

---
layout: default
---

# Interface — el pegamento del testbench

## Empaquetar todas las señales de un bus en un solo objeto

<div class="two-col mt-4">

<div>

**Sin interface (Verilog clásico):**

```verilog
module tb;
  logic clk, rst_n, enable, up_down;
  logic [3:0] count;

  contador dut (.clk(clk), .rst_n(rst_n),
                .enable(enable), .up_down(up_down),
                .count(count));
endmodule
```

Cambia una señal y actualizas 20 archivos.

</div>

<div>

**Con interface (SV moderno):**

```verilog
interface cnt_if (input logic clk);
  logic rst_n, enable, up_down;
  logic [3:0] count;

  modport DUT (input clk, rst_n, enable, up_down,
               output count);
  modport TB  (input clk, count,
               output rst_n, enable, up_down);
endinterface

module tb;
  logic clk = 0;
  cnt_if vif(clk);
  contador dut (.clk(vif.clk), .rst_n(vif.rst_n), ...);
endmodule
```

Una fuente de verdad.

</div>

</div>

<Analogy>
Una interface es como un <b>arnés de cables</b> en un auto: en vez de 40 cables sueltos, tienes un solo mazo que conectas con un conector único. Si cambia el mazo, cambias un solo conector, no 40.
</Analogy>

<div class="pro-tip">
En M4 vamos a usar interface + <code>virtual interface</code> para conectar las clases OO al DUT. Es el mecanismo que UVM usa también.
</div>

---
layout: default
---

# Laboratorio 1 — Testbench directed

<div class="module-badge">20 min · labs/lab1_tb_directed</div>

## Objetivo

Completar un testbench directed para un contador 4-bit up/down. Identificar las seis piezas universales en el código real.

<div class="two-col mt-4">

<div>

**Archivos**
- `contador.sv` — DUT (dado)
- `tb_starter.sv` — TB con TODOs
- `tb_solution.sv` — solución (no abrir hasta terminar)
- `run.sh` — compila y corre con VCS

**Pasos**
1. Abrir `tb_starter.sv`
2. Completar TODO #1 (reloj)
3. Completar TODO #2 (estímulos y reset)
4. TODO #3 opcional (monitor rudimentario)
5. Correr con `./run.sh starter`
6. Comparar con `./run.sh`

</div>

<div>

**Errores comunes que van a encontrar**
- Olvidar `initial clk = 1'b0;`
- Aplicar estímulos en `posedge` en lugar de `negedge`
- No terminar con `$finish`
- Comparar con `==` en lugar de `!==`

**Preguntas para reflexionar mientras codean**
- ¿Cuántos escenarios están probando en total?
- ¿Qué tan probable es que este TB encuentre un bug que solo aparece en overflow?
- ¿Qué pasaría si tuvieran que escribir esto para un DUT con 32 salidas?

</div>

</div>

<!--
Timing: 15 minutos de código + 5 minutos de discusión.

Durante el lab: pasear por el aula. Los que terminan rápido probablemente
copiaron la solución. Preguntarles: "explícame por qué usaste negedge aquí".
Si no saben, hicieron cargo culto.

Al final del lab, discutir en voz alta las preguntas de la derecha. Son
la rampa emocional hacia M3.
-->

---
layout: default
---

# Post-lab: lo que acaban de sentir

## Si hicieron el lab bien, deberían haber tenido estas sensaciones

<div class="mt-6 text-sm">

1. **"Esto lo he hecho mil veces."** Sí — para diseños chicos, este TB alcanza. El punto es identificar que las seis piezas ya estaban ahí, aunque nadie las hubiera nombrado.

2. **"Este TB solo prueba lo que yo pensé probar."** Correcto. Ese es el límite estructural de todos los TB directed.

3. **"El checker es la parte más frágil."** Sí. Escrito a mano, se rompe cada vez que cambia la spec. Necesitamos automatizarlo.

4. **"Para un DUT complejo esto no escala."** Exacto. Un procesador RISC-V con 200 instrucciones necesitaría un `case` de 200 ramas solo en el checker. Insostenible.

</div>

<div class="mt-6">

**Todas estas frustraciones son legítimas.**

Son exactamente las que llevaron a la industria a inventar las herramientas del **Módulo 3**:

- Randomización dirigida → resuelve "solo lo que yo pensé"
- Coverage → resuelve "¿cuánto probé realmente?"
- Assertions → resuelve "el checker frágil"
- Reference model → resuelve "no escala"

</div>

<QuestionBox>
Antes de M3: ¿alguien tuvo un momento durante el lab de <i>"debería haber una mejor manera de hacer esto"</i>?
</QuestionBox>

<!--
Si nadie levanta la mano, presionar: "¿en serio nadie? Porque yo llevo 10
años en esto y todavía siento esa frustración cuando escribo directed TBs".

El chiste es normalizar la frustración como motor de aprendizaje.
-->

---
layout: default
---

# Resumen del Módulo 2

<div class="mt-6">

**Lo que quedó claro**

1. Todo testbench tiene **seis piezas universales**: reloj/reset, estímulo, DUT, observación, checker, referencia, reporte.
2. En un TB directed clásico, las piezas existen pero están **entrelazadas** en el mismo `initial begin`. Nadie las separa.
3. **SystemVerilog para verificación** trae construcciones que Verilog no: classes, randomize, covergroups, assertions, interfaces, mailboxes.
4. Una `interface` empaqueta todas las señales de un bus y evita el infierno de listas de puertos.
5. Los TB directed son útiles pero **estructuralmente limitados**: solo prueban lo que el ingeniero imaginó.

</div>

<div class="mt-6 pro-tip">
En el siguiente módulo levantamos el techo: cuatro técnicas modernas que resuelven las cuatro frustraciones que sintieron en el lab.
</div>

<!--
Timing acumulado esperado al final de M2: 2 h. Vamos en tiempo.
Chequeo verbal: "¿alguien necesita repasar algo antes de M3?"
Si nadie, avanzar. Si alguien duda, aprovechar 3-4 min para aclarar.
-->

---
layout: end
---

# Fin del Módulo 2

## Siguiente: los cuatro pilares de la verificación moderna

<div class="mt-8 text-sm opacity-70">
Constrained random, coverage, assertions, reference model. Con demos y código.
</div>

---
layout: section
---

<div class="module-badge">MÓDULO 3 · 75 min</div>

# Los cuatro pilares de la verificación moderna

## Constrained Random · Coverage · Assertions · Reference Model

<!--
Módulo más denso conceptualmente del curso. La ventaja: cada pilar se justifica
a partir de una frustración concreta del Lab 1 que ya sintieron.

Timing:
- Pilar 1 (Constrained Random) → 20 min + Lab 2 (20 min) = 40 min
- Pilar 2 (Coverage) → 15 min
- Pilar 3 (Assertions) → 15 min + Lab 3 (25 min combinado con Coverage) = 40 min
- Pilar 4 (Reference Model) → 10 min
- Cierre/matriz → 5 min

El Lab 3 se hace DESPUÉS de introducir Coverage Y Assertions, no en medio.
-->

---
layout: default
---

# Panorama del módulo

Los cuatro pilares resuelven las cuatro frustraciones del Lab 1:

<div class="text-sm mt-4">

| Frustración del Lab 1 | Pilar que la resuelve | Qué es |
|---------------------|----------------------|--------|
| "Solo pruebo lo que imaginé" | **Constrained Random** | Estímulos aleatorios controlados por reglas |
| "No sé qué tanto probé" | **Functional Coverage** | Métrica objetiva de escenarios visitados |
| "El checker manual es frágil" | **Assertions (SVA)** | Reglas temporales vigiladas por el simulador |
| "No escala a DUTs grandes" | **Reference Model** | Modelo independiente que dicta lo esperado |

</div>

<div class="mt-6 pro-tip">
Estos cuatro pilares NO son opcionales en un flujo profesional. Un TB moderno los usa todos, siempre. UVM es la manera de organizarlos limpiamente.
</div>

---
layout: section
---

<div class="module-badge">PILAR 1 · 20 min</div>

# Constrained Random

## Estímulos aleatorios, pero con reglas

---
layout: default
---

# La idea central de Constrained Random

<div class="two-col mt-4">

<div>

**Directed testing**
```verilog
apply(a=1, b=2);
apply(a=5, b=7);
apply(a=0, b=0);
// ... 100 líneas más
```
Pruebas exactamente lo que escribes. Y solo eso.

**Constrained Random**
```verilog
class txn;
  rand int a, b;
  constraint c { a inside {[0:255]};
                 b inside {[0:255]};
                 a + b < 500; }
endclass
repeat (10_000) txn.randomize();
```
Pruebas **10,000 combinaciones distintas** que satisfacen tus reglas. En 6 líneas.

</div>

<div>

<Analogy>
Directed es <b>escoger cada estampa del álbum a mano</b>: te llevas horas y siempre olvidas las difíciles. Constrained Random es <b>comprar sobres al azar</b>: en pocos sobres tienes la mayoría, y las pocas que faltan las cazas al final con directed.
</Analogy>

<div class="pro-tip mt-4">
En proyectos reales, la regla es: <b>90% constrained random, 10% directed</b> para forzar corner cases específicos que la aleatoriedad tarda en encontrar.
</div>

</div>

</div>

<!--
Insistir en que constrained random NO significa "totalmente al azar".
El "constrained" es TAN importante como el "random":
- 100% random: probarías direcciones no alineadas, opcodes inválidos, etc. Basura.
- 100% directed: solo pruebas lo que imaginaste.
- Constrained random: aleatorio DENTRO de lo legal según la spec.
-->

---
layout: default
---

# La sintaxis mínima que necesitan hoy

<div class="text-sm">

```verilog
class cnt_txn;
    rand bit enable;           // rand → sortear cada randomize()
    rand bit up_down;
    rand int repeticiones;

    constraint c_reps {
        repeticiones inside {[1:5]};        // rango cerrado
    }

    constraint c_dist {
        enable dist { 1 := 80, 0 := 20 };   // 80% enable=1
    }
endclass

// Uso:
cnt_txn t = new();
int ok = t.randomize();
assert (ok);  // siempre chequear el retorno
```

</div>

<div class="two-col mt-4 text-sm">

<div>

**Palabras clave**
- `rand` — se resortea en cada `randomize()`
- `randc` — cíclico: agota valores antes de repetir
- `inside {A, B, [C:D]}` — pertenencia
- `dist { A := w1, B := w2 }` — pesos relativos
- `->` — implicación (`if_a -> then_b`)

</div>

<div>

**Randomize con constraints inline**
```verilog
t.randomize() with {
    enable == 1;
    up_down == 1;
    repeticiones inside {[3:5]};
};
```
Agrega constraints solo para esta llamada.

</div>

</div>

---
layout: default
---

# Reproducibilidad: la seed importa

## Sin seeds documentadas, un bug de hoy no se reproduce mañana

<div class="mt-4">

```bash
# Cada corrida con seed distinta genera un PATRÓN distinto de estímulos
./simv +ntb_random_seed=1     # patrón A
./simv +ntb_random_seed=42    # patrón B  ← si aquí encontramos un bug...
./simv +ntb_random_seed=42    # patrón B  ← reproducible bit-a-bit
```

</div>

<div class="mt-6 text-sm">

**Práctica profesional:**
- Cada regression corre con **cientos o miles de seeds** distintas
- Las seeds "problemáticas" (las que encontraron bugs) se guardan en un `regression_list.txt`
- Nightly regressions añaden **nuevas seeds** al pool para explorar espacio nuevo
- Cuando encuentran un bug, guardan la seed exacta para bisect posterior

</div>

<div class="gotcha">
Nunca corran una regression sin especificar seed. VCS elige una seed automática que cambia entre corridas y hace <b>irreproducibles</b> los fallos.
</div>

---
layout: default
---

# Laboratorio 2 — Constrained Random

<div class="module-badge">20 min · labs/lab2_random_constraints</div>

## Objetivo

Reemplazar los estímulos directed del Lab 1 por una `class cnt_txn` con `rand` fields, `constraint` blocks y un ciclo que llame `randomize()` 200 veces. Prueben con seeds distintas y observen que los patrones cambian.

<div class="two-col mt-4 text-sm">

<div>

**Pasos**
1. Completar TODO #1 — definir `class cnt_txn`
2. Completar TODO #2 — ciclo de 200 iteraciones con `randomize()`
3. Correr con `./run.sh starter`
4. Comparar con `./run.sh`
5. Probar `./run.sh seed 42` y `./run.sh seed 100`

**Éxito del lab:**
- 200 transacciones aplicadas sin errores
- Diferentes seeds producen patrones visiblemente distintos en el waveform

</div>

<div>

**Lo que van a sentir**
- Antes: "escribo 100 líneas para probar 10 casos"
- Ahora: "escribo 15 líneas y pruebo cientos de casos"
- Y todavía tenemos un pero: **¿cómo sé si probé algo interesante?**

Ese pero es el pilar 2.

</div>

</div>

<!--
Timing: 15 min de código + 5 min discusión.

Durante el lab, hacer notar que si abren el waveform en Verdi verán que
el patrón temporal es TOTALMENTE distinto entre seed=1 y seed=42.
Eso es visual e impactante.
-->

---
layout: section
---

<div class="module-badge">PILAR 2 · 15 min</div>

# Functional Coverage

## Cómo medir "qué tanto probé"

---
layout: default
---

# El problema: ¿cuándo paro de probar?

<div class="mt-6">

Después del Lab 2 tienen esta situación:

- Corren 200, 500, 10,000 transacciones aleatorias
- Todas pasan
- **¿Está listo el DUT? ¿O se están perdiendo escenarios importantes?**

Sin una métrica objetiva, la respuesta es "no sé". Y "no sé" no vende chips.

</div>

<Analogy>
Terminar de verificar sin coverage es como estudiar para un examen <b>sin saber qué temas caen</b>. Puedes estudiar 100 horas y saltarte el capítulo que vale el 40% de la nota.
</Analogy>

<QuestionBox>
En su Lab 2, ¿cuántas veces creen que <code>count</code> tomó el valor <code>4'b1111</code>? ¿Y el valor <code>4'b0000</code>? Sin coverage, es adivinar. Con coverage, es un número exacto.
</QuestionBox>

---
layout: default
---

# Code Coverage vs Functional Coverage

<div class="text-sm mt-4">

| Tipo | Qué mide | Cómo se activa | ¿Automático? |
|------|----------|----------------|---------------|
| **Line** | Qué líneas del RTL se ejecutaron | VCS `-cm line` | Sí |
| **Branch** | Qué ramas de `if`/`case` se tomaron | VCS `-cm branch` | Sí |
| **Toggle** | Qué señales cambiaron 0↔1 | VCS `-cm tgl` | Sí |
| **FSM** | Qué transiciones de estado ocurrieron | VCS `-cm fsm` | Sí |
| **Condition** | Qué combinaciones de operandos booleanos | VCS `-cm cond` | Sí |
| **Functional** | Qué **escenarios de la spec** se probaron | `covergroup` en el TB | **No** |

</div>

<div class="mt-6">

**Ejemplo canónico del problema:**

Un ALU tiene esta línea: `if (op == ADD) result = a + b;`

- **Line coverage:** ejecutas la línea con `a=1, b=2` una vez → 100%
- **Functional coverage:** ¿probaste `a+b` con overflow? ¿Con signo negativo? ¿Con cero? Line coverage no lo sabe. Functional coverage sí.

</div>

<div class="pro-tip">
Regla de la industria: <b>Line coverage 100% es necesario pero no suficiente. Functional coverage 100% (o cerca) es la meta real.</b>
</div>

---
layout: default
---

# Anatomía de un covergroup

<div class="text-sm mt-4">

```verilog
covergroup cg_contador @(posedge clk);       // ← cuándo samplear
    option.per_instance = 1;

    cp_count: coverpoint count {              // ← qué señal medir
        bins low     = {[0:3]};              // ← agrupamientos conceptuales
        bins mid     = {[4:11]};
        bins high    = {[12:15]};
        bins zero    = {0};
        bins max_val = {15};
    }

    cp_dir: coverpoint up_down iff (enable) { // ← solo cuando enable=1
        bins up   = {1};
        bins down = {0};
    }

    cross_cd: cross cp_count, cp_dir;        // ← combinaciones
endgroup

cg_contador cg_h;
initial cg_h = new();                        // ← instanciar
```

</div>

<div class="mt-4 text-sm">

**Piezas conceptuales:**
- **coverpoint** — una señal cuya distribución queremos medir
- **bins** — categorías conceptuales del dominio de esa señal
- **cross** — combinaciones entre coverpoints (el más potente)
- **iff (cond)** — solo contar cuando la condición aplica
- **sample event** — el evento que dispara la medición (aquí: cada `posedge clk`)

</div>

---
layout: default
---

# La potencia real está en `cross`

<div class="mt-4">

**Sin cross:**
- "Visité el valor `count=15`" — bien
- "Visité `up_down=1`" — bien
- ¿Visité `count=15` mientras estaba contando **hacia arriba**? **No lo sé.**

**Con cross:**
```verilog
cross_cd: cross cp_count, cp_dir;
```
Ahora midimos las **12 combinaciones** posibles:
- (low, up), (low, down)
- (mid_low, up), (mid_low, down)
- ... etc.

</div>

<div class="pro-tip mt-4">
Los bugs interesantes viven en las <b>combinaciones</b> de estado, no en valores individuales. Por eso <code>cross</code> es donde vive el 80% del valor de un covergroup profesional.
</div>

<Analogy>
Un coverpoint solo es como saber que un estudiante <b>respondió preguntas de física y de química</b>. Un cross te dice si <b>respondió preguntas de "termodinámica con problemas numéricos"</b> — combinaciones específicas de subtemas.
</Analogy>

---
layout: default
---

# Coverage-driven verification: el loop

<div class="mt-6">

```mermaid {scale: 0.75}
flowchart TD
  A["Correr regression<br/>con N seeds"] --> B["Recolectar coverage"]
  B --> C{"¿Coverage<br/>alcanzó meta?"}
  C -->|Sí| D["Verificación cerrada.<br/>Firmar sign-off."]
  C -->|No| E["Analizar holes:<br/>¿qué escenarios faltan?"]
  E --> F{"¿Se puede llegar<br/>con constraints?"}
  F -->|Sí| G["Modificar constraints<br/>o agregar directed tests"]
  F -->|No| H["Cambiar el DUT o la spec<br/>(feature no probable)"]
  G --> A
  H --> A

  style D fill:#c8e6c9
  style E fill:#fff9c4
  style H fill:#ffcdd2
```

</div>

<div class="mt-4">

Este loop es el **latido diario** de un equipo de verificación. Nightly regressions corren miles de seeds, el reporte de coverage se revisa a la mañana siguiente, se ajustan constraints, se agregan directed tests para los holes, y se vuelve a correr.

</div>

---
layout: section
---

<div class="module-badge">PILAR 3 · 15 min</div>

# Assertions (SVA)

## Reglas temporales vigiladas por el simulador

---
layout: default
---

# ¿Qué es una assertion?

<div class="mt-4">

Una assertion es una **regla del protocolo** escrita en un lenguaje que el simulador entiende. El simulador la vigila **en cada ciclo** y avisa si se rompe.

</div>

<div class="two-col mt-4">

<div>

**Sin assertions**
- Escribo un checker manual en `always @(posedge clk)`
- Lleva ~30 líneas por regla
- Debug: leer waveforms buscando la anomalía
- Cambia la spec, cambia el checker

</div>

<div>

**Con assertions (SVA)**
- Escribo la regla en 1-2 líneas
- El simulador me avisa el ciclo exacto en que se rompió
- El mensaje incluye qué property y por qué
- Cambia la spec, cambio una property

</div>

</div>

<Analogy>
Un checker manual es un <b>guardia leyendo un manual mientras camina</b>: lento, se cansa, se distrae. Una assertion es un <b>sensor automático de alarma</b>: siempre alerta, siempre reporta, nunca se cansa.
</Analogy>

---
layout: default
---

# Sintaxis básica de SVA

<div class="text-sm mt-4">

```verilog
property p_reset_clears_count;
    @(posedge clk) (!rst_n) |-> (count == 4'b0000);
endproperty

a_reset: assert property (p_reset_clears_count)
    else $error("[SVA] count=%0d durante reset", count);
```

**Traducción a humano:** *"En cada posedge de clk, si rst_n está bajo, entonces count debe ser cero."*

</div>

<div class="mt-4 text-sm">

**Operadores temporales esenciales:**

| Operador | Significado | Ejemplo |
|----------|-------------|---------|
| `|->` | Implicación mismo ciclo | `req |-> gnt` |
| `|=>` | Implicación siguiente ciclo | `req |=> gnt` |
| `##N` | Delay de N ciclos | `req ##2 ack` |
| `##[a:b]` | Delay entre a y b ciclos | `req ##[1:3] ack` |
| `$past(x)` | Valor de x en ciclo pasado | `x == $past(x) + 1` |
| `$stable(x)` | x no cambió respecto ayer | `!en |=> $stable(count)` |
| `$rose(x)` / `$fell(x)` | Flanco de subida/bajada | `$rose(req) |-> ##1 gnt` |
| `disable iff (c)` | Deshabilitar durante c | `disable iff (!rst_n)` |

</div>

---
layout: default
---

# Ejemplo aplicado al contador

<div class="text-sm mt-4">

```verilog
// P1: durante reset, count debe ser 0
property p_reset;
    @(posedge clk) (!rst_n) |-> (count == 0);
endproperty
assert property (p_reset) else $error("count=%0d durante reset", count);

// P2: con enable=0 (y sin reset), count no cambia
property p_hold;
    @(posedge clk) disable iff (!rst_n) (!enable) |=> $stable(count);
endproperty
assert property (p_hold) else $error("count cambió con enable=0");

// P3: con enable=1 y up_down=1, count aumenta en 1
property p_increment;
    @(posedge clk) disable iff (!rst_n)
        (enable && up_down) |=> (count == $past(count) + 1);
endproperty
assert property (p_increment)
    else $error("count=%0d, esperado=%0d", count, $past(count)+1);
```

</div>

<div class="pro-tip">
Estas 3 assertions <b>reemplazan</b> ~50 líneas de checker manual — y son más precisas: dan el ciclo exacto del fallo con contexto (<code>$past</code>).
</div>

---
layout: default
---

# `cover property` — el hermano de `assert`

<div class="mt-4">

`cover property` no vigila que algo **no** ocurra: le dice al simulador *"quiero ver que este escenario **sí** ocurra"*.

```verilog
c_overflow:  cover property (
    @(posedge clk) (count == 4'b1111) ##1 (count == 4'b0000)
);
```

**Traducción:** "en algún momento, `count` valió 15 y en el siguiente ciclo valió 0" — es decir, ocurrió un overflow.

</div>

<div class="mt-4">

**Al final de la simulación, el reporte dice:**
- `c_overflow`: **covered** (bien, sí probamos overflow)
- o `c_overflow`: **not covered** (mal, aumentar iteraciones o cambiar constraints)

</div>

<div class="pro-tip">
<code>cover property</code> es complementario a <code>covergroup</code>: covergroup mide valores/combinaciones; cover property mide <b>secuencias temporales</b>. Ambos son parte de functional coverage.
</div>

---
layout: default
---

# `bind` — cómo enganchar assertions al DUT sin tocarlo

<div class="mt-4">

```verilog
// En el testbench, FUERA de todo module:
bind contador checker_sva u_sva (.*);
```

**Traducción:** "instala una instancia del módulo `checker_sva` **dentro** de cada instancia del `contador`, conectando puertos por nombre."

</div>

<div class="mt-4 text-sm">

**Ventajas:**
- El RTL del `contador` **no cambia** — misma síntesis, mismo netlist
- Puedes tener múltiples `checker_sva` para distintos aspectos
- Se pueden bindear checkers de terceros (proveedores de IP)
- Fácil deshabilitar en producción sin modificar diseño

</div>

<Analogy>
<code>bind</code> es como poner una <b>cámara externa</b> a una máquina en la fábrica. La máquina no sabe que está siendo grabada. La cámara ve todo lo que entra, sale y ocurre adentro. Puedes quitarla sin tocar la máquina.
</Analogy>

---
layout: default
---

# Laboratorio 3 — Coverage + Assertions

<div class="module-badge">25 min · labs/lab3_coverage_assertions</div>

## Objetivo

Sobre el TB del Lab 2, agregar functional coverage y assertions SVA. Al final generar el reporte HTML de coverage con `urg`.

<div class="two-col mt-4 text-sm">

<div>

**Pasos**
1. TODO #1: definir `covergroup cg_contador` con `cp_count`, `cp_dir`, `cross`
2. Instanciar `cg_h = new()` en el `initial`
3. TODO #2: `bind contador checker_sva u_sva (.*);`
4. Correr `./run.sh cov` → genera reporte URG
5. Correr `./run.sh urg` → abre HTML en navegador
6. Revisar qué bins/crosses quedaron sin cubrir

</div>

<div>

**Éxito del lab**
- Coverage total > 80%
- Todas las cover properties reportadas como "covered"
- Cero fallos de assertion (con la seed default)

**Bonus:** cambiar constraints para llegar a 100% de coverage. Es más difícil de lo que parece.

</div>

</div>

<!--
Timing: 20 min código + 5 min revisar el reporte URG en aula.

El momento HTML del reporte URG es visualmente potente. Mostrarlo proyectado.
Los estudiantes suelen sorprenderse de que "así se ve un reporte real de
verificación" — muy distinto del $display en consola.
-->

---
layout: section
---

<div class="module-badge">PILAR 4 · 10 min</div>

# Reference Model

## La verdad contra la cual comparamos

---
layout: default
---

# Reference Model — formalizando la idea

<div class="mt-4">

Ya vieron el concepto: en el Lab 2 usaron una variable `expected` que actualizaban a mano. Eso **era** un reference model minúsculo.

En un DUT complejo (CPU, códec, controlador USB), el reference model es una **implementación independiente** de la spec funcional:

</div>

<div class="two-col mt-4 text-sm">

<div>

**Formas típicas:**
- **Variable SV** (contador simple)
- **Función/task SV** (ALU, decoder)
- **Class SV separada** (bloque protocolar)
- **C/C++ vía DPI** (procesador, códec)
- **Python vía cocotb** (validación cruzada)
- **Modelo comportamental Verilog** separado

</div>

<div>

**Propiedades importantes:**
- **Independiente** del RTL bajo prueba
- Escrito por otra persona idealmente
- Basado directamente en la spec
- No optimizado para velocidad — optimizado para claridad
- Se valida contra pruebas doradas antes de usarse

</div>

</div>

<Analogy>
El reference es el <b>profesor que ya resolvió el examen antes</b>. Cuando el alumno (DUT) entrega su respuesta, se compara contra la del profesor. Si difieren, o el alumno está mal, o el profesor está mal — y hay que investigar cuál.
</Analogy>

---
layout: default
---

# Reference model en el flujo del testbench

<div class="mt-4">

```mermaid {scale: 0.75}
sequenceDiagram
    autonumber
    participant GEN as Generator
    participant DRV as Driver
    participant DUT as DUT (RTL)
    participant REF as Reference Model
    participant MON as Monitor
    participant SB as Scoreboard

    GEN->>DRV: transaction
    GEN->>REF: misma transaction
    DRV->>DUT: aplicar en pines
    REF->>SB: respuesta esperada
    DUT->>MON: respuesta real
    MON->>SB: respuesta real (observada)
    SB->>SB: comparar esperada vs real
    Note over SB: PASS o FAIL
```

</div>

<div class="mt-4">

**El diagrama de arriba es la anatomía completa** de un testbench moderno. Estas son las piezas que vamos a construir en el Módulo 4 — cada una como su propia `class`.

</div>

---
layout: default
---

# Matriz: qué bug encuentra cada técnica

<div class="text-sm mt-4">

| Tipo de bug | Directed | Constrained Random | Coverage | Assertions | Reference Model |
|-------------|----------|-------------------|----------|------------|-----------------|
| Caso obvio de la spec | Excelente | Bueno | N/A | Bueno | Excelente |
| Corner case previsto | Excelente | Regular | Excelente para medir | Bueno | Excelente |
| Corner case imprevisto | Nulo | Excelente | Detecta ausencia | Nulo | Excelente |
| Violación temporal (protocolo) | Regular | Regular | Regular | **Excelente** | Regular |
| Divergencia funcional | Bueno | Bueno | N/A | Regular | **Excelente** |
| Escenario nunca visitado | Nulo | Regular | **Excelente para medirlo** | Nulo | Nulo |
| Race condition | Nulo | Regular | Nulo | **Excelente** | Nulo |

</div>

<div class="mt-4 pro-tip">
Ninguna técnica es completa por sí sola. Un TB profesional usa <b>las cinco</b> — con la mayoría del volumen en Constrained Random + Coverage.
</div>

---
layout: default
---

# Resumen del Módulo 3

<div class="mt-4">

**Los cuatro pilares:**

1. **Constrained Random** — aleatoriedad controlada; 200 transacciones en 15 líneas de código
2. **Functional Coverage** — métrica objetiva de qué escenarios visitamos; `covergroup + cross + urg`
3. **Assertions (SVA)** — reglas temporales vigiladas por el simulador; `property + assert + bind`
4. **Reference Model** — implementación independiente de la spec que dicta lo esperado

**Lo que ganamos con los cuatro:**

- Escala: pruebas miles de escenarios sin escribir cada uno
- Objetividad: medimos qué probamos, no adivinamos
- Automatización: los checkers vigilan solos
- Precisión: el reference dicta la verdad ciclo a ciclo

</div>

<div class="mt-4 pro-tip">
Después del break vamos al Módulo 4 — el corazón del curso. Ahí van a tomar todas estas piezas sueltas y las van a <b>organizar en classes separadas</b>. Y verán que UVM es exactamente esa organización, con nombres formales.
</div>

<QuestionBox>
Antes del break: ¿alguna duda de los 4 pilares?
</QuestionBox>

---
layout: end
---

# Fin del Módulo 3

## Break de 15 minutos

<div class="mt-8 text-sm opacity-70">
Cuando volvamos: construir UVM a mano, sin UVM.
</div>
