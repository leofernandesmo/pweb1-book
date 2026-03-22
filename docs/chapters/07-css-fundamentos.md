# Capítulo 7 — Fundamentos do CSS

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 7.1 — O papel do CSS na Web

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **CSS** (*Cascading Style Sheets* — Folhas de Estilo em Cascata) é a linguagem responsável pela **apresentação visual** de documentos HTML na Web. Enquanto o HTML define a estrutura e o significado do conteúdo — o que cada elemento *é* —, o CSS define como esse conteúdo *aparece*: cores, tipografia, espaçamento, dimensões, posicionamento, animações e a disposição geral dos elementos na tela.

A separação entre HTML e CSS não é apenas uma convenção de organização: é um princípio arquitetural fundamental da Web. Antes do CSS, atributos de apresentação eram declarados diretamente no HTML — elementos como `<font>`, `<center>` e `<bgcolor>` misturavam estrutura e aparência de forma indissociável, tornando os documentos difíceis de manter e impossíveis de reutilizar visualmente. O CSS resolveu esse problema ao centralizar todas as decisões visuais em uma camada separada, permitindo que o mesmo HTML seja apresentado de formas radicalmente diferentes para diferentes contextos — tela, impressão, leitor de tela, dispositivo móvel.

### 7.1.1 — Separação de responsabilidades

A arquitetura de três camadas da Web moderna distribui responsabilidades de forma precisa:

- **HTML** — estrutura e significado: o que o conteúdo *é*
- **CSS** — apresentação visual: como o conteúdo *aparece*
- **JavaScript** — comportamento interativo: como o conteúdo *age*

Esta separação tem consequências práticas diretas. Um documento HTML semanticamente correto pode ser estilizado de formas completamente diferentes sem qualquer alteração na marcação — basta substituir ou modificar a folha de estilos. O projeto **CSS Zen Garden** ([csszengarden.com](http://www.csszengarden.com)) demonstra isso de forma notável: o mesmo documento HTML é apresentado com dezenas de designs radicalmente diferentes, cada um criado apenas com CSS diferente.

Para desenvolvedores de sistemas de informação, essa separação tem implicações além do front-end: sistemas que geram HTML programaticamente (relatórios, dashboards, e-mails transacionais) se beneficiam diretamente de uma marcação limpa separada da apresentação.

### 7.1.2 — O modelo de renderização do navegador

Compreender como o navegador processa HTML e CSS é essencial para diagnosticar comportamentos inesperados e otimizar o desempenho de páginas.

Quando o navegador recebe um documento HTML, ele executa o seguinte pipeline de renderização:

```
1. HTML parsing → DOM Tree
   O navegador lê o HTML e constrói a árvore DOM

2. CSS parsing → CSSOM Tree
   O navegador lê o CSS e constrói a árvore CSSOM
   (CSS Object Model)

3. Render Tree
   DOM + CSSOM são combinados em uma árvore de renderização
   (apenas elementos visíveis)

4. Layout (Reflow)
   O navegador calcula posição e dimensões de cada elemento

5. Paint
   O navegador pinta os pixels na tela

6. Compositing
   Camadas são combinadas na imagem final exibida ao usuário
```

Este pipeline tem implicações práticas importantes. CSS que bloqueia a renderização (arquivos externos no `<head>`) atrasa a exibição da página. Propriedades CSS que afetam o layout (como `width`, `margin`, `display`) são mais custosas do que propriedades que afetam apenas a pintura (como `color`, `background-color`). Propriedades que afetam apenas a composição (como `transform` e `opacity`) são as mais performáticas para animações.

> **No DevTools:** a aba **Performance** do Chrome DevTools permite gravar e inspecionar o pipeline de renderização quadro a quadro, identificando gargalos de layout e pintura. Para inspeção estática, a aba **Elements** exibe os estilos computados de qualquer elemento selecionado no painel **Computed**, mostrando o valor final de cada propriedade CSS após cascata, herança e especificidade.

---

## 7.2 — Inclusão de CSS no documento

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Existem três formas de associar CSS a um documento HTML, cada uma com características e casos de uso distintos.

### 7.2.1 — CSS externo (recomendado)

A forma preferencial e mais comum: um arquivo `.css` separado, vinculado ao HTML via elemento `<link>` no `<head>`:

```html
<head>
  <meta charset="UTF-8" />
  <title>Meu Site</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
```

**Vantagens:**

- O mesmo arquivo CSS pode ser compartilhado por múltiplas páginas HTML
- O navegador armazena o arquivo em cache após o primeiro carregamento — páginas subsequentes carregam mais rápido
- Clara separação entre estrutura (HTML) e apresentação (CSS)
- Facilita manutenção: alterar o visual do site inteiro requer modificar apenas o arquivo CSS

**Ordem de carregamento:** múltiplos arquivos CSS são aplicados na ordem em que são declarados. Declarações no segundo arquivo sobrescrevem as do primeiro quando há conflito (respeitando especificidade):

```html
<!-- reset.css é aplicado primeiro; style.css pode sobrescrever -->
<link rel="stylesheet" href="css/reset.css" />
<link rel="stylesheet" href="css/style.css" />
```

### 7.2.2 — CSS interno

Declarado dentro de um elemento `<style>` no `<head>` do documento:

```html
<head>
  <style>
    body {
      font-family: 'Trebuchet MS', sans-serif;
      background-color: #f5f5f5;
    }

    h1 {
      color: #12243A;
    }
  </style>
</head>
```

**Quando usar:** prototipação rápida, e-mails HTML (que não suportam CSS externo de forma confiável), páginas únicas que não compartilham estilos com outras páginas.

**Desvantagem:** os estilos não são cacheados separadamente e não são reutilizáveis entre páginas.

### 7.2.3 — CSS inline

Declarado diretamente no atributo `style` de um elemento HTML:

```html
<p style="color: #E8632A; font-weight: bold; margin-top: 1rem;">
  Texto com estilo inline.
</p>
```

**Quando usar:** ajustes pontuais e específicos que não se repetem, geração programática de estilos via JavaScript, situações onde o CSS externo não está disponível.

**Desvantagens:** viola a separação de responsabilidades, não é reutilizável, tem a maior especificidade possível (sobrescreve praticamente qualquer regra CSS externa), e torna o HTML difícil de ler e manter.

> **Regra prática:** CSS externo para projetos reais, CSS interno para prototipação, CSS inline somente como último recurso ou quando gerado programaticamente.

---

## 7.3 — Sintaxe e estrutura do CSS

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 7.3.1 — Regras, declarações e valores

A unidade fundamental do CSS é a **regra** (*rule*), composta por um **seletor** e um **bloco de declarações**:

```css
/* Anatomia de uma regra CSS */

seletor {
  propriedade: valor;
  propriedade: valor;
}

/* Exemplo concreto */
h1 {
  color: #12243A;
  font-size: 2rem;
  margin-bottom: 1rem;
}
```

Cada linha dentro do bloco é uma **declaração**, composta por uma **propriedade** e um **valor**, separados por dois-pontos e terminados com ponto e vírgula. O ponto e vírgula na última declaração do bloco é tecnicamente opcional, mas é uma boa prática incluí-lo para evitar erros ao adicionar novas declarações.

**Múltiplos seletores para a mesma regra** são separados por vírgula:

```css
/* Aplicar o mesmo estilo a h1, h2 e h3 */
h1,
h2,
h3 {
  font-family: Georgia, serif;
  color: #12243A;
}
```

### 7.3.2 — Comentários

Comentários em CSS são delimitados por `/*` e `*/` e podem ocupar uma ou múltiplas linhas:

```css
/* Comentário de uma linha */

/*
  Comentário de
  múltiplas linhas
*/

/* ─── Seção: Tipografia ──────────────────────────── */
body {
  font-family: 'Trebuchet MS', sans-serif; /* Fonte principal */
  font-size: 16px;
}
```

Comentários são removidos pelo navegador antes do processamento e não afetam o comportamento do CSS.

---

## 7.4 — Unidades de medida

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A escolha da unidade de medida em CSS tem impacto direto na responsividade, na acessibilidade e na manutenibilidade do código. Compreender as diferenças entre unidades absolutas, relativas e de viewport é fundamental para construir layouts que se adaptam corretamente a diferentes contextos.

### 7.4.1 — Unidades absolutas

Unidades absolutas possuem tamanho fixo, independente do contexto. Na Web, **`px` (pixel)** é a única unidade absoluta de uso prático:

```css
/* px: pixel CSS — unidade absoluta mais comum na web */
.elemento {
  width: 300px;
  height: 200px;
  border: 2px solid #ccc;
  font-size: 16px;
}
```

**Quando usar `px`:** bordas, sombras, valores que não devem escalar com o texto do usuário (como espessuras de linha), e como valor base para cálculos. Evitar para `font-size` de elementos de texto — impede que a página respeite as preferências de tamanho de fonte do usuário no navegador.

As demais unidades absolutas (`cm`, `mm`, `in`, `pt`, `pc`) são raramente usadas na Web — seu uso prático se restringe a folhas de estilo para impressão.

### 7.4.2 — Unidades relativas

Unidades relativas calculam seu valor em relação a outro valor de referência — tornando o layout mais flexível e adaptável.

**`em` — relativo ao `font-size` do elemento pai**

```css
.container {
  font-size: 16px;
}

.container p {
  font-size: 1em;    /* 16px (igual ao pai) */
  margin-bottom: 1.5em; /* 24px (1.5 × 16px) */
  padding: 0.75em;   /* 12px (0.75 × 16px) */
}

.container h2 {
  font-size: 2em;    /* 32px (2 × 16px) */
}
```

**Atenção ao aninhamento:** `em` se multiplica em elementos aninhados, o que pode produzir resultados inesperados:

```css
/* Se o body tem font-size: 16px */
.pai   { font-size: 1.5em; } /* 24px */
.filho { font-size: 1.5em; } /* 36px (1.5 × 24px, não 1.5 × 16px) */
```

**`rem` — relativo ao `font-size` do elemento raiz (`<html>`)**

`rem` resolve o problema de multiplicação do `em` ao sempre referenciar o elemento `<html>`, independentemente do aninhamento:

```css
html {
  font-size: 16px; /* Base: 1rem = 16px em todo o documento */
}

h1 { font-size: 2rem;    } /* 32px — sempre, independente do contexto */
h2 { font-size: 1.5rem;  } /* 24px */
p  { font-size: 1rem;    } /* 16px */

.pequeno { font-size: 0.875rem; } /* 14px */
```

> **Boa prática:** use `rem` para `font-size` e espaçamentos globais (margens, paddings entre seções). Use `em` para valores que devem escalar proporcionalmente ao tamanho de fonte local (padding interno de botões, por exemplo). Evite `px` para `font-size` — ele impede que o usuário ajuste o tamanho do texto nas preferências do navegador, uma falha de acessibilidade.

**`%` — relativo ao elemento pai**

```css
.container {
  width: 800px;
}

.coluna {
  width: 50%;      /* 400px — metade do container */
  padding: 2%;     /* 16px — 2% de 800px */
}
```

Para `width` e `height`, `%` é calculado em relação à dimensão correspondente do elemento pai. Para `padding` e `margin`, `%` é sempre calculado em relação à **largura** do elemento pai (mesmo para padding vertical).

### 7.4.3 — Unidades de viewport

Unidades de viewport são relativas às dimensões da janela visível do navegador (*viewport*):

| Unidade | Referência | Descrição |
|---|---|---|
| `vw` | Largura do viewport | 1vw = 1% da largura da janela |
| `vh` | Altura do viewport | 1vh = 1% da altura da janela |
| `vmin` | Menor dimensão do viewport | 1vmin = 1% do menor entre vw e vh |
| `vmax` | Maior dimensão do viewport | 1vmax = 1% do maior entre vw e vh |
| `svh` | Small viewport height | Altura sem barras de navegação do browser mobile |
| `dvh` | Dynamic viewport height | Ajusta dinamicamente conforme barras aparecem/desaparecem |

```css
/* Seção que ocupa toda a altura da janela */
.hero {
  height: 100vh;
  width: 100%;
}

/* Tipografia que escala com a largura da janela */
.titulo-fluido {
  font-size: 5vw; /* Em viewport de 1200px → 60px; em 600px → 30px */
}

/* Overlay que cobre toda a tela */
.modal-overlay {
  position: fixed;
  width: 100vw;
  height: 100vh;
  top: 0;
  left: 0;
}
```

> **Nota sobre `vh` em mobile:** em navegadores móveis, `100vh` inclui a área coberta pelas barras de navegação do browser, produzindo scroll indesejado. As unidades `svh` e `dvh`, introduzidas mais recentemente, resolvem esse problema. Para projetos que precisam suportar navegadores mais antigos, soluções via JavaScript ainda são necessárias.

### 7.4.4 — A função `clamp()` — tipografia e layout fluidos

A função `clamp(mínimo, preferido, máximo)` permite definir valores que escalam fluentemente entre um mínimo e um máximo, sem necessidade de media queries:

```css
/* font-size entre 16px e 24px, escalando com a largura do viewport */
p {
  font-size: clamp(1rem, 2.5vw, 1.5rem);
}

/* Largura entre 300px e 800px */
.card {
  width: clamp(300px, 50%, 800px);
}

/* Espaçamento fluido */
.secao {
  padding: clamp(1.5rem, 5vw, 4rem);
}
```

`clamp()` é especialmente poderoso para tipografia fluida — o texto escala suavemente com o viewport, sem os saltos abruptos das media queries. Será aprofundado no Capítulo 10 (Design Responsivo).

---

## 7.5 — Seletores CSS

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Os seletores são o mecanismo pelo qual o CSS identifica quais elementos HTML devem receber determinados estilos. Compreender a hierarquia e o poder expressivo dos seletores é fundamental para escrever CSS eficiente, manutenível e previsível.

### 7.5.1 — Seletores básicos

**Seletor de tipo (elemento)**

Seleciona todos os elementos de um determinado tipo HTML:

```css
/* Todos os parágrafos */
p {
  line-height: 1.6;
  color: #333;
}

/* Todos os links */
a {
  color: #0057B8;
  text-decoration: underline;
}
```

**Seletor de classe**

Seleciona elementos com uma determinada classe. É o seletor mais utilizado no desenvolvimento web moderno, por oferecer reutilização sem o alto peso de especificidade do seletor de ID:

```css
/* Todos os elementos com class="destaque" */
.destaque {
  background-color: #FFF3CD;
  border-left: 4px solid #E8632A;
  padding: 1rem;
}

/* Um elemento pode ter múltiplas classes */
/* <p class="texto grande destaque"> */
.texto  { font-family: Georgia, serif; }
.grande { font-size: 1.25rem; }
```

**Seletor de ID**

Seleciona o elemento com um determinado ID único. Tem especificidade muito mais alta que classes, o que dificulta a sobreposição e manutenção:

```css
/* O elemento com id="cabecalho-principal" */
#cabecalho-principal {
  background-color: #12243A;
  padding: 1.5rem 2rem;
}
```

> **Boa prática:** reserve seletores de ID para JavaScript (`document.getElementById`) e âncoras de navegação (`href="#secao"`). Para estilização, prefira classes — elas são reutilizáveis e têm especificidade mais baixa, facilitando sobrescrições futuras.

**Seletor universal**

Seleciona todos os elementos. Usado principalmente em resets e para aplicar `box-sizing`:

```css
/* Reset universal de box-sizing */
*,
*::before,
*::after {
  box-sizing: border-box;
}
```

### 7.5.2 — Seletores compostos (combinadores)

Combinadores expressam relações estruturais entre elementos na árvore DOM.

**Descendente (espaço)** — seleciona todos os descendentes, independente da profundidade:

```css
/* Todos os <a> dentro de <nav>, em qualquer nível */
nav a {
  color: white;
  text-decoration: none;
}
```

**Filho direto (`>`)** — seleciona apenas filhos diretos, não descendentes mais profundos:

```css
/* Apenas <li> filhos diretos de <ul class="menu"> */
.menu > li {
  display: inline-block;
  margin-right: 1rem;
}
```

**Irmão adjacente (`+`)** — seleciona o elemento imediatamente após outro:

```css
/* O <p> que vem imediatamente após um <h2> */
h2 + p {
  font-size: 1.125rem;
  color: #555;
}
```

**Irmãos gerais (`~`)** — seleciona todos os irmãos após um elemento:

```css
/* Todos os <p> que são irmãos após um <h2> */
h2 ~ p {
  margin-left: 1rem;
}
```

**Agrupamento (`,`)** — aplica a mesma regra a múltiplos seletores:

```css
h1, h2, h3, h4 {
  font-family: Georgia, serif;
  color: #12243A;
  line-height: 1.2;
}
```

### 7.5.3 — Seletores de atributo

Selecionam elementos com base na presença ou valor de atributos HTML:

```css
/* Elementos com o atributo target */
a[target] { font-weight: bold; }

/* Elementos com target="_blank" exato */
a[target="_blank"]::after {
  content: " ↗";
  font-size: 0.8em;
}

/* href que começa com "https" */
a[href^="https"] { color: green; }

/* href que termina com ".pdf" */
a[href$=".pdf"] { color: red; }

/* class que contém a palavra "btn" */
[class*="btn"] { cursor: pointer; }

/* input com type="email" */
input[type="email"] {
  border: 2px solid #0057B8;
}
```

### 7.5.4 — Pseudo-classes

Pseudo-classes selecionam elementos com base em seu **estado** ou **posição** na estrutura do documento:

**Estados de interação:**

```css
/* Link não visitado */
a:link    { color: #0057B8; }

/* Link visitado */
a:visited { color: #6B21A8; }

/* Mouse sobre o elemento */
a:hover   { text-decoration: underline; }

/* Elemento ativo (sendo clicado) */
a:active  { color: #E8632A; }

/* Elemento com foco (teclado ou clique) */
input:focus {
  outline: 3px solid #0057B8;
  outline-offset: 2px;
}

/* Foco apenas via teclado (não via clique) */
button:focus-visible {
  outline: 3px solid #0057B8;
}

/* Checkbox marcado */
input[type="checkbox"]:checked + label {
  font-weight: bold;
}

/* Campo de formulário desabilitado */
input:disabled {
  background-color: #e9ecef;
  cursor: not-allowed;
}

/* Campo obrigatório */
input:required {
  border-left: 3px solid #E8632A;
}

/* Campo com valor válido */
input:valid   { border-color: green; }

/* Campo com valor inválido (após interação) */
input:invalid { border-color: red; }
```

**Posição estrutural:**

```css
/* Primeiro filho */
li:first-child { font-weight: bold; }

/* Último filho */
li:last-child  { border-bottom: none; }

/* Enésimo filho */
tr:nth-child(even) { background-color: #f8f9fa; } /* linhas pares */
tr:nth-child(odd)  { background-color: white; }   /* linhas ímpares */
tr:nth-child(3)    { background-color: #fff3cd; } /* terceira linha */

/* Fórmula: nth-child(An+B) */
li:nth-child(3n)   { color: red; }   /* a cada 3 elementos */
li:nth-child(3n+1) { color: blue; }  /* 1º, 4º, 7º... */

/* Primeiro de um tipo específico */
p:first-of-type { font-size: 1.125rem; }

/* Elemento único de seu tipo */
p:only-child { text-align: center; }

/* Elementos que NÃO correspondem ao seletor */
li:not(.ativo)          { opacity: 0.6; }
input:not([type="submit"]) { border: 1px solid #ccc; }

/* Pseudo-classe :is() — simplifica agrupamentos complexos */
:is(h1, h2, h3) + p { margin-top: 0; }
```

### 7.5.5 — Pseudo-elementos

Pseudo-elementos permitem estilizar **partes específicas** de um elemento ou **inserir conteúdo** antes ou depois dele:

```css
/* Primeira letra de um parágrafo */
p::first-letter {
  font-size: 3em;
  font-weight: bold;
  float: left;
  line-height: 1;
  margin-right: 0.1em;
}

/* Primeira linha de um parágrafo */
p::first-line {
  font-variant: small-caps;
}

/* Conteúdo antes do elemento */
.citacao::before {
  content: "\201C"; /* aspas abertas " */
  font-size: 3em;
  color: #E8632A;
}

/* Conteúdo depois do elemento */
.obrigatorio::after {
  content: " *";
  color: red;
  aria-hidden: true;
}

/* Texto selecionado pelo usuário */
::selection {
  background-color: #E8632A;
  color: white;
}

/* Placeholder de inputs */
input::placeholder {
  color: #9CA3AF;
  font-style: italic;
}
```

---

## 7.6 — Especificidade e Cascata

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A **especificidade** e a **cascata** são os dois mecanismos que o CSS utiliza para resolver conflitos quando múltiplas regras se aplicam ao mesmo elemento. Compreendê-los é essencial para evitar o uso indiscriminado de `!important` e para escrever CSS previsível e manutenível.

### 7.6.1 — Cálculo de especificidade

A especificidade é calculada como um valor de três componentes, representado como `(A, B, C)`:

| Componente | O que conta | Valor |
|---|---|---|
| **A** | Seletores de ID (`#id`) | 100 pontos |
| **B** | Classes (`.classe`), pseudo-classes (`:hover`), atributos (`[type]`) | 10 pontos |
| **C** | Tipos de elemento (`p`, `div`, `h1`), pseudo-elementos (`::before`) | 1 ponto |

O seletor universal (`*`) e os combinadores (`>`, `+`, `~`, ` `) não contribuem com especificidade.

```css
/* Especificidade: (0, 0, 1) = 1 ponto */
p { color: red; }

/* Especificidade: (0, 1, 0) = 10 pontos */
.texto { color: blue; }

/* Especificidade: (0, 1, 1) = 11 pontos */
p.texto { color: green; }

/* Especificidade: (1, 0, 0) = 100 pontos */
#titulo { color: orange; }

/* Especificidade: (1, 1, 1) = 111 pontos */
#titulo p.texto { color: purple; }
```

Quando dois seletores têm a mesma especificidade, a **ordem de declaração** decide: a última regra declarada prevalece.

> **Imagem sugerida:** diagrama visual do cálculo de especificidade com exemplos de seletores e seus valores — similar a um placar (A, B, C) com cada componente colorido de forma distinta.
>
> *(imagem será adicionada posteriormente)*

### 7.6.2 — CSS inline e `!important`

**CSS inline** (declarado no atributo `style`) tem especificidade equivalente a `(1, 0, 0, 0)` — superior a qualquer seletor CSS externo ou interno.

**`!important`** sobrescreve qualquer regra, independente da especificidade:

```css
/* Esta regra prevalece sobre qualquer outra, incluindo CSS inline */
.elemento {
  color: red !important;
}
```

> **⚠️ Alerta:** `!important` deve ser tratado como último recurso, não como ferramenta padrão. Seu uso indiscriminado cria um "braço de ferro" de especificidade que torna o CSS impossível de manter. Em projetos reais, a necessidade frequente de `!important` indica que a arquitetura de seletores precisa ser revisada.

### 7.6.3 — A cascata: quatro fatores de resolução

Quando múltiplas regras conflitantes se aplicam ao mesmo elemento, o CSS as resolve por meio da **cascata**, que considera quatro fatores em ordem de prioridade:

1. **Origem e importância** — estilos do navegador (user agent) < estilos do autor (desenvolvedor) < estilos do usuário. `!important` inverte essa ordem para o fator correspondente.

2. **Especificidade** — conforme calculado acima.

3. **Ordem de aparição** — entre regras de mesma especificidade, a última declarada prevalece.

4. **Herança** — valores herdados do elemento pai (explicado na próxima seção).

```css
/* Estilos do navegador (implícitos):
   h1 { font-size: 2em; font-weight: bold; } */

/* Estilos do desenvolvedor — sobrescrevem o navegador */
h1 {
  font-size: 2.5rem; /* sobrescreve o navegador */
  color: #12243A;    /* adiciona nova propriedade */
}

/* Regra mais específica — sobrescreve a anterior */
.conteudo-principal h1 {
  font-size: 3rem;
}
```

### 7.6.4 — Herança

A **herança** é o mecanismo pelo qual certas propriedades CSS se propagam automaticamente de um elemento pai para seus descendentes. Isso permite definir propriedades tipográficas no `body` e tê-las aplicadas a todos os elementos da página sem repetição:

```css
body {
  font-family: 'Trebuchet MS', sans-serif;
  font-size: 16px;
  color: #333;
  line-height: 1.6;
}
/* Todos os elementos filhos herdam essas propriedades
   a menos que as sobrescrevam explicitamente */
```

**Propriedades tipicamente herdáveis:** `color`, `font-family`, `font-size`, `font-weight`, `font-style`, `line-height`, `text-align`, `letter-spacing`, `visibility`, `cursor`.

**Propriedades tipicamente não herdáveis:** `width`, `height`, `margin`, `padding`, `border`, `background`, `display`, `position`, `top`, `left`.

**Controlando herança explicitamente:**

```css
.elemento {
  /* Força a herança do valor do pai */
  color: inherit;

  /* Usa o valor inicial (padrão da especificação) */
  margin: initial;

  /* Reverte para o estilo do navegador */
  display: revert;

  /* Equivale a inherit se a propriedade é herdável,
     initial se não for */
  border: unset;
}
```

---

## 7.7 — Box Model

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **Box Model** (modelo de caixa) é o fundamento do layout em CSS. Todo elemento HTML é representado como uma caixa retangular composta por quatro camadas concêntricas, da mais interna para a mais externa:

```
┌─────────────────────────────────────┐
│              MARGIN                 │  ← Área externa (transparente)
│  ┌───────────────────────────────┐  │
│  │           BORDER              │  │  ← Borda visível
│  │  ┌─────────────────────────┐  │  │
│  │  │        PADDING          │  │  │  ← Espaçamento interno
│  │  │  ┌───────────────────┐  │  │  │
│  │  │  │      CONTENT      │  │  │  │  ← Conteúdo (texto, imagem)
│  │  │  └───────────────────┘  │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### 7.7.1 — As quatro camadas

**Content (conteúdo)**

A área onde o conteúdo do elemento é renderizado — texto, imagem, etc. Suas dimensões são controladas pelas propriedades `width` e `height`.

**Padding (preenchimento interno)**

Espaço entre o conteúdo e a borda. É parte do elemento visualmente — herda o `background-color` do elemento:

```css
.card {
  padding: 1.5rem;           /* todos os lados iguais */
  padding: 1rem 2rem;        /* vertical | horizontal */
  padding: 1rem 2rem 1.5rem; /* top | horizontal | bottom */
  padding: 1rem 2rem 1.5rem 1rem; /* top | right | bottom | left */

  /* Propriedades individuais */
  padding-top: 1rem;
  padding-right: 2rem;
  padding-bottom: 1rem;
  padding-left: 2rem;
}
```

**Border (borda)**

A linha que envolve o padding e o conteúdo:

```css
.elemento {
  border: 2px solid #ccc;          /* shorthand: largura estilo cor */
  border: 1px dashed #E8632A;
  border: 3px double #12243A;

  /* Lados individuais */
  border-top: 4px solid #E8632A;
  border-bottom: 1px solid #eee;

  /* Propriedades individuais */
  border-width: 2px;
  border-style: solid;  /* solid, dashed, dotted, double, none */
  border-color: #ccc;

  /* Arredondamento */
  border-radius: 8px;           /* todos os cantos */
  border-radius: 8px 0 8px 0;  /* TL TR BR BL */
  border-radius: 50%;           /* círculo (em elemento quadrado) */
}
```

**Margin (margem externa)**

Espaço externo ao elemento — separa o elemento de seus vizinhos. A margem é sempre transparente (não herda background):

```css
.paragrafo {
  margin: 1rem 0;       /* 1rem top/bottom, 0 left/right */
  margin-bottom: 1.5rem;
  margin: 0 auto;       /* centraliza horizontalmente (em elementos block) */
}
```

**Outline**

Tecnicamente não faz parte do Box Model — não ocupa espaço no layout. É renderizado sobre o elemento, por fora da borda. Usado principalmente para indicadores de foco acessíveis:

```css
button:focus-visible {
  outline: 3px solid #0057B8;
  outline-offset: 2px; /* espaço entre outline e a borda do elemento */
}
```

### 7.7.2 — `box-sizing`: o comportamento que você realmente quer

Por padrão, o CSS calcula `width` e `height` como as dimensões do **content** apenas. Isso significa que padding e border são adicionados por fora, aumentando o tamanho total do elemento:

```css
/* box-sizing: content-box (padrão) */
.elemento {
  width: 300px;
  padding: 20px;
  border: 5px solid #ccc;
}
/* Largura total real: 300 + 20 + 20 + 5 + 5 = 350px */
```

Este comportamento é contraintuitivo — quando você define `width: 300px`, espera que o elemento ocupe 300px, não 350px. A propriedade `box-sizing: border-box` corrige isso, fazendo com que `width` e `height` incluam padding e border:

```css
/* box-sizing: border-box */
.elemento {
  box-sizing: border-box;
  width: 300px;
  padding: 20px;
  border: 5px solid #ccc;
}
/* Largura total real: 300px — padding e border são subtraídos do content */
```

A convenção universalmente adotada no desenvolvimento web moderno é aplicar `border-box` globalmente:

```css
/* Reset padrão do box-sizing — inclua em todo projeto */
*,
*::before,
*::after {
  box-sizing: border-box;
}
```

> **No DevTools:** selecione qualquer elemento na aba **Elements** e observe o diagrama do Box Model no painel **Computed**. Ele exibe as dimensões reais de content, padding, border e margin do elemento selecionado — uma ferramenta essencial para diagnosticar problemas de espaçamento e layout.

### 7.7.3 — Colapso de margens

O **colapso de margens** (*margin collapsing*) é um comportamento do CSS que funde as margens verticais adjacentes de dois elementos em uma única margem — igual à maior das duas, não à soma:

```css
.paragrafo-1 { margin-bottom: 2rem; }
.paragrafo-2 { margin-top: 1rem; }

/* Resultado: espaço entre os parágrafos = 2rem (não 3rem) */
```

O colapso ocorre em três situações:

1. **Irmãos adjacentes:** a margem inferior do primeiro e a margem superior do segundo colapsam
2. **Pai e primeiro/último filho:** se não houver border, padding ou conteúdo separando-os
3. **Elemento vazio:** margens superior e inferior do próprio elemento colapsam entre si

O colapso **não** ocorre em elementos `flex`, `grid`, `inline-block`, ou quando há `overflow` diferente de `visible`.

```css
/* Prevenindo colapso com padding ou border no pai */
.container {
  padding-top: 1px;  /* evita colapso com o primeiro filho */
  /* ou */
  overflow: hidden;  /* também previne colapso */
}
```

### 7.7.4 — Dimensionamento: `width`, `height`, `min-*` e `max-*`

```css
.elemento {
  /* Valores fixos */
  width: 400px;
  height: 200px;

  /* Valores relativos */
  width: 50%;        /* 50% do elemento pai */
  height: 100vh;     /* 100% da altura do viewport */

  /* Limites: evitam que o elemento fique muito pequeno ou grande */
  min-width: 200px;
  max-width: 800px;
  min-height: 100px;
  max-height: 500px;

  /* Padrão responsivo: elemento fluido com largura máxima */
  width: 100%;
  max-width: 1200px;
  margin: 0 auto; /* centraliza */
}
```

**`width: auto` vs `width: 100%`:**

- `auto` (padrão para elementos block): o elemento ocupa o espaço disponível, respeitando padding e margem
- `100%`: o elemento ocupa 100% da largura do pai, e o padding é adicionado por fora (com `content-box`) — pode causar overflow

---

## 7.8 — Tipografia e Estilização de Texto

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A tipografia é um dos componentes mais impactantes do design visual. Escolhas tipográficas inadequadas comprometem a legibilidade, a hierarquia e a percepção de qualidade de uma interface. O CSS oferece um conjunto rico de propriedades para controle tipográfico preciso.

### 7.8.1 — Propriedades de fonte

**`font-family` — família tipográfica**

Define a fonte utilizada. Aceita uma lista de fontes em ordem de preferência (*font stack*) — o navegador usa a primeira disponível no sistema do usuário:

```css
body {
  /* Stack com fallbacks: fonte específica → alternativa → genérica */
  font-family: 'Trebuchet MS', Helvetica, Arial, sans-serif;
}

h1, h2, h3 {
  font-family: Georgia, 'Times New Roman', Times, serif;
}

code, pre {
  font-family: 'Fira Code', 'Cascadia Code', Consolas, monospace;
}
```

As categorias genéricas (`serif`, `sans-serif`, `monospace`, `cursive`, `fantasy`) devem sempre ser o último item do stack, garantindo que o navegador use alguma fonte adequada mesmo quando todas as anteriores falharem.

**`font-size` — tamanho da fonte**

```css
html { font-size: 16px; }  /* Base: 1rem = 16px */

body   { font-size: 1rem;     } /* 16px */
h1     { font-size: 2.5rem;   } /* 40px */
h2     { font-size: 2rem;     } /* 32px */
h3     { font-size: 1.5rem;   } /* 24px */
small  { font-size: 0.875rem; } /* 14px */
```

**`font-weight` — peso (espessura)**

```css
p       { font-weight: 400; }  /* normal */
strong  { font-weight: 700; }  /* bold */
.leve   { font-weight: 300; }  /* light */
.titulo { font-weight: 900; }  /* black/heavy */

/* Palavras-chave equivalentes */
.normal { font-weight: normal; } /* = 400 */
.negrito { font-weight: bold; }  /* = 700 */
```

**`font-style` — estilo**

```css
em     { font-style: italic; }
.obliquo { font-style: oblique; }
.normal  { font-style: normal; }
```

**`line-height` — altura da linha**

Uma das propriedades mais importantes para legibilidade. Aceita valores sem unidade (multiplicador do `font-size`), que são preferíveis aos valores em `px` ou `rem` por herdarem corretamente:

```css
body {
  line-height: 1.6;  /* 160% do font-size — adequado para texto corrido */
}

h1 {
  line-height: 1.2;  /* Títulos grandes ficam melhor com line-height menor */
}

.codigo {
  line-height: 1.5;
}
```

### 7.8.2 — Estilização de texto

```css
/* Alinhamento */
.centro    { text-align: center; }
.direita   { text-align: right; }
.justificado { text-align: justify; }

/* Decoração */
a          { text-decoration: underline; }
a:hover    { text-decoration: none; }
del        { text-decoration: line-through; }
.sublinhado-personalizado {
  text-decoration: underline dotted #E8632A;
}

/* Transformação */
.maiusculo  { text-transform: uppercase; }
.minusculo  { text-transform: lowercase; }
.capitalizado { text-transform: capitalize; }

/* Espaçamento de letras e palavras */
.espacado   { letter-spacing: 0.1em; }
.titulo-caixa-alta {
  text-transform: uppercase;
  letter-spacing: 0.15em;
}
.palavra-espaco { word-spacing: 0.25em; }

/* Indentação */
p { text-indent: 1.5em; }

/* Controle de quebra de linha */
.sem-quebra  { white-space: nowrap; }
.pre-formato { white-space: pre; }
.truncado {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis; /* "..." no final */
}
```

### 7.8.3 — Web Fonts: Google Fonts e `@font-face`

Fontes do sistema variam entre dispositivos e sistemas operacionais — o que garante consistência é carregar fontes externas.

**Google Fonts (forma mais simples):**

```html
<!-- No <head>: link de pré-conexão + importação da fonte -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link
  href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Merriweather:ital,wght@0,400;0,700;1,400&display=swap"
  rel="stylesheet"
/>
```

```css
body {
  font-family: 'Inter', sans-serif;
}

h1, h2, h3 {
  font-family: 'Merriweather', serif;
}
```

**`@font-face` (fontes auto-hospedadas):**

Quando você possui os arquivos de fonte localmente — por licenciamento, desempenho ou privacidade:

```css
@font-face {
  font-family: 'MinhaFonte';
  src:
    url('../fonts/minha-fonte.woff2') format('woff2'),
    url('../fonts/minha-fonte.woff') format('woff');
  font-weight: 400;
  font-style: normal;
  font-display: swap; /* exibe fallback até a fonte carregar */
}

@font-face {
  font-family: 'MinhaFonte';
  src: url('../fonts/minha-fonte-bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
}

body {
  font-family: 'MinhaFonte', sans-serif;
}
```

> **`font-display: swap`** instrui o navegador a exibir o texto com uma fonte de fallback enquanto a fonte personalizada carrega, em vez de deixar o texto invisível. É uma boa prática de desempenho e experiência do usuário.

---

## 7.9 — Cores e Backgrounds

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 7.9.1 — Sistemas de cores

O CSS suporta múltiplos sistemas de representação de cores, cada um com características distintas:

**Hexadecimal (HEX)**

```css
.elemento {
  color: #12243A;        /* 6 dígitos: #RRGGBB */
  color: #E8632A;
  color: #fff;           /* 3 dígitos (shorthand): #RGB */
  color: #0057B8CC;      /* 8 dígitos: #RRGGBBAA (com alpha) */
}
```

**RGB e RGBA**

```css
.elemento {
  color: rgb(18, 36, 58);              /* Valores 0–255 */
  color: rgb(232, 99, 42);
  background-color: rgba(18, 36, 58, 0.8); /* Com opacidade 0–1 */

  /* Sintaxe moderna (CSS Color Level 4) */
  color: rgb(18 36 58);                /* sem vírgulas */
  color: rgb(18 36 58 / 0.8);          /* com alpha */
}
```

**HSL e HSLA** (Hue, Saturation, Lightness)

HSL é o sistema mais intuitivo para criar paletas de cores — modificar a luminosidade `L` mantendo `H` e `S` cria variações consistentes:

```css
.elemento {
  /* hsl(matiz 0-360°, saturação 0-100%, luminosidade 0-100%) */
  color: hsl(210, 53%, 15%);          /* azul escuro */
  color: hsl(20, 78%, 54%);           /* laranja */
  color: hsl(210, 53%, 15%, 0.8);    /* com opacidade */

  /* Criar variações de uma cor mantendo identidade visual */
  --cor-base: 210 53%;               /* matiz + saturação fixos */
  --cor-900: hsl(var(--cor-base) 10%);
  --cor-700: hsl(var(--cor-base) 25%);
  --cor-500: hsl(var(--cor-base) 45%);
  --cor-300: hsl(var(--cor-base) 65%);
  --cor-100: hsl(var(--cor-base) 90%);
}
```

### 7.9.2 — Propriedades de background

```css
.elemento {
  /* Cor de fundo */
  background-color: #f8f9fa;

  /* Imagem de fundo */
  background-image: url('../images/pattern.png');
  background-image: url('../images/hero.jpg');

  /* Repetição */
  background-repeat: no-repeat;   /* não repete */
  background-repeat: repeat-x;    /* repete horizontalmente */
  background-repeat: repeat;      /* repete em ambos os eixos */

  /* Posicionamento */
  background-position: center;
  background-position: top right;
  background-position: 50% 30%;

  /* Tamanho */
  background-size: cover;    /* cobre toda a área, pode cortar */
  background-size: contain;  /* cabe inteira, pode deixar espaços */
  background-size: 200px 150px;
  background-size: 100% auto;

  /* Shorthand */
  background: url('../images/hero.jpg') center/cover no-repeat;
}
```

**`background-size: cover` vs `contain`:**

- `cover`: a imagem é escalada para cobrir completamente o elemento, mantendo proporção — partes podem ser cortadas
- `contain`: a imagem é escalada para caber inteiramente no elemento, mantendo proporção — podem aparecer áreas vazias

### 7.9.3 — Gradientes

```css
/* Gradiente linear */
.hero {
  background-image: linear-gradient(135deg, #12243A, #1C3A52);
  background-image: linear-gradient(to right, #E8632A, #12243A);
  background-image: linear-gradient(
    to bottom,
    rgba(18, 36, 58, 0) 0%,
    rgba(18, 36, 58, 0.9) 100%
  );
}

/* Gradiente radial */
.circulo {
  background-image: radial-gradient(circle, #E8632A, #12243A);
  background-image: radial-gradient(
    ellipse at top left,
    #1C3A52 0%,
    #12243A 100%
  );
}

/* Gradiente cônico */
.pizza {
  background-image: conic-gradient(
    #E8632A 0% 25%,
    #12243A 25% 50%,
    #1C7293 50% 75%,
    #F7F5F2 75% 100%
  );
}

/* Múltiplos backgrounds */
.elemento {
  background:
    linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
    url('../images/hero.jpg') center/cover no-repeat;
}
```

### 7.9.4 — Opacidade e transparência

```css
/* opacity: afeta o elemento inteiro, incluindo conteúdo */
.overlay {
  opacity: 0.8; /* 0 = transparente, 1 = opaco */
}

/* rgba/hsla: afeta apenas a propriedade específica */
.fundo-semi-transparente {
  background-color: rgba(18, 36, 58, 0.8); /* apenas o fundo é transparente */
  color: white; /* texto permanece opaco */
}
```

---

## 7.10 — Display e Fluxo de Layout

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A propriedade `display` é a mais fundamental do layout CSS. Ela determina o **modelo de formatação** de um elemento — como ele se comporta no fluxo do documento e como seus filhos são organizados.

### 7.10.1 — Fluxo normal do documento

O **fluxo normal** é o comportamento padrão de layout quando nenhuma propriedade de posicionamento ou display especial é aplicada. Ele é governado por dois tipos de caixas:

**Elementos de bloco (*block*):** ocupam toda a largura disponível do pai, empilham-se verticalmente. Exemplos: `<div>`, `<p>`, `<h1>`–`<h6>`, `<section>`, `<article>`, `<header>`, `<footer>`, `<ul>`, `<li>`.

**Elementos inline:** ocupam apenas o espaço de seu conteúdo, fluem horizontalmente no texto, não quebram linha. Exemplos: `<span>`, `<a>`, `<strong>`, `<em>`, `<img>`.

### 7.10.2 — Valores de `display`

```css
/* block: elemento de bloco — ocupa toda a largura, quebra linha */
.elemento { display: block; }

/* inline: flui com o texto, ignora width/height e margens verticais */
.elemento { display: inline; }

/* inline-block: flui com o texto MAS aceita width, height e margens */
.badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  background: #E8632A;
  color: white;
}

/* none: remove o elemento do layout E da acessibilidade */
.oculto { display: none; }

/* flex: ativa Flexbox no container (Capítulo 8) */
.container { display: flex; }

/* grid: ativa Grid Layout no container (Capítulo 9) */
.grade { display: grid; }
```

**`display: none` vs `visibility: hidden`:**

```css
/* none: elemento não existe no layout — não ocupa espaço */
.removido { display: none; }

/* hidden: elemento é invisível, mas MANTÉM seu espaço no layout */
.invisivel { visibility: hidden; }
```

### 7.10.3 — Overflow

A propriedade `overflow` controla o que acontece quando o conteúdo de um elemento ultrapassa suas dimensões definidas:

```css
.elemento {
  overflow: visible; /* padrão: conteúdo transborda para fora */
  overflow: hidden;  /* conteúdo cortado na borda do elemento */
  overflow: scroll;  /* sempre exibe barras de rolagem */
  overflow: auto;    /* barras de rolagem apenas quando necessário */

  /* Controle por eixo */
  overflow-x: hidden;
  overflow-y: auto;
}

/* Caso de uso comum: container com conteúdo previsível */
.tabela-responsiva {
  overflow-x: auto;   /* scroll horizontal em telas pequenas */
  max-width: 100%;
}

/* Texto com reticências */
.titulo-truncado {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}
```

---

## 7.11 — Posicionamento

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A propriedade `position` controla como um elemento é posicionado em relação ao fluxo normal do documento ou a um contexto de posicionamento específico.

### 7.11.1 — `position: static` (padrão)

O valor padrão. O elemento segue o fluxo normal do documento. As propriedades `top`, `right`, `bottom` e `left` não têm efeito:

```css
.normal {
  position: static; /* comportamento padrão */
}
```

### 7.11.2 — `position: relative`

O elemento permanece no fluxo normal, mas pode ser **deslocado** em relação à sua posição original usando `top`, `right`, `bottom` e `left`. O espaço original do elemento é **preservado** no layout:

```css
.deslocado {
  position: relative;
  top: 10px;   /* desloca 10px para baixo */
  left: 20px;  /* desloca 20px para a direita */
}
```

**Uso mais importante:** criar um **contexto de posicionamento** para elementos filhos com `position: absolute`:

```css
.container {
  position: relative; /* contexto de posicionamento */
}
```

### 7.11.3 — `position: absolute`

O elemento é **removido do fluxo normal** — não ocupa espaço no layout. É posicionado em relação ao **ancestral mais próximo com position diferente de static**. Se nenhum ancestral for posicionado, é relativo ao `<html>`:

```css
.pai {
  position: relative; /* contexto de posicionamento */
  width: 300px;
  height: 200px;
}

.filho-absoluto {
  position: absolute;
  top: 0;
  right: 0;      /* canto superior direito do pai */
  width: 80px;
  height: 30px;
}

/* Centralizar com absolute */
.centralizado {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%); /* ajusta pelo próprio tamanho */
}
```

### 7.11.4 — `position: fixed`

O elemento é **removido do fluxo normal** e posicionado em relação ao **viewport** — permanece na mesma posição mesmo com rolagem da página:

```css
/* Barra de navegação fixa no topo */
.navbar-fixa {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1000;
  background-color: #12243A;
}

/* Botão "voltar ao topo" */
.btn-topo {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
}
```

### 7.11.5 — `position: sticky`

Comportamento híbrido: o elemento segue o fluxo normal **até** atingir um threshold definido, quando "gruda" na posição especificada:

```css
/* Cabeçalho de tabela que gruda no topo ao rolar */
thead th {
  position: sticky;
  top: 0;
  background-color: #12243A;
  color: white;
  z-index: 1;
}

/* Navegação lateral que gruda ao rolar */
.nav-lateral {
  position: sticky;
  top: 2rem;       /* gruda a 2rem do topo */
  height: fit-content;
}
```

**Requisito:** o elemento pai deve ter altura suficiente para que o `sticky` funcione, e `overflow` do pai não pode ser `hidden` ou `auto`.

### 7.11.6 — `z-index` e contexto de empilhamento

A propriedade `z-index` controla a **ordem de empilhamento** de elementos posicionados (com position diferente de static). Valores maiores ficam na frente:

```css
.modal-overlay {
  position: fixed;
  z-index: 1000;
}

.modal {
  position: fixed;
  z-index: 1001; /* acima do overlay */
}

.tooltip {
  position: absolute;
  z-index: 100;
}
```

> **Contexto de empilhamento:** `z-index` funciona dentro de **contextos de empilhamento**. Um elemento com `opacity < 1`, `transform`, `filter` ou `will-change` cria um novo contexto de empilhamento — `z-index` de seus filhos é relativo a esse contexto, não ao documento global. Este é um dos comportamentos mais frequentemente mal compreendidos do CSS.

---

## 7.12 — Variáveis CSS (Custom Properties)

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

As **variáveis CSS** (oficialmente chamadas de *Custom Properties*) permitem definir valores reutilizáveis que podem ser referenciados em qualquer ponto da folha de estilos. Elas são fundamentais para criar sistemas de design consistentes e facilitar a manutenção de projetos.

### 7.12.1 — Definição e uso

Variáveis CSS são definidas com o prefixo `--` e referenciadas com a função `var()`:

```css
/* Definição: geralmente no :root para escopo global */
:root {
  /* Paleta de cores */
  --cor-primaria: #12243A;
  --cor-secundaria: #1C3A52;
  --cor-destaque: #E8632A;
  --cor-texto: #333333;
  --cor-fundo: #F7F5F2;

  /* Tipografia */
  --fonte-base: 'Trebuchet MS', sans-serif;
  --fonte-titulo: Georgia, serif;
  --tamanho-base: 1rem;

  /* Espaçamento */
  --espaco-xs: 0.25rem;
  --espaco-sm: 0.5rem;
  --espaco-md: 1rem;
  --espaco-lg: 2rem;
  --espaco-xl: 4rem;

  /* Bordas */
  --raio-borda: 8px;
  --raio-borda-sm: 4px;
  --raio-circulo: 9999px;

  /* Sombras */
  --sombra-sm: 0 1px 3px rgba(0, 0, 0, 0.12);
  --sombra-md: 0 4px 6px rgba(0, 0, 0, 0.1);
  --sombra-lg: 0 10px 25px rgba(0, 0, 0, 0.15);

  /* Transições */
  --transicao-padrao: 200ms ease-in-out;
}

/* Uso em qualquer regra */
.btn-primario {
  background-color: var(--cor-destaque);
  color: white;
  font-family: var(--fonte-base);
  padding: var(--espaco-sm) var(--espaco-md);
  border-radius: var(--raio-borda);
  transition: background-color var(--transicao-padrao);
}

.card {
  background-color: var(--cor-fundo);
  border-radius: var(--raio-borda);
  box-shadow: var(--sombra-md);
  padding: var(--espaco-lg);
}
```

### 7.12.2 — Escopo e herança

Variáveis CSS respeitam o escopo do seletor onde são definidas e são herdadas pelos descendentes:

```css
/* Global */
:root {
  --cor-destaque: #E8632A;
}

/* Sobrescrevendo localmente */
.tema-escuro {
  --cor-destaque: #FF8C55; /* versão mais clara para fundo escuro */
  --cor-fundo: #1a1a1a;
  --cor-texto: #f5f5f5;
}

/* Todos os elementos dentro de .tema-escuro usam as variáveis locais */
.tema-escuro .btn {
  background-color: var(--cor-destaque); /* usa #FF8C55 */
}
```

### 7.12.3 — Valor de fallback

A função `var()` aceita um segundo argumento como valor de fallback:

```css
.elemento {
  /* Se --cor-primaria não estiver definida, usa #12243A */
  color: var(--cor-primaria, #12243A);

  /* Fallback pode referenciar outra variável */
  background: var(--cor-fundo, var(--cor-secundaria, white));
}
```

### 7.12.4 — Variáveis CSS vs pré-processadores

Variáveis CSS diferem das variáveis de pré-processadores como Sass/LESS em aspectos importantes:

| Característica | Variáveis CSS | Variáveis Sass |
|---|---|---|
| Processamento | Runtime (navegador) | Compilação |
| Escopo | Cascata e herança CSS | Léxico |
| Modificável via JS | ✅ Sim | ❌ Não |
| Suporte a media queries | ✅ Sim | ❌ Não |
| Compatibilidade | Navegadores modernos | Requer build step |

A capacidade de modificar variáveis CSS via JavaScript as torna especialmente poderosas para temas dinâmicos e animações:

```javascript
// Modificando uma variável CSS via JavaScript
document.documentElement.style.setProperty('--cor-destaque', '#1C7293');
```

---

## 7.13 — Organização e Boas Práticas

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

CSS sem organização cresce rapidamente em um arquivo difícil de manter, com conflitos de especificidade e regras redundantes. Boas práticas de organização são especialmente relevantes para projetos de sistemas de informação, onde o código é mantido por equipes ao longo do tempo.

### 7.13.1 — Estrutura de arquivos

Para projetos simples, um único arquivo `style.css` organizado em seções é suficiente:

```
css/
└── style.css
```

Para projetos maiores, a separação por responsabilidade é recomendada:

```
css/
├── reset.css         /* Reset/normalização de estilos do navegador */
├── variables.css     /* Variáveis CSS (Custom Properties) */
├── typography.css    /* Tipografia global */
├── layout.css        /* Estrutura geral da página */
├── components.css    /* Componentes reutilizáveis */
└── utilities.css     /* Classes utilitárias */
```

Dentro do arquivo principal, organizar em seções comentadas:

```css
/* ─── 1. Reset ─────────────────────────────────── */

*,
*::before,
*::after { box-sizing: border-box; }

/* ─── 2. Variáveis ──────────────────────────────── */

:root { ... }

/* ─── 3. Base ───────────────────────────────────── */

body { ... }
h1, h2, h3 { ... }

/* ─── 4. Layout ─────────────────────────────────── */

.container { ... }
.grid { ... }

/* ─── 5. Componentes ────────────────────────────── */

.card { ... }
.btn { ... }
.nav { ... }

/* ─── 6. Utilitários ────────────────────────────── */

.oculto { display: none; }
.centralizado { text-align: center; }
```

### 7.13.2 — Nomeação de classes

A nomeação consistente de classes é essencial para legibilidade e manutenção. A convenção mais adotada é o **BEM** (*Block, Element, Modifier*):

```css
/* Bloco: componente autônomo */
.card { }

/* Elemento: parte do bloco, separado por __ */
.card__titulo { }
.card__imagem { }
.card__rodape { }

/* Modificador: variação do bloco ou elemento, separado por -- */
.card--destaque { }
.card--pequeno { }
.card__titulo--grande { }
```

```html
<article class="card card--destaque">
  <img class="card__imagem" src="..." alt="..." />
  <div class="card__corpo">
    <h2 class="card__titulo card__titulo--grande">Título</h2>
    <p class="card__texto">Conteúdo...</p>
  </div>
  <footer class="card__rodape">Rodapé</footer>
</article>
```

### 7.13.3 — Evitando conflitos de especificidade

Algumas diretrizes para manter a especificidade sob controle:

- **Prefira classes a seletores de tipo e ID** para estilização
- **Evite encadear mais de 3 seletores** — `nav ul li a` é difícil de sobrescrever
- **Não use `!important`** exceto em utilitários (`display: none !important`)
- **Use especificidade crescente**: estilos base com baixa especificidade, sobrescrições com especificidade um pouco maior
- **Defina estilos de componentes com uma única classe** sempre que possível

```css
/* DIFÍCIL DE MANTER: alta especificidade, difícil de sobrescrever */
header nav ul li a.ativo { color: red; }

/* MELHOR: classe simples, fácil de sobrescrever */
.nav-link--ativo { color: var(--cor-destaque); }
```

### 7.13.4 — Reset e normalização

Navegadores aplicam estilos padrão diferentes aos elementos HTML. Um **CSS reset** remove esses estilos, enquanto um **normalize** os padroniza entre navegadores:

```css
/* Reset minimalista moderno (baseado em Andy Bell / Josh Comeau) */

*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  font-size: 16px;
  scroll-behavior: smooth;
  -webkit-text-size-adjust: 100%;
}

body {
  min-height: 100vh;
  line-height: 1.5;
  -webkit-font-smoothing: antialiased;
}

img,
picture,
video,
canvas,
svg {
  display: block;
  max-width: 100%;
}

input,
button,
textarea,
select {
  font: inherit; /* herda fonte do body, não usa a padrão do sistema */
}

p,
h1, h2, h3, h4, h5, h6 {
  overflow-wrap: break-word;
}
```

**Referências:**
- [MDN — CSS Reference](https://developer.mozilla.org/pt-BR/docs/Web/CSS/Reference)
- [W3C — CSS Specifications](https://www.w3.org/Style/CSS/)
- [CSS Tricks — A Complete Guide to CSS](https://css-tricks.com)
- [Kevin Powell — CSS no YouTube](https://www.youtube.com/@KevinPowell)
- [CSS Zen Garden](http://www.csszengarden.com)
- [Can I Use — Compatibilidade de recursos CSS](https://caniuse.com)

---

#### **Atividades — Capítulo 7**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Qual é a especificidade do seletor <code>#nav .menu > li:hover</code>?</p>
  <button data-option="a">(0, 2, 1) = 21 pontos</button>
  <button data-option="b">(1, 1, 1) = 111 pontos</button>
  <button data-option="c">(1, 2, 1) = 121 pontos</button>
  <button data-option="d">(1, 1, 2) = 112 pontos</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Um elemento tem <code>width: 300px</code>, <code>padding: 20px</code> e <code>border: 5px solid</code>. Com <code>box-sizing: content-box</code>, qual é a largura total ocupada na página?</p>
  <button data-option="a">300px — o padding e border ficam dentro do width</button>
  <button data-option="b">350px — 300 (content) + 20 + 20 (padding) + 5 + 5 (border)</button>
  <button data-option="c">320px — apenas o padding é somado ao width</button>
  <button data-option="d">305px — apenas a border é somada ao width</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual a diferença entre <code>position: absolute</code> e <code>position: fixed</code>?</p>
  <button data-option="a">Não há diferença funcional; ambos removem o elemento do fluxo normal.</button>
  <button data-option="b"><code>absolute</code> é relativo ao viewport; <code>fixed</code> é relativo ao ancestral posicionado mais próximo.</button>
  <button data-option="c"><code>fixed</code> só funciona em elementos com <code>display: block</code>.</button>
  <button data-option="d"><code>absolute</code> é posicionado em relação ao ancestral posicionado mais próximo e rola com a página; <code>fixed</code> é relativo ao viewport e permanece fixo mesmo com rolagem.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> Por que é recomendado usar <code>rem</code> em vez de <code>px</code> para <code>font-size</code>?</p>
  <button data-option="a">Porque <code>rem</code> respeita as preferências de tamanho de fonte configuradas pelo usuário no navegador, enquanto <code>px</code> fixa o tamanho independentemente dessas preferências — o que constitui uma falha de acessibilidade.</button>
  <button data-option="b">Porque <code>rem</code> é calculado mais rapidamente pelo navegador do que <code>px</code>.</button>
  <button data-option="c">Porque <code>px</code> não funciona em dispositivos com telas de alta densidade (Retina).</button>
  <button data-option="d">Porque <code>rem</code> é relativo ao elemento pai, facilitando o controle tipográfico local.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Estilizar a página HTML do projeto do 1º Bimestre aplicando: reset com `box-sizing: border-box`, sistema de variáveis CSS no `:root`, tipografia com Web Font do Google Fonts, paleta de cores consistente, e posicionamento correto de `header` fixo e `footer`. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 6 — Introdução à Acessibilidade Web](06-acessibilidade.md)
[:material-arrow-right: Ir ao Capítulo 8 — Layout com Flexbox](08-flexbox.md)
