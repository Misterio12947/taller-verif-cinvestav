# Mapa conceptual del curso

Este documento contiene el mapa mental completo del curso en formato Mermaid. Se puede imprimir en A3 para colgar en el aula, o proyectar como resumen del último slide del curso.

## Mapa mental (mindmap)

```mermaid
mindmap
  root((Functional<br/>Verification))
    Motivación
      Costo del bug
        Pre-tape-out: minutos
        Post-tape-out: millones
      Verification Gap
        Complejidad exponencial
        TBs manuales no escalan
      70 pct del esfuerzo
        Más verif que RTL
        Mercado laboral amplio
    Anatomía TB
      Reloj y Reset
      Estímulo
      Observación
      Checker
      Reference Model
      Reporte
    Cuatro Pilares
      Constrained Random
        rand / randc
        constraint
        dist
        seed
      Functional Coverage
        covergroup
        coverpoint
        bins
        cross
      Assertions SVA
        property
        assert
        cover
        bind
      Reference Model
        Golden model
        predict()
    Arquitectura OO
      Transaction
      Generator
      Driver
      Monitor
      Scoreboard
      Environment
      Agent
      Pegamento
        mailbox
        virtual interface
        fork join none
    UVM
      Fases
        build
        connect
        run
        report
      Factory
        type override
      Config DB
        set / get
      TLM
        analysis port
        seq item port
      Reporting
        uvm info
        uvm error
        uvm fatal
    Herramientas
      Simulación
        VCS
        Verdi
      Análisis
        SpyGlass
        VC Formal
        URG
      Implementación
        Design Compiler
        IC Compiler II
        PrimeTime
```

## Flujo de datos en un testbench moderno

```mermaid
flowchart LR
  subgraph GEN["Generator"]
    R["randomize()"]
  end

  subgraph AGENT["Agent"]
    DRV["Driver"]
    MON["Monitor"]
  end

  DUT["DUT"]

  subgraph SB["Scoreboard"]
    REF["Reference Model<br/>predict()"]
    CMP["compare()"]
  end

  RPT["Report<br/>PASS / FAIL"]

  GEN -->|"transaction"| DRV
  GEN -.->|"transaction (clone)"| REF
  DRV -->|"virtual interface"| DUT
  DUT -->|"virtual interface"| MON
  MON -->|"observed transaction"| CMP
  REF --> CMP
  CMP --> RPT

  style GEN fill:#bbdefb
  style DRV fill:#2e86de,color:#fff
  style MON fill:#10ac84,color:#fff
  style DUT fill:#576574,color:#fff
  style REF fill:#a55eea,color:#fff
  style CMP fill:#ee5253,color:#fff
  style RPT fill:#fff9c4
```

## De su Lab 4 a UVM (mapeo directo)

```mermaid
flowchart LR
  subgraph L4["Lab 4 - Su código"]
    T1["class alu_transaction"]
    G1["class alu_generator"]
    D1["class alu_driver"]
    M1["class alu_monitor"]
    S1["class alu_scoreboard"]
    E1["class alu_env"]
  end

  subgraph UVM["UVM (mismo, con herencia)"]
    T2["extends uvm_sequence_item"]
    G2["extends uvm_sequence"]
    D2["extends uvm_driver #(T)"]
    M2["extends uvm_monitor"]
    S2["extends uvm_scoreboard"]
    E2["extends uvm_env"]
  end

  T1 -.->|1:1| T2
  G1 -.->|1:1| G2
  D1 -.->|1:1| D2
  M1 -.->|1:1| M2
  S1 -.->|1:1| S2
  E1 -.->|1:1| E2

  style L4 fill:#e8f5e9
  style UVM fill:#e3f2fd
```

## Flujo ASIC — dónde encaja verificación

```mermaid
flowchart TD
  SPEC["Spec / Arquitectura"] --> RTL["RTL Design"]

  subgraph VERIF["Verificación funcional (M2-M5)"]
    direction LR
    LINT["SpyGlass<br/>(Lint)"]
    SIM["VCS + UVM<br/>(Simulación)"]
    FORMAL["VC Formal<br/>(Formal)"]
    DEBUG["Verdi<br/>(Debug)"]
    COV["URG<br/>(Coverage)"]
  end

  RTL --> VERIF
  VERIF --> DC["Design Compiler<br/>(Síntesis)"]
  DC --> GLS1["GLS pre-layout<br/>(VCS)"]
  GLS1 --> PNR["IC Compiler II<br/>(Place & Route)"]
  PNR --> GLS2["GLS post-layout"]
  GLS2 --> PT["PrimeTime<br/>(STA)"]
  PT --> GDS["GDS a la fab"]

  style VERIF fill:#c8e6c9
  style RTL fill:#e3f2fd
  style GDS fill:#a5d6a7
```

## Instrucciones para el instructor

Este mapa se puede:

1. **Proyectar en la última slide del M7** como resumen visual
2. **Imprimir en A3 o A2** y colgar en el aula durante todo el curso
3. **Regalar en PDF** a los estudiantes como material de referencia
4. **Usar como diagnóstico durante el curso**: al final de cada módulo, señalar en el mapa qué acabamos de cubrir

Para generar el PDF de este mapa, usar Mermaid Live Editor (`https://mermaid.live`) o exportar directamente desde Slidev.
