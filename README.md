# ASIC_CD2

Projeto de um **ASIC** (*Application-Specific Integrated Circuit*) desenvolvido para o Trabalho Prático 2 da disciplina **Circuitos Digitais II**— UFPel.

> **Universidade Federal de Pelotas**
> Centro de Desenvolvimento Tecnológico · Curso de Engenharia de Computação


---

## 📋 Descrição do problema

**Tema — Soma das arestas de um prisma retangular reto**

> Leia as dimensões das arestas de um prisma retangular reto por meio da porta de entrada `DataIn`. Calcule o somatório de todas as suas arestas e apresente o resultado na porta de saída `DataOut`.

Um prisma retangular possui 3 dimensões distintas (largura, altura e base), cada uma repetida 4 vezes em suas 12 arestas. Logo:

```
somatorio = 4 × (largura + altura + base)
```

---

## 🧠 Algoritmo em alto nível

```
programa {
    funcao inicio() {
        inteiro largura, altura, base
        inteiro somatorio

        escreva("Digite a largura (DataIn): ")
        leia(largura)

        escreva("Digite a altura (DataIn): ")
        leia(altura)

        escreva("Digite a base (DataIn): ")
        leia(base)

        somatorio = 4 * (largura + altura + base)

        escreva("\nSoma total das arestas: ", somatorio, "\n")
    }
}
```

📄 Disponível em [`algoritmo_alto_nivel.por`](./algoritmo_alto_nivel.por).

---

## 🏗️ Arquitetura

O circuito segue o modelo clássico **Bloco de Controle + Bloco Operativo (datapath)**, com registradores de 8 bits:

- **Bloco Operativo (datapath):** 8 registradores (`R0`–`R7`), multiplexadores 2:1 na entrada de cada registrador, dois barramentos de leitura (muxes 8:1) para as entradas da ULA, um somador/subtrator com flags (`N`, `Z`, `Cout`, `OV`), um *shifter* (SLL/SRL) e muxes de saída que definem `DataOut` e o barramento de realimentação `Data_Ula`.
- **Bloco de Controle:** uma FSM (`Sreset`, `S0`...`S5`) que gera, a cada estado, a palavra de controle `C(27 downto 0)`, responsável por selecionar as entradas dos registradores, habilitar os *loads*, escolher os operandos da ULA (`OpA`/`OpB`), o modo soma/subtração, o sentido do *shift* e a fonte de `DataOut`.

O projeto foi otimizado para usar **apenas os recursos necessários** à implementação do algoritmo do Tema 13 (menos registradores/estados ativos que o datapath genérico permite).

---

## 📁 Estrutura do repositório

```
ASIC_CD2/
├── algoritmo_alto_nivel.por      # Algoritmo em alto nível (pseudocódigo)
├── parte_de_controle.vhd         # Bloco de controle (FSM) em VHDL
├── projeto_RT-bloco_operativo.zip
│   ├── datapath.vhd              # Bloco operativo completo
│   ├── mux4_1.vhd                # Multiplexador 4:1
│   ├── reg8.vhd                  # Registrador de 8 bits
│   ├── SC.vhd                    # Somador/subtrator com flags
│   ├── Shiftl.vhd                # Shift lógico à esquerda
│   ├── Shiftr.vhd                # Shift lógico à direita
│   ├── soma_sub.vhd              # Unidade de soma/subtração
│   └── ULA.vhd                   # Unidade lógico-aritmética
├── TrabalhoPra_tico_CD2.pdf      # Enunciado oficial do trabalho
├── LICENSE                       # Licença MIT
└── README.md
```

---

## ⚙️ Como simular

1. Abra o projeto no **Quartus** (Kit Altera **DE-2**).
2. Adicione os arquivos `.vhd` do bloco operativo (dentro do `.zip`) e o `parte_de_controle.vhd` ao projeto.
3. Compile o projeto e gere/edite o arquivo de forma de onda (`.vwf`) com os estímulos de `DataIn`, `clk` e `reset`.
4. Execute a simulação e valide a sequência de estados da FSM e o resultado apresentado em `DataOut`.

---

## ✅ Itens entregues

- [x] Algoritmo em alto nível
- [] Alocação dos registradores
- [] Algoritmo em termos de registradores
- [] Diagrama de estados com as operações de transferência
- [] Implementação em VHDL (bloco de controle + bloco operativo)
- [] Validação por simulação (`.vwf`)
- [] Relatório com diagramas, código e telas de simulação

---



## 📜 Licença

Distribuído sob a licença **MIT**. Veja [`LICENSE`](./LICENSE) para mais detalhes.

Copyright (c) 2026 Lúcio Vagner Carvalho Souza
