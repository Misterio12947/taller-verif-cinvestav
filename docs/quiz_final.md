# Quiz final — Módulo 7

**Duración:** 10 minutos
**Modalidad:** individual, respuestas escritas
**Calificación:** no cuenta, es solo autoevaluación

## Instrucciones

Diez preguntas que cubren el arco del curso. Contesten lo que puedan. La discusión posterior es más importante que las respuestas individuales.

---

## Preguntas y respuestas

### 1. En una sola frase: ¿por qué existe la Functional Verification?

**Respuesta esperada:** Porque un bug encontrado post-tape-out cuesta millones de dólares y meses de retraso, mientras que uno encontrado pre-tape-out cuesta minutos. La verificación funcional es la disciplina que atrapa bugs antes del silicio.

**Puntos clave a validar:** menciona el costo, la escala, o el momento del ciclo. Si mencionan el 70% del esfuerzo, bonus.

---

### 2. ¿Qué diferencia hay entre Line Coverage y Functional Coverage?

**Respuesta esperada:**
- **Line coverage** (automático): mide qué líneas del RTL se ejecutaron durante la simulación.
- **Functional coverage** (manual, con `covergroup`): mide qué escenarios de la especificación se probaron.

Line coverage 100% no implica functional coverage 100%. Se puede ejecutar cada línea del ALU sin haber probado ninguna suma con overflow.

**Puntos clave a validar:** distinguen que uno es automático y otro es manual/de spec. Si dan el ejemplo del ALU o similar, respuesta completa.

---

### 3. En un testbench, ¿cuál es la responsabilidad única del driver? ¿Y del monitor?

**Respuesta esperada:**
- **Driver:** consumir transacciones abstractas y aplicarlas al bus físico del DUT.
- **Monitor:** observar el bus (sin escribir) y reconstruir transacciones observadas.

Driver es activo (escribe), monitor es pasivo (solo lee). Ambos usan `virtual interface` para acceder al DUT.

---

### 4. ¿Qué es un virtual interface y qué problema resuelve?

**Respuesta esperada:** Un handle desde una clase (mundo OO) a una `interface` de SystemVerilog (mundo módulos). Resuelve el problema de que las clases no pueden acceder directamente a señales de módulos. También permite que el TB no dependa de nombres específicos de señales del DUT.

---

### 5. ¿Qué es un covergroup y para qué sirve el cross?

**Respuesta esperada:**
- **Covergroup:** contenedor de coverpoints que miden qué valores se visitaron.
- **Cross:** producto cartesiano entre dos coverpoints — mide combinaciones.

Ejemplo del curso: `cross cp_count, cp_dir` mide todas las combinaciones (rango del contador × dirección). Los bugs interesantes viven en las combinaciones, no en valores individuales.

---

### 6. ¿Cuál es la diferencia entre `|->` y `|=>` en una property SVA?

**Respuesta esperada:**
- `|->` (overlapping): si antecedente entonces consecuente **en el mismo ciclo**
- `|=>` (non-overlapping): si antecedente entonces consecuente **en el ciclo siguiente**

Ejemplo:
- `req |-> gnt` — cuando hay req, gnt debe estar en el mismo ciclo
- `req |=> gnt` — cuando hay req, gnt debe llegar al siguiente ciclo

---

### 7. ¿Cuál es la relación entre `mailbox #(T)` y `uvm_analysis_port`?

**Respuesta esperada:** Son ambos canales de comunicación tipada entre componentes del testbench.
- `mailbox #(T)`: FIFO 1-a-1 (un solo consumidor), bloqueante.
- `uvm_analysis_port`: broadcast 1-a-N (múltiples subscribers), no bloqueante.

En el Lab 4 usamos mailboxes. En UVM se usa analysis_port porque un monitor típicamente publica a scoreboard + coverage + logger simultáneamente.

---

### 8. ¿Qué hace el scoreboard y por qué necesita un reference model?

**Respuesta esperada:** El scoreboard compara lo que el DUT hizo (observado por el monitor) contra lo que debía hacer según la especificación. El reference model es una implementación independiente de la spec funcional que sirve como "verdad" para la comparación.

Sin reference model, el scoreboard no tiene contra qué comparar — solo puede detectar crashes, no divergencias funcionales.

---

### 9. Nombren las 4 fases más importantes de un componente UVM.

**Respuesta esperada:**
1. **build_phase** — crear componentes hijos
2. **connect_phase** — conectar puertos TLM
3. **run_phase** — donde ocurre la simulación
4. **report_phase** — imprimir PASS/FAIL

Bonus si mencionan también `extract_phase` y `check_phase` entre `run` y `report`.

---

### 10. ¿Cuál Synopsys tool usarían para: (a) simular un TB, (b) ver waveforms, (c) hacer STA?

**Respuesta esperada:**
- (a) Simular un TB: **VCS**
- (b) Ver waveforms: **Verdi**
- (c) Static Timing Analysis: **PrimeTime**

---

## Discusión sugerida (5 min)

Después de que respondan, preguntar en voz alta cuáles fueron las más difíciles. Por experiencia, las más falladas suelen ser:

- **Pregunta 2** — la mayoría confunde functional coverage con "hacer más tests"
- **Pregunta 6** — el operador SVA (`|->` vs `|=>`) es sutil
- **Pregunta 7** — la relación mailbox / analysis_port es un puente conceptual clave

Repasar estas rápidamente con la respuesta correcta.

## Análisis para el instructor

**Si la mayoría acierta 7+ de 10:**
El curso fue efectivo. Están listos para el Bootcamp.

**Si aciertan 5-6:**
Bases sólidas pero con vacíos. En el primer día del Bootcamp dedicar 30 min a repaso de covergroups y TLM.

**Si aciertan menos de 5:**
Los conceptos no aterrizaron. Considerar una sesión de refuerzo antes del Bootcamp — puede ser asincrónica con videos de las slides.

## Autoevaluación para el estudiante

Un estudiante que acierta 7+ tiene el material del propedéutico bien integrado. Los que aciertan menos deben repasar las slides del módulo correspondiente antes del primer día del Bootcamp.
