# Capítulo 8 — Layout com Flexbox

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 8.1 — O que é Flexbox e quando usar

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **Flexbox** (*Flexible Box Layout Module*) é um modelo de layout CSS projetado para distribuir espaço e alinhar elementos em **uma dimensão** — uma linha ou uma coluna. Introduzido como recomendação pelo W3C em 2012 e amplamente suportado desde 2015, o Flexbox resolveu um problema que afligia desenvolvedores web há quase duas décadas: a ausência de um mecanismo declarativo e previsível para alinhar e distribuir elementos em um container.

### 8.1.1 — O problema que o Flexbox resolve

Antes do Flexbox, criar layouts que pareciam simples — centralizar verticalmente um elemento, fazer colunas de altura igual, distribuir itens uniformemente em uma barra de navegação — exigia combinações frágeis e contraintuitivas de propriedades CSS que não foram projetadas para layout:

```css
/* Era do pré-Flexbox: hacks para centralização vertical */

/* Hack 1: tabela (semanticamente incorreto) */
.container { display: table; }
.filho { display: table-cell; vertical-align: middle; }

/* Hack 2: posicionamento absoluto (inflexível) */
.filho {
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -50px;  /* metade da altura — valor hardcoded */
  margin-left: -100px; /* metade da largura — valor hardcoded */
}

/* Hack 3: floats (requer clearfix, quebra o fluxo) */
.coluna { float: left; width: 33.33%; }
.container::after { content: ""; display: table; clear: both; }
```

Esses padrões funcionavam em casos específicos, mas quebravam ao mudar o tamanho do container, adicionar conteúdo dinâmico ou adaptar para diferentes viewports. O Flexbox substituiu todos esses hacks por um modelo coerente e expressivo:

```css
/* Flexbox: centralização vertical e horizontal em duas linhas */
.container {
  display: flex;
  justify-content: center;
  align-items: center;
}
```

### 8.1.2 — Conceito de container e itens

O Flexbox opera em dois níveis hierárquicos:

- **Flex container:** o elemento ao qual `display: flex` é aplicado. Ele define o contexto flex e controla como seus filhos diretos são distribuídos.
- **Flex items:** os **filhos diretos** do flex container. Eles são os elementos que recebem e respondem às regras de layout flex.

```html
<nav class="navbar">          <!-- flex container -->
  <a href="/">Logo</a>        <!-- flex item -->
  <a href="/sobre">Sobre</a>  <!-- flex item -->
  <a href="/contato">Contato</a> <!-- flex item -->
</nav>
```

```css
.navbar {
  display: flex; /* transforma .navbar em flex container */
  /* Os filhos diretos (<a>) tornam-se automaticamente flex items */
}
```

> **Ponto crítico:** apenas os **filhos diretos** do container se tornam flex items. Descendentes mais profundos não são afetados diretamente pelo contexto flex do container pai — a menos que eles próprios também sejam declarados como flex containers.

### 8.1.3 — Quando usar Flexbox vs Grid

Flexbox e Grid são complementares, não concorrentes. A escolha entre eles segue um princípio simples:

| | Flexbox | Grid |
|---|---|---|
| **Dimensionalidade** | Uma dimensão (linha **ou** coluna) | Duas dimensões (linhas **e** colunas) |
| **Controle** | A partir do conteúdo (content-first) | A partir do layout (layout-first) |
| **Melhor para** | Componentes: navbars, cards, forms, botões | Estruturas de página: grids de conteúdo, layouts completos |

A heurística prática: se você está distribuindo itens em uma **única direção** — uma linha de botões, uma lista de cards, uma barra de navegação —, Flexbox é a escolha natural. Se você precisa alinhar elementos em **linhas e colunas simultaneamente** — uma grade de artigos, um layout de página com header/sidebar/main/footer —, Grid é mais adequado. Na prática, a maioria dos projetos usa ambos: Grid para a estrutura macro da página, Flexbox para os componentes internos.

> **Referência:** [MDN — Flexbox](https://developer.mozilla.org/pt-BR/docs/Learn/CSS/CSS_layout/Flexbox)

---

## 8.2 — Os dois eixos do Flexbox

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O modelo mental mais importante para dominar o Flexbox é a compreensão dos dois eixos que governam todo o sistema de alinhamento.

### 8.2.1 — Eixo principal (*main axis*)

O **eixo principal** é a direção ao longo da qual os flex items são distribuídos. Por padrão, ele corre horizontalmente da esquerda para a direita. As propriedades de alinhamento que atuam sobre o eixo principal são `justify-content` (no container) e `justify-self` (nos itens, com suporte limitado no Flexbox).

```
Eixo principal padrão (flex-direction: row):

←────────────────────────────────────────→
[  Item 1  ] [  Item 2  ] [  Item 3  ]
```

### 8.2.2 — Eixo cruzado (*cross axis*)

O **eixo cruzado** é sempre perpendicular ao eixo principal. Por padrão, ele corre verticalmente de cima para baixo. As propriedades que atuam sobre o eixo cruzado são `align-items` e `align-content` (no container) e `align-self` (nos itens).

```
Eixo cruzado padrão (flex-direction: row):

↑
│  [  Item 1  ] [  Item 2  ] [  Item 3  ]
│
↓
```

### 8.2.3 — Como `flex-direction` muda os eixos

A propriedade `flex-direction` define a direção do eixo principal — e consequentemente do eixo cruzado. Esta é a propriedade mais fundamental do Flexbox, pois redefine o significado de todas as outras propriedades de alinhamento:

```css
/* row (padrão): eixo principal → horizontal (esquerda para direita) */
.container { flex-direction: row; }

/* row-reverse: eixo principal → horizontal (direita para esquerda) */
.container { flex-direction: row-reverse; }

/* column: eixo principal → vertical (cima para baixo) */
.container { flex-direction: column; }

/* column-reverse: eixo principal → vertical (baixo para cima) */
.container { flex-direction: column-reverse; }
```

```
flex-direction: row          flex-direction: column
────────────────────         ─────────────────────
→  [1] [2] [3]               ↓  [1]
   eixo principal: →              [2]
   eixo cruzado: ↓               [3]
                                  eixo principal: ↓
                                  eixo cruzado: →
```

> **Imagem sugerida:** diagrama visual dos quatro valores de `flex-direction` mostrando a orientação dos eixos principal e cruzado em cada caso, com os itens numerados dispostos de acordo.
>
> *(imagem será adicionada posteriormente)*

A compreensão de que `justify-content` atua **sempre sobre o eixo principal** e `align-items` atua **sempre sobre o eixo cruzado** — independentemente de qual seja qual — é o que permite usar Flexbox com previsibilidade. Muita confusão com Flexbox vem de pensar em termos de "horizontal/vertical" em vez de "eixo principal/cruzado".

---

## 8.3 — Propriedades do container flex

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 8.3.1 — `display: flex` e `display: inline-flex`

```css
/* flex: o container se comporta como bloco (ocupa toda a largura) */
.container {
  display: flex;
}

/* inline-flex: o container se comporta como inline-block */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}
```

A distinção é sobre o comportamento **externo** do container — como ele se relaciona com o fluxo do documento ao redor. Internamente, os dois se comportam de forma idêntica para os flex items.

### 8.3.2 — `flex-direction`

Já apresentado na seção 8.2.3. Recapitulando os quatro valores:

```css
.container {
  flex-direction: row;            /* padrão */
  flex-direction: row-reverse;
  flex-direction: column;
  flex-direction: column-reverse;
}
```

**Caso de uso prático de `column`:** componentes de card com conteúdo empilhado verticalmente, layouts mobile-first que empilham elementos, sidebars de navegação vertical.

### 8.3.3 — `flex-wrap`

Por padrão, flex items não quebram linha — eles encolhem para caber no container mesmo que isso os torne menores do que seu tamanho ideal. `flex-wrap` controla esse comportamento:

```css
.container {
  flex-wrap: nowrap;  /* padrão: todos na mesma linha, encolhem se necessário */
  flex-wrap: wrap;    /* quebra para a próxima linha quando necessário */
  flex-wrap: wrap-reverse; /* quebra para linha acima */
}
```

```
flex-wrap: nowrap (padrão):
[  Item 1  ][  Item 2  ][  Item 3  ][  Item 4  ][  Item 5  ]
↑ itens encolhem para caber

flex-wrap: wrap:
[  Item 1  ][  Item 2  ][  Item 3  ]
[  Item 4  ][  Item 5  ]
↑ itens quebram para a próxima linha
```

`flex-wrap: wrap` é fundamental para layouts responsivos com Flexbox — permite que itens se reorganizem naturalmente em telas menores sem media queries.

### 8.3.4 — `flex-flow` — shorthand

`flex-flow` combina `flex-direction` e `flex-wrap` em uma única declaração:

```css
.container {
  flex-flow: row wrap;        /* direção + quebra */
  flex-flow: column nowrap;
  flex-flow: row-reverse wrap;
}
```

### 8.3.5 — `justify-content` — alinhamento no eixo principal

`justify-content` define como os flex items são distribuídos ao longo do **eixo principal** quando há espaço sobrando:

```css
.container {
  justify-content: flex-start;    /* padrão: itens no início */
  justify-content: flex-end;      /* itens no final */
  justify-content: center;        /* itens centralizados */
  justify-content: space-between; /* espaço igual ENTRE os itens */
  justify-content: space-around;  /* espaço igual AO REDOR de cada item */
  justify-content: space-evenly;  /* espaço igual entre todos, incluindo bordas */
}
```

```
justify-content: flex-start
[1][2][3]_ _ _ _ _ _

justify-content: flex-end
_ _ _ _ _ _[1][2][3]

justify-content: center
_ _ _[1][2][3]_ _ _

justify-content: space-between
[1]_ _ _ _[2]_ _ _ _[3]

justify-content: space-around
_ [1] _ _ [2] _ _ [3] _
  ←→     ←→     ←→
  (espaço dobrado entre itens)

justify-content: space-evenly
_ _[1]_ _[2]_ _[3]_ _
←→  ←→  ←→  ←→
(espaço idêntico em todos os gaps)
```

> **No DevTools:** no painel **Elements**, ao selecionar um flex container, o Chrome exibe um ícone de grade ao lado de `display: flex` na aba **Styles**. Clicando nele, abre um editor visual interativo de Flexbox que permite testar todos os valores de `justify-content` e `align-items` em tempo real — uma ferramenta essencial para entender o comportamento de cada valor.

### 8.3.6 — `align-items` — alinhamento no eixo cruzado

`align-items` define como os flex items são alinhados ao longo do **eixo cruzado**:

```css
.container {
  align-items: stretch;     /* padrão: itens se esticam para preencher o container */
  align-items: flex-start;  /* itens alinhados no início do eixo cruzado */
  align-items: flex-end;    /* itens alinhados no final do eixo cruzado */
  align-items: center;      /* itens centralizados no eixo cruzado */
  align-items: baseline;    /* itens alinhados pela linha de base do texto */
}
```

```
align-items: stretch (padrão)    align-items: center
┌──────────────────────┐         ┌──────────────────────┐
│ ┌────┐ ┌──────┐ ┌──┐ │         │      ┌────┐           │
│ │    │ │      │ │  │ │         │      │    │  ┌──────┐ │
│ │ 1  │ │  2   │ │3 │ │         │      │ 1  │  │  2   │ │
│ │    │ │      │ │  │ │         │      │    │  └──────┘ │
│ └────┘ └──────┘ └──┘ │         │      └────┘  ┌──┐    │
└──────────────────────┘         │              │3 │    │
  itens esticam na altura do      │              └──┘    │
  container                      └──────────────────────┘
                                   itens centralizados
```

**`baseline`** é especialmente útil quando itens têm fontes de tamanhos diferentes e precisam ser alinhados pelo texto:

```css
.toolbar {
  display: flex;
  align-items: baseline; /* alinha pelo texto de cada item */
}
```

### 8.3.7 — `align-content` — alinhamento de múltiplas linhas

`align-content` só tem efeito quando `flex-wrap: wrap` está ativo **e** há múltiplas linhas de flex items. Ele controla a distribuição das **linhas** no eixo cruzado — análogo ao `justify-content`, mas para linhas em vez de itens:

```css
.container {
  flex-wrap: wrap;
  align-content: flex-start;    /* linhas no início */
  align-content: flex-end;      /* linhas no final */
  align-content: center;        /* linhas centralizadas */
  align-content: space-between; /* espaço igual entre linhas */
  align-content: space-around;  /* espaço ao redor das linhas */
  align-content: stretch;       /* padrão: linhas se esticam */
}
```

> **Confusão comum:** `align-items` alinha os **itens** dentro de cada linha; `align-content` distribui as **linhas** no container. Em containers de linha única, `align-content` não tem efeito.

### 8.3.8 — `gap`, `row-gap` e `column-gap`

A propriedade `gap` define o espaçamento entre flex items sem usar margins — o que evita o problema clássico de "margem na última coluna":

```css
.container {
  display: flex;
  gap: 1rem;              /* espaçamento igual em todos os eixos */
  gap: 1rem 2rem;         /* row-gap | column-gap */
  row-gap: 1rem;          /* apenas entre linhas */
  column-gap: 2rem;       /* apenas entre colunas */
}
```

```
Sem gap (usando margin):             Com gap:
[1][margin][2][margin][3][margin]    [1][gap][2][gap][3]
                        ↑                              ↑
            margem indesejada             sem margem extra
            no último item
```

`gap` é a forma recomendada de criar espaçamento em layouts flex modernos — mais semântico e menos propenso a erros do que margins nos itens.

---

## 8.4 — Propriedades dos itens flex

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

As propriedades dos itens controlam como cada flex item individualmente cresce, encolhe e se posiciona dentro do container.

### 8.4.1 — `flex-grow` — capacidade de crescimento

`flex-grow` define a **proporção** na qual um item pode crescer para ocupar o espaço disponível no container. O valor padrão é `0` — os itens não crescem além de seu tamanho base:

```css
/* Três itens: apenas o segundo cresce */
.item-1 { flex-grow: 0; } /* não cresce */
.item-2 { flex-grow: 1; } /* ocupa todo o espaço disponível */
.item-3 { flex-grow: 0; } /* não cresce */

/* Dois itens com crescimento proporcional */
.item-principal { flex-grow: 2; } /* recebe 2/3 do espaço disponível */
.item-lateral   { flex-grow: 1; } /* recebe 1/3 do espaço disponível */
```

```
Container: 900px | Item 1: 100px base | Item 2: 100px base | Item 3: 100px base
Espaço disponível: 900 - 300 = 600px

flex-grow: 0, 1, 0:
[100px][   700px (100+600)   ][100px]

flex-grow: 1, 1, 1:
[  300px  ][  300px  ][  300px  ]
(600px divididos igualmente entre os três)
```

### 8.4.2 — `flex-shrink` — capacidade de encolhimento

`flex-shrink` define a proporção na qual um item pode **encolher** quando o espaço é insuficiente. O valor padrão é `1` — todos os itens encolhem proporcionalmente:

```css
.item-fixo    { flex-shrink: 0; } /* não encolhe — mantém tamanho base */
.item-flexivel { flex-shrink: 1; } /* encolhe normalmente (padrão) */
.item-rapido  { flex-shrink: 3; } /* encolhe 3x mais rápido que os outros */
```

**Caso de uso comum:** um ícone ou logo em uma navbar que não deve encolher, enquanto o restante dos itens se adapta:

```css
.navbar-logo {
  flex-shrink: 0; /* logo nunca encolhe */
  width: 120px;
}

.navbar-links {
  flex-shrink: 1; /* links podem encolher */
}
```

### 8.4.3 — `flex-basis` — tamanho base

`flex-basis` define o **tamanho inicial** de um item antes de `flex-grow` e `flex-shrink` serem aplicados. Funciona como `width` (em `flex-direction: row`) ou como `height` (em `flex-direction: column`):

```css
.item {
  flex-basis: auto;    /* padrão: usa width/height do item */
  flex-basis: 0;       /* tamanho inicial zero — cresce a partir do zero */
  flex-basis: 200px;   /* tamanho base fixo de 200px */
  flex-basis: 33.33%;  /* tamanho base de 1/3 do container */
}
```

**`flex-basis: 0` vs `flex-basis: auto`:** quando `flex-basis: 0`, o espaço disponível é distribuído proporcionalmente sem considerar o conteúdo dos itens. Com `flex-basis: auto`, o conteúdo é considerado antes da distribuição.

### 8.4.4 — `flex` — shorthand e valores comuns

O shorthand `flex` combina `flex-grow`, `flex-shrink` e `flex-basis`:

```css
.item {
  flex: <grow> <shrink> <basis>;

  flex: 1;          /* flex: 1 1 0% — cresce, encolhe, base zero */
  flex: auto;       /* flex: 1 1 auto — cresce, encolhe, base automática */
  flex: none;       /* flex: 0 0 auto — não cresce, não encolhe */
  flex: 0 auto;     /* flex: 0 1 auto — não cresce, encolhe */
  flex: 2 1 300px;  /* cresce 2x, encolhe 1x, base 300px */
}
```

**Os valores mais utilizados na prática:**

```css
/* flex: 1 — o item mais comum: cresce proporcionalmente */
.coluna { flex: 1; }

/* Colunas com proporções diferentes */
.coluna-principal { flex: 2; } /* ocupa 2/3 */
.coluna-lateral   { flex: 1; } /* ocupa 1/3 */

/* flex: none — item com tamanho fixo, não se adapta */
.sidebar-fixa { flex: none; width: 250px; }

/* flex: 0 0 auto — equivalente ao none */
.logo { flex: 0 0 auto; }
```

> **Boa prática:** prefira o shorthand `flex` às propriedades individuais `flex-grow`, `flex-shrink` e `flex-basis`. O shorthand define valores padrão inteligentes para os componentes não especificados — por exemplo, `flex: 1` define `flex-basis: 0%`, que geralmente é o comportamento desejado.

### 8.4.5 — `align-self` — alinhamento individual

`align-self` sobrescreve o `align-items` do container para um item específico. Aceita os mesmos valores de `align-items`:

```css
.container {
  display: flex;
  align-items: center; /* todos os itens centralizados por padrão */
}

.item-topo {
  align-self: flex-start; /* este item se alinha no topo */
}

.item-base {
  align-self: flex-end; /* este item se alinha na base */
}

.item-esticado {
  align-self: stretch; /* este item se estica para preencher */
}
```

### 8.4.6 — `order` — reordenação visual

`order` controla a ordem visual dos flex items sem alterar a ordem no HTML. O valor padrão é `0`; valores menores aparecem primeiro, valores maiores aparecem depois:

```css
.item-a { order: 2; }  /* aparece por último */
.item-b { order: -1; } /* aparece antes de todos (ordem 0) */
.item-c { order: 1; }  /* aparece segundo */

/* HTML: A, B, C → Visual: B(-1), A(0→padrão não declarado), C(1), A(2)... */
/* Na prática: B, C, A */
```

**Caso de uso legítimo:** reordenar elementos em diferentes breakpoints para responsividade — por exemplo, mover uma barra lateral para antes do conteúdo principal em mobile:

```css
@media (max-width: 768px) {
  .sidebar   { order: -1; } /* sobe para antes do main em mobile */
  .conteudo  { order: 1; }
}
```

> **⚠️ Atenção crítica — ver seção 8.6:** `order` altera apenas a apresentação visual — a ordem de leitura dos leitores de tela e a navegação por teclado seguem a **ordem do DOM**. Usar `order` para reordenar conteúdo semanticamente importante cria uma experiência inacessível para usuários de tecnologias assistivas.

---

## 8.5 — Padrões práticos de layout com Flexbox

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Compreender as propriedades do Flexbox isoladamente não é suficiente — a habilidade real está em combiná-las para resolver problemas concretos de layout. Esta seção apresenta os padrões mais frequentes no desenvolvimento web moderno.

### 8.5.1 — Navbar responsiva

Uma barra de navegação com logo à esquerda e links à direita é um dos layouts mais comuns da Web, e um dos que mais se beneficiam do Flexbox:

```html
<header class="navbar">
  <a href="/" class="navbar__logo">
    <img src="logo.svg" alt="IFAL" />
  </a>
  <nav class="navbar__links">
    <a href="/">Início</a>
    <a href="/cursos">Cursos</a>
    <a href="/sobre">Sobre</a>
    <a href="/contato">Contato</a>
  </nav>
</header>
```

```css
.navbar {
  display: flex;
  justify-content: space-between; /* logo esquerda, links direita */
  align-items: center;            /* centraliza verticalmente */
  padding: 1rem 2rem;
  background-color: var(--cor-primaria);
}

.navbar__logo img {
  height: 40px;
  flex-shrink: 0; /* logo não encolhe */
}

.navbar__links {
  display: flex;   /* os links também são um flex container */
  gap: 2rem;
  align-items: center;
}

.navbar__links a {
  color: white;
  text-decoration: none;
  font-size: 0.95rem;
}

/* Responsividade: empilha em mobile */
@media (max-width: 768px) {
  .navbar {
    flex-direction: column;
    gap: 1rem;
  }

  .navbar__links {
    gap: 1rem;
  }
}
```

### 8.5.2 — Centralização perfeita

Centralizar um elemento tanto horizontal quanto verticalmente foi historicamente um dos problemas mais difíceis do CSS. Com Flexbox, torna-se trivial:

```css
/* Centralização no container */
.container-centralizado {
  display: flex;
  justify-content: center; /* eixo principal: horizontal */
  align-items: center;     /* eixo cruzado: vertical */
  min-height: 100vh;       /* ou qualquer altura definida */
}

/* Centralização de um único item usando margin: auto */
.item-centralizado {
  margin: auto;
  /* margin: auto em flex items absorve todo o espaço disponível
     em todas as direções — centralizando o item */
}
```

**`margin: auto` em flex items** é uma técnica poderosa e menos conhecida: quando aplicada a um flex item, a margem `auto` absorve todo o espaço disponível na direção correspondente:

```css
.navbar {
  display: flex;
  align-items: center;
  padding: 0 2rem;
}

.navbar__logo { margin-right: auto; } /* empurra tudo para a direita */

/* Resultado: logo à esquerda, demais itens à direita */
/* sem usar justify-content: space-between */
```

### 8.5.3 — Cards em linha com altura igual

Um dos problemas clássicos do layout web é garantir que cards em linha tenham a mesma altura, independentemente do tamanho do conteúdo interno:

```html
<section class="cards">
  <article class="card">
    <img src="img1.jpg" alt="..." />
    <div class="card__corpo">
      <h2>Título curto</h2>
      <p>Descrição breve.</p>
    </div>
    <footer class="card__rodape">
      <a href="#">Saiba mais</a>
    </footer>
  </article>

  <article class="card">
    <img src="img2.jpg" alt="..." />
    <div class="card__corpo">
      <h2>Título mais longo que o anterior</h2>
      <p>Descrição bem mais longa que ocupa mais linhas de texto.</p>
    </div>
    <footer class="card__rodape">
      <a href="#">Saiba mais</a>
    </footer>
  </article>
</section>
```

```css
/* Container de cards */
.cards {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
}

/* Cada card: flex container em coluna */
.card {
  display: flex;
  flex-direction: column; /* empilha conteúdo verticalmente */
  flex: 1 1 280px;        /* cresce, encolhe, mínimo de 280px */
  border-radius: var(--raio-borda);
  box-shadow: var(--sombra-md);
  overflow: hidden;
}

.card img {
  width: 100%;
  height: 200px;
  object-fit: cover; /* corta a imagem para preencher o espaço */
}

.card__corpo {
  flex: 1; /* ocupa todo o espaço disponível — empurra o rodapé para baixo */
  padding: 1.5rem;
}

/* O rodapé fica sempre na base do card, independente do conteúdo */
.card__rodape {
  padding: 1rem 1.5rem;
  border-top: 1px solid #eee;
}
```

O segredo deste padrão é `flex: 1` no `.card__corpo`: ele faz com que o corpo do card ocupe todo o espaço vertical disponível, independentemente do tamanho do conteúdo — o que empurra o rodapé para a base de todos os cards de forma igual.

### 8.5.4 — Footer grudado no rodapé (*sticky footer*)

Um problema clássico: o footer deve ficar na base da viewport em páginas com pouco conteúdo, e após o conteúdo em páginas longas:

```html
<body>
  <header>...</header>
  <main>...</main>
  <footer>...</footer>
</body>
```

```css
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh; /* body ocupa pelo menos toda a altura da tela */
}

main {
  flex: 1; /* main cresce para ocupar todo o espaço disponível */
  /* header e footer ficam com seu tamanho natural */
  /* footer é empurrado para o final */
}
```

Este é um dos padrões mais elegantes do Flexbox: três linhas de CSS resolvem um problema que antes exigia posicionamento absoluto ou cálculos com `calc()`.

### 8.5.5 — Layout de formulário com labels e inputs alinhados

```html
<form class="formulario">
  <div class="campo">
    <label for="nome">Nome:</label>
    <input type="text" id="nome" name="nome" />
  </div>
  <div class="campo">
    <label for="email">E-mail:</label>
    <input type="email" id="email" name="email" />
  </div>
  <div class="acoes">
    <button type="reset">Limpar</button>
    <button type="submit">Enviar</button>
  </div>
</form>
```

```css
.formulario {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  max-width: 500px;
}

/* Cada campo: label + input lado a lado */
.campo {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.campo label {
  flex: 0 0 100px;  /* largura fixa: não cresce, não encolhe */
  text-align: right;
  font-weight: 600;
}

.campo input {
  flex: 1; /* input ocupa todo o espaço restante */
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

/* Botões de ação alinhados à direita */
.acoes {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
}
```

---

## 8.6 — Flexbox e acessibilidade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O Flexbox introduz uma capacidade que, mal utilizada, cria problemas sérios de acessibilidade: a possibilidade de **separar a ordem visual dos elementos da sua ordem no DOM**.

### 8.6.1 — A propriedade `order` e a ordem de leitura

A especificação CSS deixa claro: propriedades como `order` e `flex-direction: row-reverse` afetam apenas a **apresentação visual**. A ordem em que os elementos aparecem no DOM continua sendo a ordem utilizada por:

- **Leitores de tela** (NVDA, JAWS, VoiceOver) ao ler o conteúdo sequencialmente
- **Navegação por teclado** ao avançar pelo `Tab`
- **Seleção de texto** ao arrastar o cursor
- **Mecanismos de busca** ao indexar o conteúdo

Isso significa que se você usa `order` para apresentar visualmente o elemento B antes do elemento A, um usuário de leitor de tela ouvirá A antes de B — criando uma experiência desconexada entre o que é visto e o que é ouvido.

```css
/* PROBLEMÁTICO: reordenação que cria desconexão semântica */
.card-destaque { order: -1; } /* aparece visualmente primeiro */
/* mas no DOM ainda é o terceiro elemento — leitor de tela lê por último */
```

### 8.6.2 — Reordenação visual vs ordem do DOM

A regra é direta: **se a ordem visual importa para a compreensão do conteúdo, ela deve ser refletida na ordem do DOM**.

`order` e reordenação por Flexbox são aceitáveis quando:

- A reordenação é puramente estética (ex.: mover um elemento decorativo)
- O conteúdo faz sentido em qualquer ordem (ex.: uma galeria de imagens independentes)
- A reordenação é aplicada apenas para efeitos visuais em viewports específicos onde a lógica de leitura não muda

`order` e reordenação por Flexbox **não são aceitáveis** quando:

- A ordem dos elementos é parte do significado do conteúdo (ex.: etapas de um processo, hierarquia de informação)
- O elemento reordenado é interativo (link, botão, campo) — a navegação por teclado seguirá a ordem do DOM

```css
/* USO ACEITÁVEL: reordenação estética em galeria */
.galeria__destaque {
  order: -1; /* imagem de destaque aparece primeiro visualmente */
  /* todas as imagens são equivalentes — qualquer ordem faz sentido */
}

/* USO PROBLEMÁTICO: reordenação de conteúdo sequencial */
.passo-3 { order: 1; } /* Passo 3 aparece visualmente antes do Passo 1 */
.passo-1 { order: 2; } /* leitor de tela lê na ordem do DOM: 3, 1, 2 */
.passo-2 { order: 3; } /* confuso para usuários de tecnologia assistiva */

/* SOLUÇÃO: reorganize o DOM, não a apresentação visual */
```

> **A diretriz WCAG 2.1 relevante é o critério de sucesso 1.3.2 — Sequência com Significado (nível A):** "Se a sequência em que o conteúdo é apresentado afeta seu significado, uma sequência de leitura correta pode ser determinada programaticamente."

**Referências:**
- [MDN — Flexbox e acessibilidade](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_flexible_box_layout/Relationship_of_flexbox_to_other_layout_methods#flexbox_and_accessibility)
- [W3C — CSS Flexible Box Layout Module Level 1](https://www.w3.org/TR/css-flexbox-1/)
- [CSS Tricks — A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
- [Flexbox Froggy — exercício interativo](https://flexboxfroggy.com/#pt-br)

---

#### **Atividades — Capítulo 8**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Em um flex container com <code>flex-direction: column</code>, qual propriedade controla o alinhamento horizontal dos itens?</p>
  <button data-option="a"><code>justify-content</code> — pois controla o eixo horizontal.</button>
  <button data-option="b"><code>align-items</code> — pois com <code>flex-direction: column</code> o eixo cruzado é o horizontal.</button>
  <button data-option="c"><code>align-content</code> — pois é a propriedade responsável por alinhamento transversal.</button>
  <button data-option="d">Não é possível controlar o alinhamento horizontal com <code>flex-direction: column</code>.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Três flex items têm <code>flex-grow: 1</code>, <code>flex-grow: 2</code> e <code>flex-grow: 1</code>, respectivamente. O container tem 200px de espaço disponível após o tamanho base dos itens. Quanto espaço cada item recebe?</p>
  <button data-option="a">66px, 66px, 66px — o espaço é dividido igualmente.</button>
  <button data-option="b">100px, 100px, 0px — apenas os dois primeiros crescem.</button>
  <button data-option="c">50px, 100px, 50px — proporções 1:2:1 do espaço disponível.</button>
  <button data-option="d">200px, 0px, 0px — o primeiro item com flex-grow recebe tudo.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Por que o uso de <code>order</code> para reordenar conteúdo semanticamente sequencial (como etapas de um processo) é considerado uma falha de acessibilidade?</p>
  <button data-option="a">Porque <code>order</code> não funciona em navegadores que não suportam Flexbox.</button>
  <button data-option="b">Porque <code>order</code> afeta também a ordem de renderização no servidor.</button>
  <button data-option="c">Porque <code>order</code> muda a ordem dos elementos no DOM, confundindo o CSS subsequente.</button>
  <button data-option="d">Porque <code>order</code> altera apenas a apresentação visual — leitores de tela e navegação por teclado seguem a ordem do DOM, criando uma experiência desconexada para usuários de tecnologias assistivas.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir uma página com: (1) navbar com logo e links usando Flexbox; (2) seção de cards responsivos com altura igual e footer sempre na base; (3) sticky footer aplicado ao `<body>`. Todos os layouts devem usar apenas Flexbox, sem `float` ou `position` para estrutura. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 7 — Fundamentos do CSS](07-css-fundamentos.md)
[:material-arrow-right: Ir ao Capítulo 9 — Layout com Grid](09-grid.md)
