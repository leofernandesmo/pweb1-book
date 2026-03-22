# Capítulo 9 — Layout com Grid

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 9.1 — O que é CSS Grid e quando usar

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **CSS Grid Layout** é o sistema de layout bidimensional nativo do CSS — projetado especificamente para organizar elementos em **linhas e colunas simultaneamente**. Enquanto o Flexbox opera em uma única dimensão (uma linha *ou* uma coluna por vez), o Grid permite posicionar elementos em uma grade com controle preciso sobre ambos os eixos ao mesmo tempo.

Publicado como recomendação pelo W3C em 2017 e com suporte amplo em todos os navegadores modernos desde então, o CSS Grid representa a ferramenta mais poderosa já disponibilizada nativamente pelo CSS para criação de layouts — eliminando a necessidade dos sistemas de grid baseados em frameworks como Bootstrap para a maioria dos casos de uso.

### 9.1.1 — O problema que o Grid resolve

Antes do CSS Grid, criar layouts de duas dimensões — como a estrutura clássica de uma página web com cabeçalho, conteúdo principal, sidebar e rodapé — exigia combinações complexas de floats, posicionamento absoluto ou frameworks externos:

```css
/* Era pré-Grid: layout com float */
.header  { width: 100%; }
.main    { float: left; width: 70%; }
.sidebar { float: right; width: 28%; margin-left: 2%; }
.footer  { clear: both; width: 100%; }

/* Problemas: clearfix necessário, altura igual entre colunas impossível,
   reordenação para mobile requer JavaScript ou marcação adicional */
```

Com CSS Grid, o mesmo layout é declarado de forma clara, semântica e manutenível:

```css
.pagina {
  display: grid;
  grid-template-columns: 1fr 300px;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "header  header"
    "main    sidebar"
    "footer  footer";
  min-height: 100vh;
}
```

### 9.1.2 — Conceito de grid container, grid items, linhas, colunas e células

O Grid opera em dois níveis, assim como o Flexbox:

- **Grid container:** o elemento ao qual `display: grid` é aplicado. Define a estrutura da grade.
- **Grid items:** os **filhos diretos** do grid container. São posicionados nas células da grade.

A grade em si é composta por:

- **Colunas (*columns*):** divisões verticais da grade
- **Linhas (*rows*):** divisões horizontais da grade
- **Células (*cells*):** a intersecção de uma linha com uma coluna — a unidade mínima da grade
- **Áreas (*areas*):** agrupamento retangular de uma ou mais células adjacentes

### 9.1.3 — Terminologia: grid lines, tracks, areas e gaps

O CSS Grid possui uma terminologia precisa que é essencial dominar para interpretar a especificação e a documentação:

```
         col 1    col 2    col 3
       |        |        |        |
linha 1|  [1,1] |  [1,2] |  [1,3] |
       |        |        |        |
linha 2|  [2,1] |  [2,2] |  [2,3] |
       |        |        |        |
linha 3|  [3,1] |  [3,2] |  [3,3] |
       |        |        |        |

Grid lines (linhas de grade): as linhas divisórias numeradas
  → colunas: 1, 2, 3, 4 (n colunas = n+1 linhas verticais)
  → linhas:  1, 2, 3, 4 (n linhas  = n+1 linhas horizontais)

Grid tracks (trilhas): o espaço entre duas grid lines adjacentes
  → uma coluna é uma trilha vertical
  → uma linha é uma trilha horizontal

Grid area: retângulo formado por grid lines
  → pode abranger múltiplas células

Gap: espaço entre trilhas (anteriormente chamado de grid-gap)
```

> **Imagem sugerida:** diagrama visual da grade com grid lines numeradas em azul, células destacadas em cinza claro, e um exemplo de grid area abrangendo múltiplas células em laranja — com labels de cada conceito.
>
> *(imagem será adicionada posteriormente)*

As **grid lines são numeradas a partir de 1**, não de 0. Em uma grade de 3 colunas, as linhas verticais são numeradas 1, 2, 3 e 4. Também podem ser referenciadas de trás para frente com valores negativos: `-1` é sempre a última linha, `-2` a penúltima, etc.

### 9.1.4 — Grid vs Flexbox: escolhendo o modelo certo

A tabela abaixo complementa a visão apresentada no Capítulo 8, agora com o Grid disponível como referência concreta:

| Critério | Flexbox | Grid |
|---|---|---|
| Dimensões | 1D: linha **ou** coluna | 2D: linha **e** coluna |
| Ponto de partida | Conteúdo determina layout | Layout determina posição do conteúdo |
| Alinhamento | No eixo principal ou cruzado | Em ambos os eixos simultaneamente |
| Melhor para | Componentes (navbar, cards, forms) | Estruturas de página, galerias, dashboards |
| Posicionamento preciso | Limitado | Preciso por linhas e áreas nomeadas |
| Responsividade intrínseca | Via `flex-wrap` | Via `auto-fill`/`auto-fit` + `minmax()` |

Na prática profissional, Grid e Flexbox são complementares e frequentemente usados juntos no mesmo projeto: Grid para a estrutura macro da página, Flexbox para os componentes internos.

> **Referência:** [MDN — CSS Grid Layout](https://developer.mozilla.org/pt-BR/docs/Web/CSS/CSS_grid_layout)

---

## 9.2 — Definindo a grade: colunas e linhas

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 9.2.1 — `grid-template-columns` e `grid-template-rows`

Estas duas propriedades definem a estrutura explícita da grade — quantas colunas e linhas existem, e qual o tamanho de cada trilha:

```css
.container {
  display: grid;

  /* Três colunas: 200px, 1fr, 300px */
  grid-template-columns: 200px 1fr 300px;

  /* Duas linhas: primeira com 80px, segunda automática */
  grid-template-rows: 80px auto;
}

/* Exemplos variados */
.grade-simples {
  grid-template-columns: 1fr 1fr 1fr;      /* três colunas iguais */
  grid-template-columns: 25% 50% 25%;      /* porcentagens */
  grid-template-columns: 200px 1fr;        /* fixa + flexível */
  grid-template-columns: auto auto auto;   /* automático pelo conteúdo */
}
```

### 9.2.2 — A unidade `fr` — fração do espaço disponível

A unidade `fr` (*fraction*) é exclusiva do CSS Grid e representa uma fração do **espaço disponível** no container após subtrair espaços fixos (colunas em `px`, `%`, gaps):

```css
.container {
  display: grid;
  width: 900px;
  gap: 20px;

  /* Três colunas iguais: cada uma recebe 1/3 do espaço disponível */
  grid-template-columns: 1fr 1fr 1fr;
  /* Espaço disponível: 900px - (2 × 20px gap) = 860px → cada coluna ≈ 286px */

  /* Proporções diferentes */
  grid-template-columns: 2fr 1fr;
  /* Coluna 1: 2/3 de 860px ≈ 573px | Coluna 2: 1/3 de 860px ≈ 287px */

  /* Coluna fixa + coluna flexível */
  grid-template-columns: 300px 1fr;
  /* Coluna 1: 300px fixos | Coluna 2: 900px - 300px - 20px gap = 580px */
}
```

A distinção entre `fr` e `%` é importante: `%` é calculado sobre o tamanho total do container (incluindo gaps), enquanto `fr` é calculado sobre o espaço *restante* após descontar espaços fixos — tornando `fr` mais previsível em layouts com gaps.

### 9.2.3 — A função `repeat()`

`repeat()` evita a repetição manual de trilhas idênticas:

```css
.container {
  /* Sem repeat: verboso */
  grid-template-columns: 1fr 1fr 1fr 1fr;

  /* Com repeat: conciso */
  grid-template-columns: repeat(4, 1fr);

  /* Padrão repetido */
  grid-template-columns: repeat(3, 1fr 2fr); /* 6 colunas: 1fr 2fr 1fr 2fr 1fr 2fr */

  /* Valores mistos */
  grid-template-columns: 200px repeat(3, 1fr) 200px;
  /* resultado: 200px 1fr 1fr 1fr 200px */

  /* Linhas também */
  grid-template-rows: repeat(4, 150px);
  grid-template-rows: 80px repeat(3, 1fr) 60px;
}
```

### 9.2.4 — A função `minmax()`

`minmax(mínimo, máximo)` define um intervalo de tamanho para uma trilha — ela pode crescer até o máximo e encolher até o mínimo:

```css
.container {
  /* Cada coluna tem no mínimo 200px e no máximo 1fr */
  grid-template-columns: repeat(3, minmax(200px, 1fr));

  /* Linhas com altura mínima, crescendo com o conteúdo */
  grid-template-rows: repeat(4, minmax(100px, auto));

  /* Sidebar com largura entre 200px e 300px */
  grid-template-columns: minmax(200px, 300px) 1fr;
}
```

`minmax()` é especialmente útil em combinação com `auto-fill`/`auto-fit` para criar grids intrinsecamente responsivos.

### 9.2.5 — `auto-fill` vs `auto-fit` — grids intrinsecamente responsivos

Esta é uma das funcionalidades mais poderosas do CSS Grid: criar grades que se adaptam automaticamente ao espaço disponível **sem nenhuma media query**:

```css
/* auto-fill: cria o máximo de colunas que caibam,
   mantendo colunas vazias se houver espaço sobrando */
.grade-auto-fill {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
}

/* auto-fit: cria o máximo de colunas que caibam,
   mas EXPANDE as existentes para preencher o espaço vazio */
.grade-auto-fit {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
}
```

```
Container: 800px | minmax(250px, 1fr)

Em 800px → 3 colunas cabem (3 × 250px = 750px ≤ 800px)
Em 600px → 2 colunas cabem (2 × 250px = 500px ≤ 600px)
Em 300px → 1 coluna cabe

auto-fill com 2 itens em container de 800px:
[  item 1  ][  item 2  ][        ][        ]
                         ↑ colunas vazias mantidas

auto-fit com 2 itens em container de 800px:
[    item 1    ][    item 2    ]
 ↑ colunas vazias colapsadas, itens expandem
```

**Quando usar cada um:**
- `auto-fill`: quando a grade deve manter sua estrutura mesmo com poucos itens (ex.: grade de produtos que pode ter uma ou muitas linhas)
- `auto-fit`: quando os itens devem expandir para preencher o container quando há poucos (ex.: cards que devem sempre cobrir a largura total)

---

## 9.3 — Posicionamento de itens

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 9.3.1 — Fluxo automático do grid

Por padrão, os grid items são posicionados automaticamente nas células da grade em ordem — preenchendo linha por linha, da esquerda para a direita:

```html
<div class="container">
  <div>1</div>
  <div>2</div>
  <div>3</div>
  <div>4</div>
  <div>5</div>
</div>
```

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

/* Resultado do fluxo automático:
   [1][2][3]
   [4][5]   ← quinta célula vazia
*/
```

O fluxo automático é suficiente para a maioria dos casos — grades de cards, galerias, listas de produtos. O posicionamento explícito é necessário quando um item precisa ocupar uma posição ou tamanho específico na grade.

### 9.3.2 — `grid-column` e `grid-row` — posicionamento por linhas

`grid-column` e `grid-row` posicionam um item especificando entre quais **grid lines** ele deve se estender:

```css
.item {
  /* grid-column: linha-início / linha-fim */
  grid-column: 1 / 3;  /* da linha vertical 1 até a 3 (2 colunas) */
  grid-row: 2 / 4;     /* da linha horizontal 2 até a 4 (2 linhas) */
}

/* Exemplos */
.header {
  grid-column: 1 / 4;  /* ocupa todas as 3 colunas */
  grid-row: 1 / 2;     /* primeira linha */
}

.footer {
  grid-column: 1 / -1; /* da primeira à última linha (-1 = última) */
  grid-row: 4 / 5;
}

.destaque {
  grid-column: 2 / 4;  /* colunas 2 e 3 */
  grid-row: 1 / 3;     /* linhas 1 e 2 */
}
```

**Referência por linha negativa:** `-1` sempre se refere à última grid line, `-2` à penúltima, independentemente do número total de colunas ou linhas:

```css
/* Ocupa a largura inteira da grade, independente de quantas colunas há */
.largura-total {
  grid-column: 1 / -1;
}
```

### 9.3.3 — `span` — extensão por múltiplas células

Em vez de especificar a linha final, `span` indica quantas trilhas o item deve ocupar a partir de sua posição:

```css
.item {
  /* Equivalentes: ambos ocupam 2 colunas a partir da coluna 2 */
  grid-column: 2 / 4;
  grid-column: 2 / span 2;

  /* Span sem posição inicial: o item ocupa 3 colunas a partir
     de onde o fluxo automático o colocar */
  grid-column: span 3;
  grid-row: span 2;
}
```

`span` é especialmente útil em grades com fluxo automático onde a posição inicial não é determinística — apenas o tamanho do item é fixado:

```css
/* Grade de galeria: algumas imagens são maiores */
.imagem-destaque {
  grid-column: span 2;
  grid-row: span 2;
  /* ocupa 2×2 células, em qualquer posição que o fluxo colocar */
}
```

### 9.3.4 — `grid-area` — posicionamento com nome

`grid-area` é um shorthand que combina `grid-row-start`, `grid-column-start`, `grid-row-end` e `grid-column-end`:

```css
.item {
  /* grid-area: row-start / col-start / row-end / col-end */
  grid-area: 1 / 2 / 3 / 4;
  /* equivale a:
     grid-row: 1 / 3;
     grid-column: 2 / 4; */
}
```

O uso mais importante de `grid-area`, porém, é como identificador de área nomeada — explorado na próxima seção.

---

## 9.4 — Áreas nomeadas

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

As áreas nomeadas são uma das funcionalidades mais expressivas do CSS Grid. Elas permitem declarar o layout da página como um **mapa visual em ASCII** diretamente no CSS — tornando o código autoexplicativo e extremamente fácil de modificar.

### 9.4.1 — `grid-template-areas` — definindo o mapa visual do layout

```css
.pagina {
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-template-rows: 80px 1fr 60px;
  grid-template-areas:
    "header  header"
    "sidebar main  "
    "footer  footer";
  min-height: 100vh;
  gap: 1rem;
}
```

A string de `grid-template-areas` é um mapa visual direto do layout: cada linha da string corresponde a uma linha da grade, cada palavra a uma célula. Células com o mesmo nome formam uma área retangular contígua.

> **Regra importante:** áreas nomeadas devem ser sempre **retangulares e contíguas**. Não é possível criar uma área em L ou T, por exemplo. Tentativas de criar áreas não retangulares produzem um valor inválido ignorado pelo navegador.

### 9.4.2 — Atribuindo itens a áreas com `grid-area`

Depois de definir as áreas no container, cada item recebe o nome da área correspondente:

```html
<div class="pagina">
  <header class="cabecalho">Cabeçalho</header>
  <nav class="barra-lateral">Sidebar</nav>
  <main class="conteudo">Conteúdo Principal</main>
  <footer class="rodape">Rodapé</footer>
</div>
```

```css
.pagina {
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-template-rows: 80px 1fr 60px;
  grid-template-areas:
    "header  header"
    "sidebar main  "
    "footer  footer";
  min-height: 100vh;
  gap: 1rem;
}

/* Cada item recebe o nome da sua área */
.cabecalho    { grid-area: header;  }
.barra-lateral { grid-area: sidebar; }
.conteudo     { grid-area: main;    }
.rodape       { grid-area: footer;  }
```

O resultado é um layout de página completo, semântico e visualmente declarado no CSS — sem nenhum posicionamento absoluto ou float.

### 9.4.3 — Células vazias com `.` (ponto)

Quando uma célula da grade não pertence a nenhuma área nomeada, usa-se `.` (ponto) como placeholder:

```css
.dashboard {
  display: grid;
  grid-template-columns: 200px 1fr 1fr;
  grid-template-rows: 60px repeat(3, 1fr);
  grid-template-areas:
    "nav     header  header "
    "nav     card-a  card-b "
    "nav     card-c  .      "  /* última célula vazia */
    "nav     footer  footer ";
}
```

Múltiplos pontos na mesma célula (`...` ou `. . .`) também são válidos e equivalentes a um único ponto — alguns desenvolvedores usam múltiplos pontos para alinhar visualmente o mapa.

### 9.4.4 — Mudando o layout com media queries

Áreas nomeadas são especialmente poderosas para layouts responsivos — basta redefinir `grid-template-areas` em diferentes breakpoints:

```css
/* Layout padrão: desktop */
.pagina {
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-template-rows: 80px 1fr 60px;
  grid-template-areas:
    "header  header"
    "sidebar main  "
    "footer  footer";
  gap: 1rem;
}

/* Layout tablet: sidebar abaixo do conteúdo */
@media (max-width: 1024px) {
  .pagina {
    grid-template-columns: 1fr;
    grid-template-rows: 80px 1fr auto 60px;
    grid-template-areas:
      "header "
      "main   "
      "sidebar"
      "footer ";
  }
}

/* Layout mobile: coluna única, sidebar oculta */
@media (max-width: 600px) {
  .pagina {
    grid-template-columns: 1fr;
    grid-template-rows: 60px 1fr 60px;
    grid-template-areas:
      "header"
      "main  "
      "footer";
  }

  .barra-lateral {
    display: none;
  }
}

/* Os itens NÃO precisam ser alterados — apenas o container muda */
.cabecalho     { grid-area: header;  }
.barra-lateral { grid-area: sidebar; }
.conteudo      { grid-area: main;    }
.rodape        { grid-area: footer;  }
```

Esta é uma das vantagens mais significativas das áreas nomeadas: **os itens não precisam ser alterados nas media queries** — apenas o mapa do container é redesenhado. Isso torna layouts responsivos complexos muito mais fáceis de manter.

---

## 9.5 — Alinhamento no Grid

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O Grid compartilha o sistema de alinhamento do Flexbox, mas com uma camada adicional de controle: é possível alinhar tanto os **itens dentro de suas células** quanto a **grade inteira dentro do container**.

### 9.5.1 — `justify-items` e `align-items`

Estas propriedades controlam como os itens são alinhados **dentro de suas células**:

- `justify-items`: alinhamento no eixo **inline** (horizontal em escrita ocidental)
- `align-items`: alinhamento no eixo **block** (vertical)

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 200px);
  grid-template-rows: repeat(3, 150px);

  /* Padrão: stretch — itens preenchem a célula */
  justify-items: stretch;  /* padrão */
  align-items: stretch;    /* padrão */

  /* Centralizar todos os itens em suas células */
  justify-items: center;
  align-items: center;

  /* Outros valores */
  justify-items: start;
  justify-items: end;
  align-items: start;
  align-items: end;
  align-items: baseline;
}
```

```
justify-items: stretch (padrão)    justify-items: center
┌──────────────────┐               ┌──────────────────┐
│ ┌──────────────┐ │               │    ┌────────┐     │
│ │    item      │ │               │    │  item  │     │
│ └──────────────┘ │               │    └────────┘     │
└──────────────────┘               └──────────────────┘
  item preenche a célula             item centralizado
```

### 9.5.2 — `justify-content` e `align-content`

Quando a grade é menor que o container (quando as trilhas têm tamanho fixo e há espaço sobrando), estas propriedades controlam como a **grade como um todo** é posicionada no container:

```css
.container {
  display: grid;
  width: 900px;
  height: 600px;
  grid-template-columns: repeat(3, 200px); /* 3 × 200px = 600px < 900px */
  grid-template-rows: repeat(2, 150px);    /* 2 × 150px = 300px < 600px */

  /* Distribuir as colunas no espaço disponível */
  justify-content: center;
  justify-content: space-between;
  justify-content: space-evenly;
  justify-content: start;  /* padrão */
  justify-content: end;

  /* Distribuir as linhas no espaço disponível */
  align-content: center;
  align-content: space-between;
  align-content: end;
  align-content: start; /* padrão */
}
```

### 9.5.3 — `justify-self` e `align-self`

Sobrescrevem `justify-items` e `align-items` para um item específico:

```css
.item-especial {
  justify-self: end;    /* alinha à direita na célula */
  align-self: start;    /* alinha no topo da célula */
}

.item-centralizado {
  justify-self: center;
  align-self: center;
}

.item-esticado {
  justify-self: stretch; /* estica para preencher a célula */
  align-self: stretch;
}
```

### 9.5.4 — `place-items` e `place-content` — shorthands

```css
.container {
  /* place-items: align-items justify-items */
  place-items: center;          /* centraliza em ambos os eixos */
  place-items: start end;       /* align: start | justify: end */

  /* place-content: align-content justify-content */
  place-content: center;
  place-content: space-between center;

  /* place-self (em itens): align-self justify-self */
}

.item {
  place-self: center;           /* centraliza o item na célula */
}
```

**Centralização com Grid em duas linhas:**

```css
.container {
  display: grid;
  place-items: center;
  min-height: 100vh;
}
/* O filho direto é centralizado horizontal e verticalmente */
```

---

## 9.6 — Grid implícito e controle de fluxo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A **grade explícita** é a estrutura definida por `grid-template-columns`, `grid-template-rows` e `grid-template-areas`. Quando itens são posicionados fora dessa estrutura — seja por posicionamento explícito além dos limites ou por fluxo automático que ultrapassa as linhas definidas —, o navegador cria automaticamente uma **grade implícita** para acomodá-los.

### 9.6.1 — `grid-auto-rows` e `grid-auto-columns`

Controlam o tamanho das trilhas **criadas automaticamente** pelo grid implícito:

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  /* Apenas 1 linha explícita definida: 200px */
  grid-template-rows: 200px;

  /* Linhas adicionais (implícitas) criadas automaticamente */
  grid-auto-rows: 150px;
  /* Sem grid-auto-rows, as linhas implícitas teriam altura mínima pelo conteúdo */
}

/* Uso com minmax: linha implícita com altura mínima */
.container {
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: minmax(150px, auto);
  /* cada linha tem no mínimo 150px e cresce com o conteúdo */
}
```

`grid-auto-rows: minmax(150px, auto)` é um padrão muito utilizado em grades de cards: garante altura mínima consistente mas permite que o card cresça se o conteúdo for maior.

### 9.6.2 — `grid-auto-flow` — direção do fluxo automático

Controla como itens sem posicionamento explícito são colocados na grade:

```css
.container {
  grid-auto-flow: row;     /* padrão: preenche linha por linha */
  grid-auto-flow: column;  /* preenche coluna por coluna */
  grid-auto-flow: row dense;    /* linha por linha, preenchendo lacunas */
  grid-auto-flow: column dense; /* coluna por coluna, preenchendo lacunas */
}
```

Com `grid-auto-flow: column`, as trilhas implícitas criadas são **colunas** (não linhas), e `grid-auto-columns` controla seu tamanho:

```css
.container {
  display: grid;
  grid-template-rows: repeat(3, 100px);  /* 3 linhas fixas */
  grid-auto-flow: column;                /* itens fluem por colunas */
  grid-auto-columns: 150px;             /* colunas implícitas com 150px */
}
```

### 9.6.3 — `grid-auto-flow: dense` — preenchimento de lacunas

Quando alguns itens têm `span` maior que outros, podem surgir lacunas na grade. O valor `dense` instrui o algoritmo de posicionamento a tentar preencher essas lacunas com itens menores que venham depois:

```css
.galeria {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: 200px;
  grid-auto-flow: row dense; /* preenche lacunas com itens subsequentes */
  gap: 1rem;
}

.imagem-grande   { grid-column: span 2; grid-row: span 2; }
.imagem-larga    { grid-column: span 2; }
.imagem-alta     { grid-row: span 2; }
/* imagens normais não têm span */
```

```
Sem dense:              Com dense:
[G][G][ ][ ]           [G][G][A][B]
[G][G][A][ ]           [G][G][C][D]
[L][L][B][C]           [L][L][E][F]
   ↑ lacunas              ↑ lacunas preenchidas
```

> **⚠️ Atenção:** `dense` pode alterar a ordem visual dos itens em relação à ordem do DOM — itens menores podem "saltar" para posições anteriores para preencher lacunas. Assim como a propriedade `order` do Flexbox, isso pode criar problemas de acessibilidade quando a ordem de apresentação é semanticamente relevante.

---

## 9.7 — Padrões práticos de layout com Grid

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 9.7.1 — Layout de página completo

O padrão mais fundamental do CSS Grid: estrutura de página com header, sidebar, conteúdo principal e footer:

```html
<body class="pagina">
  <header class="cabecalho">
    <h1>IFAL — Programação Web 1</h1>
    <nav>...</nav>
  </header>

  <aside class="barra-lateral">
    <nav aria-label="Sumário">...</nav>
  </aside>

  <main class="conteudo-principal">
    <article>...</article>
  </main>

  <footer class="rodape">
    <p>© 2026 IFAL</p>
  </footer>
</body>
```

```css
.pagina {
  display: grid;
  grid-template-columns: 260px 1fr;
  grid-template-rows: 70px 1fr auto;
  grid-template-areas:
    "header  header"
    "sidebar main  "
    "footer  footer";
  min-height: 100vh;
  gap: 0; /* gaps gerenciados por padding nos itens */
}

.cabecalho     { grid-area: header;  background: var(--cor-primaria); }
.barra-lateral { grid-area: sidebar; background: var(--cor-fundo); }
.conteudo-principal { grid-area: main; padding: 2rem; }
.rodape        { grid-area: footer;  background: var(--cor-primaria); }

/* Responsivo */
@media (max-width: 768px) {
  .pagina {
    grid-template-columns: 1fr;
    grid-template-areas:
      "header"
      "main  "
      "footer";
  }

  .barra-lateral { display: none; }
}
```

### 9.7.2 — Grade de cards responsiva sem media queries

O padrão mais elegante do CSS Grid moderno: uma grade que se adapta completamente ao viewport sem uma única media query:

```html
<section class="grade-cards">
  <article class="card">...</article>
  <article class="card">...</article>
  <article class="card">...</article>
  <!-- quantos cards forem necessários -->
</section>
```

```css
.grade-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  padding: 2rem;
}

.card {
  display: flex;           /* card interno usa Flexbox */
  flex-direction: column;
  background: white;
  border-radius: var(--raio-borda);
  box-shadow: var(--sombra-md);
  overflow: hidden;
}

.card img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.card__corpo {
  flex: 1;
  padding: 1.5rem;
}

.card__rodape {
  padding: 1rem 1.5rem;
  border-top: 1px solid #eee;
}
```

Este padrão — `repeat(auto-fit, minmax(280px, 1fr))` — é um dos mais valiosos do CSS moderno. Ele resolve automaticamente: em viewports largos, muitas colunas; em viewports estreitos, menos colunas; em mobile, coluna única. Tudo sem uma linha de media query.

### 9.7.3 — Layout de revista (*magazine layout*)

Layouts editoriais com elementos de tamanhos variados e posicionamento preciso:

```html
<section class="revista">
  <article class="artigo artigo--destaque">Artigo principal</article>
  <article class="artigo artigo--secundario-a">Secundário A</article>
  <article class="artigo artigo--secundario-b">Secundário B</article>
  <article class="artigo artigo--pequeno-a">Pequeno A</article>
  <article class="artigo artigo--pequeno-b">Pequeno B</article>
  <article class="artigo artigo--pequeno-c">Pequeno C</article>
</section>
```

```css
.revista {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(3, 250px);
  gap: 1rem;
}

/* Artigo principal: ocupa 2 colunas e 2 linhas */
.artigo--destaque {
  grid-column: 1 / 3;
  grid-row: 1 / 3;
}

/* Secundários: uma coluna, duas linhas */
.artigo--secundario-a {
  grid-column: 3 / 4;
  grid-row: 1 / 3;
}

.artigo--secundario-b {
  grid-column: 4 / 5;
  grid-row: 1 / 3;
}

/* Pequenos: uma coluna, uma linha — fluxo automático na linha 3 */
/* (não precisam de posicionamento explícito) */
```

### 9.7.4 — Galeria de imagens com células de tamanho variado

Uma galeria onde algumas imagens são maiores, usando `auto-flow: dense` para preencher lacunas:

```css
.galeria {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  grid-auto-rows: 200px;
  grid-auto-flow: dense;
  gap: 0.5rem;
}

.galeria__item {
  overflow: hidden;
  border-radius: var(--raio-borda-sm);
}

.galeria__item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 300ms ease;
}

.galeria__item:hover img {
  transform: scale(1.05);
}

/* Imagens de destaque */
.galeria__item--largo  { grid-column: span 2; }
.galeria__item--alto   { grid-row: span 2; }
.galeria__item--grande { grid-column: span 2; grid-row: span 2; }
```

---

## 9.8 — Grid e acessibilidade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 9.8.1 — Ordem do DOM vs ordem visual no Grid

Assim como no Flexbox, o CSS Grid permite separar a ordem visual dos elementos da sua ordem no DOM — por meio de posicionamento explícito, `grid-auto-flow` e `order`. As mesmas implicações de acessibilidade se aplicam:

- **Leitores de tela** leem o conteúdo na ordem do DOM
- **Navegação por teclado** segue a ordem do DOM
- **Seleção de texto** segue a ordem do DOM

Portanto, qualquer reordenação visual que altere a sequência semântica do conteúdo viola o critério WCAG 2.1 **1.3.2 — Sequência com Significado (nível A)**.

```css
/* PROBLEMÁTICO: ordem visual desconectada do DOM */
.artigo-principal { grid-area: destaque; } /* visualmente primeiro */
.artigo-recente   { grid-area: topo; }     /* visualmente segundo */

/* No DOM, artigo-recente vem antes de artigo-principal —
   leitor de tela lê recente antes de principal */
```

### 9.8.2 — Boas práticas de reordenação responsiva

A reordenação por media queries com `grid-template-areas` é geralmente segura quando aplicada a componentes onde a ordem não é semanticamente crítica. A regra prática:

**Seguro:** reordenar componentes de layout estrutural (mover sidebar de baixo para o lado, por exemplo) quando ambas as posições fazem sentido para a leitura.

**Problemático:** reordenar conteúdo sequencial (etapas, artigos em ordem cronológica, listas de prioridade) onde a posição visual comunica importância ou sequência.

```css
/* SEGURO: sidebar pode estar em qualquer posição */
@media (max-width: 768px) {
  .pagina {
    grid-template-areas:
      "header"
      "main  "   /* main antes da sidebar em mobile */
      "sidebar"
      "footer";
  }
}
/* O conteúdo principal ainda faz sentido independente da posição da sidebar */

/* PROBLEMÁTICO: etapas reordenadas visualmente */
@media (max-width: 768px) {
  .processo {
    grid-template-areas:
      "etapa-3"  /* visualmente primeiro em mobile */
      "etapa-1"
      "etapa-2";
  }
}
/* Leitor de tela ainda lê etapa-1, etapa-2, etapa-3 na ordem do DOM */
```

**Solução quando a reordenação é inevitável:** reorganize o DOM para corresponder à ordem de leitura desejada e use Grid para a apresentação visual em desktop — não o contrário.

**Referências:**
- [MDN — CSS Grid Layout](https://developer.mozilla.org/pt-BR/docs/Web/CSS/CSS_grid_layout)
- [W3C — CSS Grid Layout Module Level 1](https://www.w3.org/TR/css-grid-1/)
- [CSS Tricks — A Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/)
- [Grid Garden — exercício interativo](https://cssgridgarden.com/#pt-br)
- [Layout Land — Jen Simmons (YouTube)](https://www.youtube.com/@LayoutLand)

---

#### **Atividades — Capítulo 9**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Uma grade tem <code>grid-template-columns: repeat(3, 1fr)</code> em um container de 900px com <code>gap: 30px</code>. Qual é a largura de cada coluna?</p>
  <button data-option="a">300px — o espaço é dividido igualmente sem considerar os gaps.</button>
  <button data-option="b">270px — 900px divididos por 3 colunas e 3 gaps.</button>
  <button data-option="c">280px — (900px - 2 × 30px) ÷ 3 = 840px ÷ 3 = 280px por coluna.</button>
  <button data-option="d">290px — gaps são absorvidos proporcionalmente pelas colunas.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Qual é a diferença prática entre <code>auto-fill</code> e <code>auto-fit</code> em <code>repeat(auto-fill/auto-fit, minmax(200px, 1fr))</code>?</p>
  <button data-option="a">Não há diferença funcional — os dois são sinônimos.</button>
  <button data-option="b"><code>auto-fill</code> mantém colunas vazias quando há poucos itens; <code>auto-fit</code> colapsa as colunas vazias, fazendo os itens existentes expandirem para preencher o espaço.</button>
  <button data-option="c"><code>auto-fit</code> cria mais colunas que <code>auto-fill</code> para o mesmo tamanho de container.</button>
  <button data-option="d"><code>auto-fill</code> só funciona com <code>fr</code>; <code>auto-fit</code> funciona com qualquer unidade.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Por que o uso de <code>grid-auto-flow: dense</code> pode criar problemas de acessibilidade?</p>
  <button data-option="a">Porque <code>dense</code> remove itens da grade para preencher lacunas.</button>
  <button data-option="b">Porque <code>dense</code> altera o tamanho das células, quebrando o layout.</button>
  <button data-option="c">Porque <code>dense</code> não é suportado por leitores de tela.</button>
  <button data-option="d">Porque <code>dense</code> pode reordenar visualmente itens em relação à ordem do DOM — itens menores "saltam" para posições anteriores, criando divergência entre a ordem visual e a ordem de leitura dos leitores de tela.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> Qual é a vantagem de usar <code>grid-template-areas</code> com media queries em vez de redefinir <code>grid-column</code> e <code>grid-row</code> nos itens?</p>
  <button data-option="a">Os itens não precisam ser modificados nas media queries — apenas o mapa do container é redefinido, centralizando toda a lógica de layout no container e tornando o CSS mais fácil de manter.</button>
  <button data-option="b">Áreas nomeadas têm melhor desempenho de renderização que posicionamento por linhas.</button>
  <button data-option="c">Áreas nomeadas permitem criar layouts não retangulares que linhas e colunas não suportam.</button>
  <button data-option="d">Media queries não funcionam com <code>grid-column</code> e <code>grid-row</code>.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir uma página de dashboard com: (1) layout de página completo usando `grid-template-areas` com responsividade para mobile via media query; (2) grade de cards responsiva com `auto-fit` + `minmax()` sem media queries; (3) seção de destaque com posicionamento explícito por linhas (`grid-column: span`). *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 8 — Layout com Flexbox](08-flexbox.md)
[:material-arrow-right: Ir ao Capítulo 10 — Design Responsivo](10-responsivo.md)
