# Capítulo 10 — Design Responsivo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 10.1 — O que é design responsivo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **design responsivo** (*responsive web design*) é a abordagem de desenvolvimento que permite que uma página web se adapte e apresente uma experiência adequada em qualquer dispositivo — independentemente do tamanho da tela, da resolução, da orientação ou das capacidades do navegador. O termo foi cunhado por **Ethan Marcotte** em um artigo seminal publicado na revista A List Apart em maio de 2010, e rapidamente se tornou o paradigma dominante do desenvolvimento front-end moderno.

A motivação para o design responsivo é direta: ao contrário de uma publicação impressa — que possui dimensões físicas fixas e conhecidas no momento da criação —, uma página web é acessada em um espectro de dispositivos de características radicalmente diferentes. Segundo dados do **StatCounter** (2025), o tráfego web mobile representa globalmente mais de 60% do total de acessos. No Brasil, esse percentual é ainda mais expressivo, com dispositivos móveis respondendo por aproximadamente 65% das sessões.

### 10.1.1 — O problema da multiplicidade de dispositivos

O desenvolvedor web contemporâneo projeta para um espectro que inclui:

- Smartphones com telas de 320px a 430px de largura
- Tablets entre 600px e 1024px
- Laptops entre 1024px e 1440px
- Monitores *widescreen* de 1440px a 2560px ou mais
- TVs com navegadores embutidos
- Dispositivos *wearable* com telas mínimas
- Leitores de tela sem dimensão visual

Antes do design responsivo, a resposta comum a essa diversidade era manter duas versões separadas do site — uma para desktop (`www.site.com`) e uma para mobile (`m.site.com`). Essa abordagem gerou problemas graves: duplicação de conteúdo, inconsistência entre versões, custo de manutenção dobrado e ausência de cobertura para o vasto espaço entre os dois extremos.

O design responsivo resolve esse problema com uma única base de código que se adapta fluidamente a qualquer contexto.

### 10.1.2 — Os três pilares do design responsivo

Ethan Marcotte definiu o design responsivo como a combinação de três técnicas fundamentais:

**1. Grade fluida (*fluid grid*):** utilizar unidades relativas (`%`, `fr`, `em`, `rem`) em vez de pixels fixos para dimensionamento e layout — permitindo que a estrutura da página se expanda e contraia proporcionalmente ao viewport.

**2. Imagens flexíveis (*flexible images*):** garantir que imagens e outros elementos de mídia nunca ultrapassem os limites do seu container — evitando overflow horizontal em telas pequenas.

**3. Media queries:** aplicar regras CSS específicas condicionalmente, com base nas características do dispositivo — permitindo ajustes de layout, tipografia e apresentação em breakpoints definidos.

Os Capítulos 8 e 9 já cobriram a grade fluida com Flexbox e Grid. Este capítulo aprofunda as media queries e as técnicas modernas que complementam e às vezes substituem a abordagem clássica de breakpoints.

### 10.1.3 — Viewport: o que é e por que importa

O **viewport** é a área retangular do navegador onde o conteúdo web é renderizado — em essência, a janela visível da página. Em desktops, o viewport corresponde aproximadamente à área da janela do navegador descontando barras de ferramentas.

Em dispositivos móveis, contudo, existe uma distinção importante entre dois tipos de viewport:

**Viewport de layout (*layout viewport*):** a área em que o navegador renderiza a página. Por padrão, a maioria dos navegadores móveis define o layout viewport como 980px de largura — uma herança do design desktop — e depois escala o resultado para caber na tela física. Isso faz com que páginas não otimizadas para mobile apareçam "encolhidas" e ilegíveis.

**Viewport visual (*visual viewport*):** a área efetivamente visível na tela do dispositivo, que pode ser menor que o layout viewport quando o usuário dá zoom.

A solução para o layout viewport inflado é a meta tag `viewport`.

### 10.1.4 — A meta tag `viewport` e seu papel no mobile

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
```

Esta declaração, que deve estar presente em **todo documento HTML responsivo**, instrui o navegador a:

- **`width=device-width`:** definir o layout viewport com a largura real do dispositivo (em vez dos 980px padrão)
- **`initial-scale=1.0`:** não aplicar zoom inicial — a página é exibida em escala 1:1

Sem essa meta tag, as media queries baseadas em `max-width` simplesmente não funcionam corretamente em dispositivos móveis — o navegador aplica a versão desktop porque o layout viewport reportado é de 980px, não da largura real do dispositivo.

```html
<!-- Obrigatório em todo projeto responsivo -->
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Página Responsiva</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
```

> **Referência:** [MDN — Viewport meta tag](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Viewport_meta_tag)

---

## 10.2 — Estratégia mobile-first vs desktop-first

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A escolha entre escrever CSS para mobile primeiro (*mobile-first*) ou para desktop primeiro (*desktop-first*) não é apenas uma preferência estilística — ela define a direção das media queries, a ordem de sobrescrita de estilos e, em última análise, a arquitetura de todo o CSS responsivo do projeto.

### 10.2.1 — O que significa cada abordagem

**Mobile-first:** os estilos base do CSS são escritos para telas pequenas. Media queries com `min-width` adicionam progressivamente complexidade para telas maiores:

```css
/* Mobile-first: estilos base para telas pequenas */
.container {
  display: flex;
  flex-direction: column; /* empilhado em mobile */
  padding: 1rem;
}

/* Tablet: a partir de 768px, muda para linha */
@media (min-width: 768px) {
  .container {
    flex-direction: row;
    padding: 2rem;
  }
}

/* Desktop: a partir de 1024px, adiciona mais espaço */
@media (min-width: 1024px) {
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 3rem;
  }
}
```

**Desktop-first:** os estilos base são escritos para telas grandes. Media queries com `max-width` removem ou simplificam para telas menores:

```css
/* Desktop-first: estilos base para telas grandes */
.container {
  display: flex;
  flex-direction: row;
  max-width: 1200px;
  margin: 0 auto;
  padding: 3rem;
}

/* Tablet: até 1024px, reduz espaço */
@media (max-width: 1024px) {
  .container {
    padding: 2rem;
  }
}

/* Mobile: até 768px, empilha */
@media (max-width: 768px) {
  .container {
    flex-direction: column;
    padding: 1rem;
  }
}
```

### 10.2.2 — Por que mobile-first é a abordagem recomendada

A preferência pelo mobile-first não é arbitrária — ela tem justificativas técnicas, estratégicas e de desempenho:

**Desempenho em dispositivos móveis:** navegadores móveis baixam e processam todo o CSS antes de renderizar a página. Com desktop-first, um dispositivo móvel processa todos os estilos complexos de desktop e depois os sobrescreve com simplificações — trabalho desnecessário. Com mobile-first, os estilos simples são aplicados primeiro; as media queries de desktop são ignoradas em dispositivos que não as atendem.

**Priorização do conteúdo:** forçar-se a projetar para a menor tela primeiro obriga o desenvolvedor a identificar o conteúdo verdadeiramente essencial — aquele que merece espaço na tela de 375px. Esta disciplina tende a produzir interfaces mais focadas e objetivas em todos os tamanhos de tela.

**Progressão natural:** é conceitualmente mais simples adicionar complexidade (colunas, espaçamentos maiores, elementos adicionais) para telas maiores do que remover complexidade para telas menores.

**Alinhamento com o mercado:** com mobile representando a maioria dos acessos globais, projetar mobile como experiência primária e desktop como aprimoramento é a ordem correta de prioridade.

### 10.2.3 — Impacto na escrita das media queries

A direção da abordagem define diretamente os operadores das media queries:

| Abordagem | Operador | Direção |
|---|---|---|
| Mobile-first | `min-width` | Pequeno → Grande (additive) |
| Desktop-first | `max-width` | Grande → Pequeno (subtractive) |

```css
/* Mobile-first: cada media query ADICIONA ao anterior */
/* Estilos base → mobile */
.nav { flex-direction: column; }

/* + tablet */
@media (min-width: 768px) {
  .nav { flex-direction: row; }
}

/* + desktop */
@media (min-width: 1024px) {
  .nav { gap: 2rem; }
}
```

---

## 10.3 — Media queries

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

As **media queries** são o mecanismo do CSS que permite aplicar regras condicionalmente com base nas características do dispositivo ou do ambiente de exibição. Elas são o terceiro pilar do design responsivo e a ferramenta mais direta para adaptar layouts a diferentes contextos.

### 10.3.1 — Sintaxe básica: `@media`

```css
@media tipo-de-midia and (feature: valor) {
  /* regras CSS aplicadas somente quando a condição é verdadeira */
}

/* Exemplos */
@media screen and (min-width: 768px) {
  .container { max-width: 1200px; }
}

@media print {
  .navbar, .sidebar { display: none; }
  body { font-size: 12pt; color: black; }
}
```

A estrutura de uma media query é composta por:
- **`@media`** — declaração de início
- **Tipo de mídia** (opcional) — `screen`, `print`, `all`
- **`and`** — operador lógico (quando tipo + feature)
- **Feature query** entre parênteses — a condição a verificar

### 10.3.2 — Tipos de mídia

| Tipo | Descrição |
|---|---|
| `all` | Todos os dispositivos (padrão quando omitido) |
| `screen` | Telas: monitores, smartphones, tablets |
| `print` | Impressão e pré-visualização de impressão |
| `speech` | Sintetizadores de voz (leitores de tela) |

```css
/* Estilos específicos para impressão */
@media print {
  /* Oculta elementos desnecessários na impressão */
  nav, aside, .btn, .cookie-banner {
    display: none !important;
  }

  /* Tipografia adequada para papel */
  body {
    font-family: Georgia, serif;
    font-size: 12pt;
    line-height: 1.5;
    color: black;
    background: white;
  }

  /* Garante que links sejam identificáveis */
  a[href]::after {
    content: " (" attr(href) ")";
    font-size: 0.8em;
    color: #555;
  }

  /* Evita quebras de página dentro de elementos importantes */
  article, figure, table {
    page-break-inside: avoid;
  }
}
```

### 10.3.3 — Feature queries: dimensão, orientação e preferências do usuário

**Dimensão do viewport**

```css
/* min-width: aplica a partir de N pixels (mobile-first) */
@media (min-width: 768px)  { /* tablet e acima */ }
@media (min-width: 1024px) { /* desktop e acima */ }
@media (min-width: 1440px) { /* widescreen */ }

/* max-width: aplica até N pixels (desktop-first) */
@media (max-width: 1023px) { /* abaixo de desktop */ }
@media (max-width: 767px)  { /* abaixo de tablet = mobile */ }

/* Intervalo: combinação de min e max */
@media (min-width: 768px) and (max-width: 1023px) {
  /* apenas tablet */
}

/* Altura do viewport */
@media (min-height: 800px) {
  .hero { min-height: 100vh; }
}
```

**Orientação**

```css
@media (orientation: portrait) {
  /* tela mais alta do que larga — típico de mobile em pé */
  .galeria { grid-template-columns: repeat(2, 1fr); }
}

@media (orientation: landscape) {
  /* tela mais larga do que alta — mobile deitado, desktop */
  .galeria { grid-template-columns: repeat(4, 1fr); }
}
```

**`prefers-color-scheme` — tema claro ou escuro**

Permite adaptar o visual às preferências de tema do sistema operacional do usuário — uma funcionalidade com impacto direto em acessibilidade e conforto visual:

```css
/* Tema claro: padrão */
:root {
  --cor-fundo: #F7F5F2;
  --cor-texto: #333333;
  --cor-primaria: #12243A;
  --cor-card: #FFFFFF;
}

/* Tema escuro: aplicado automaticamente quando o SO está em dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --cor-fundo: #1a1a2e;
    --cor-texto: #e0e0e0;
    --cor-primaria: #A8D8EA;
    --cor-card: #16213e;
  }
  /* Com variáveis CSS, toda a paleta muda com apenas estas linhas */
}
```

Esta abordagem, combinada com variáveis CSS (Capítulo 7, seção 7.12), é o padrão moderno para implementação de tema escuro — sem duplicar regras CSS.

**`prefers-reduced-motion` — respeito por preferências de movimento**

Usuários com epilepsia fotossensível, vertigem ou distúrbios vestibulares podem configurar seu sistema operacional para reduzir animações. Esta media query permite respeitar essa preferência:

```css
/* Animações padrão */
.btn {
  transition: transform 300ms ease, background-color 200ms ease;
}

.btn:hover {
  transform: scale(1.05);
}

.loading-spinner {
  animation: girar 1s linear infinite;
}

/* Remove ou simplifica animações quando o usuário prefere menos movimento */
@media (prefers-reduced-motion: reduce) {
  .btn {
    transition: background-color 200ms ease; /* mantém apenas cor */
  }

  .btn:hover {
    transform: none; /* remove escala */
  }

  .loading-spinner {
    animation: none; /* remove animação contínua */
  }

  /* Regra global: desabilita todas as transições e animações */
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

> **Conexão com acessibilidade:** `prefers-reduced-motion` é relevante para o critério WCAG 2.1 **2.3.3 — Animação por Interação (nível AAA)** e é considerada boa prática mesmo no nível AA. Sua implementação é simples e o impacto para usuários afetados é significativo.

**`prefers-contrast` — contraste elevado**

```css
@media (prefers-contrast: more) {
  :root {
    --cor-texto: #000000;
    --cor-fundo: #FFFFFF;
    --cor-borda: #000000;
  }

  .btn {
    border: 2px solid currentColor;
  }
}
```

### 10.3.4 — Operadores lógicos: `and`, `not` e `or` (`,`)

```css
/* and: todas as condições devem ser verdadeiras */
@media screen and (min-width: 768px) and (orientation: landscape) {
  /* tela, largura ≥ 768px E orientação paisagem */
}

/* , (vírgula = or): pelo menos uma condição deve ser verdadeira */
@media (max-width: 767px), (orientation: portrait) {
  /* mobile OU orientação retrato */
}

/* not: nega a condição */
@media not print {
  /* tudo exceto impressão */
}

/* not em feature específica */
@media (not (prefers-color-scheme: dark)) {
  /* apenas quando NÃO está em dark mode */
}
```

### 10.3.5 — Breakpoints: o que são, como definir e valores comuns

**Breakpoints** são os valores de largura nos quais o layout muda de forma significativa. Não existe um conjunto universalmente "correto" de breakpoints — eles devem emergir do conteúdo e do design, não de modelos de dispositivos específicos.

**Valores comuns (referência, não prescrição):**

```css
/* Sistema de breakpoints típico — mobile-first */
:root {
  /* sm: dispositivos móveis grandes / landscape */
  /* @media (min-width: 480px) */

  /* md: tablets */
  /* @media (min-width: 768px) */

  /* lg: laptops / desktop pequeno */
  /* @media (min-width: 1024px) */

  /* xl: desktop */
  /* @media (min-width: 1280px) */

  /* 2xl: widescreen */
  /* @media (min-width: 1536px) */
}
```

**A abordagem correta:** definir breakpoints onde o layout *precisa* mudar, não onde um dispositivo específico começa. O processo recomendado é redimensionar o navegador lentamente e adicionar um breakpoint quando o layout "quebrar" — quando o texto ficar ilegível, as colunas ficarem estreitas demais ou o espaçamento inadequado.

```css
/* Breakpoints baseados no conteúdo, não em dispositivos */
@media (min-width: 600px) {
  /* o layout de coluna única fica inadequado a partir daqui */
  .grade { grid-template-columns: repeat(2, 1fr); }
}

@media (min-width: 900px) {
  /* três colunas cabem confortavelmente a partir daqui */
  .grade { grid-template-columns: repeat(3, 1fr); }
}
```

### 10.3.6 — A sintaxe moderna de range

A especificação **Media Queries Level 4** introduziu uma sintaxe de intervalo mais legível e expressiva, já suportada pelos navegadores modernos:

```css
/* Sintaxe clássica */
@media (min-width: 768px) and (max-width: 1023px) { }

/* Sintaxe moderna de range — equivalente e mais legível */
@media (768px <= width <= 1023px) { }
@media (width >= 768px) { }
@media (width < 1024px) { }

/* Exemplos */
@media (width >= 768px) {
  .container { max-width: 1200px; }
}

@media (600px <= width <= 900px) {
  .grade { grid-template-columns: repeat(2, 1fr); }
}
```

> **Compatibilidade:** a sintaxe de range tem suporte em Chrome 113+, Firefox 63+, Safari 16.4+. Para projetos que precisam suportar navegadores mais antigos, a sintaxe clássica com `min-width`/`max-width` ainda é necessária. Verifique o suporte atual em [caniuse.com/css-media-range-syntax](https://caniuse.com/css-media-range-syntax).

---

## 10.4 — Layout adaptativo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 10.4.1 — Mudança de layout com Flexbox em breakpoints

```css
/* Mobile-first: empilhado por padrão */
.secao-hero {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  padding: 2rem 1rem;
}

.secao-hero__texto { order: 2; } /* texto abaixo da imagem em mobile */
.secao-hero__imagem { order: 1; }

/* Tablet e acima: lado a lado */
@media (min-width: 768px) {
  .secao-hero {
    flex-direction: row;
    align-items: center;
    padding: 4rem 2rem;
  }

  .secao-hero__texto {
    flex: 1;
    order: 1; /* texto volta à esquerda */
  }

  .secao-hero__imagem {
    flex: 0 0 400px;
    order: 2;
  }
}

/* Desktop: mais espaçamento */
@media (min-width: 1024px) {
  .secao-hero {
    padding: 6rem 4rem;
    gap: 4rem;
  }
}
```

### 10.4.2 — Mudança de layout com Grid e `grid-template-areas`

O padrão mais elegante para layouts responsivos complexos — o container muda, os itens permanecem intocados:

```css
/* Mobile: coluna única */
.pagina {
  display: grid;
  grid-template-areas:
    "header"
    "main  "
    "aside "
    "footer";
  grid-template-rows: auto 1fr auto auto;
}

/* Tablet: sidebar ao lado */
@media (min-width: 768px) {
  .pagina {
    grid-template-columns: 1fr 240px;
    grid-template-rows: auto 1fr auto;
    grid-template-areas:
      "header header"
      "main   aside "
      "footer footer";
  }
}

/* Desktop: sidebar mais larga */
@media (min-width: 1024px) {
  .pagina {
    grid-template-columns: 1fr 300px;
    max-width: 1400px;
    margin: 0 auto;
  }
}

/* Itens: não mudam em nenhum breakpoint */
.cabecalho { grid-area: header; }
.conteudo  { grid-area: main;   }
.lateral   { grid-area: aside;  }
.rodape    { grid-area: footer; }
```

### 10.4.3 — Ocultando e revelando elementos por breakpoint

```css
/* Ocultar em mobile, mostrar a partir de tablet */
.apenas-desktop {
  display: none;
}

@media (min-width: 768px) {
  .apenas-desktop {
    display: block; /* ou flex, grid, inline, etc. */
  }
}

/* Ocultar a partir de tablet (visível apenas em mobile) */
.apenas-mobile {
  display: block;
}

@media (min-width: 768px) {
  .apenas-mobile {
    display: none;
  }
}
```

> **⚠️ Acessibilidade:** `display: none` remove o elemento tanto visualmente quanto da árvore de acessibilidade — leitores de tela não o percebem. Se o conteúdo é importante para acessibilidade mas deve ser ocultado visualmente, use a técnica de **visually hidden**:
>
> ```css
> .visually-hidden {
>   position: absolute;
>   width: 1px;
>   height: 1px;
>   padding: 0;
>   margin: -1px;
>   overflow: hidden;
>   clip: rect(0, 0, 0, 0);
>   white-space: nowrap;
>   border: 0;
> }
> ```
>
> Esta classe oculta o elemento visualmente mas o mantém acessível para leitores de tela — usada para rótulos e textos de contexto que só fazem sentido auditivamente.

### 10.4.4 — Reordenação responsiva com `order` e suas implicações

Como discutido nos Capítulos 8 e 9, `order` altera apenas a apresentação visual — leitores de tela e navegação por teclado seguem a ordem do DOM. A recomendação é:

**Quando a reordenação é para conveniência visual** (ex.: imagem antes do texto em mobile), `order` é aceitável desde que a experiência de leitura faça sentido em qualquer ordem:

```css
/* Imagem aparece visualmente antes do texto em mobile */
.hero__imagem { order: 1; }
.hero__texto  { order: 2; }

/* Em desktop, inverte: texto à esquerda, imagem à direita */
@media (min-width: 768px) {
  .hero__texto  { order: 1; }
  .hero__imagem { order: 2; }
}
```

**Quando a ordem tem significado semântico**, a solução correta é organizar o DOM na ordem que faz sentido para leitura e usar CSS para o layout visual — não usar `order` para simular uma ordem diferente.

---

## 10.5 — Técnicas modernas de responsividade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

As técnicas desta seção representam a evolução do design responsivo além das media queries — abordagens que permitem layouts fluidos e adaptativos sem (ou com menos) breakpoints explícitos.

### 10.5.1 — Imagens responsivas: `max-width` e `object-fit`

**`max-width: 100%` — a regra fundamental**

A regra mais simples e mais importante para imagens responsivas: nunca deixar uma imagem ultrapassar o seu container:

```css
/* Reset de imagens responsivas — deve estar no CSS global */
img,
video,
canvas,
svg {
  display: block;
  max-width: 100%;
  height: auto; /* mantém proporção */
}
```

Com `max-width: 100%`, a imagem ocupa no máximo 100% da largura do seu container — se o container encolher, a imagem encolhe proporcionalmente. Se a imagem for naturalmente menor que o container, ela permanece em seu tamanho original.

**`object-fit` — controle de proporção em containers dimensionados**

Quando uma imagem precisa preencher um container com dimensões fixas (como cards de altura igual), `object-fit` controla como a imagem se comporta:

```css
.card__imagem {
  width: 100%;
  height: 220px;      /* altura fixa */
  object-fit: cover;  /* preenche o container, pode cortar */
  object-position: center top; /* foca no topo da imagem */
}

/* Valores de object-fit */
img {
  object-fit: fill;     /* estica para preencher — distorce */
  object-fit: contain;  /* cabe inteira — pode deixar espaço */
  object-fit: cover;    /* preenche e corta — mais usado */
  object-fit: none;     /* tamanho original — pode transbordar */
  object-fit: scale-down; /* menor entre none e contain */
}
```

### 10.5.2 — Tipografia fluida com `clamp()`

A abordagem clássica de tipografia responsiva usa media queries para definir tamanhos em breakpoints:

```css
/* Abordagem clássica: saltos abruptos nos breakpoints */
h1 { font-size: 1.75rem; }

@media (min-width: 768px)  { h1 { font-size: 2.25rem; } }
@media (min-width: 1024px) { h1 { font-size: 3rem; } }
```

A função `clamp()` permite tipografia que **escala continuamente** entre um mínimo e um máximo, sem saltos:

```css
/* clamp(mínimo, preferido, máximo) */
h1 {
  font-size: clamp(1.75rem, 4vw, 3rem);
  /* Em 320px:  1.75rem (mínimo ativo: 4vw = 12.8px < 28px) */
  /* Em 700px:  ~1.75rem (4vw ≈ 28px = 1.75rem) */
  /* Em 900px:  ~2.25rem (4vw = 36px) */
  /* Em 1200px: 3rem (máximo ativo: 4vw = 48px > 48px) */
}

h2 { font-size: clamp(1.375rem, 3vw, 2.25rem); }
h3 { font-size: clamp(1.125rem, 2.5vw, 1.75rem); }
p  { font-size: clamp(1rem, 1.5vw, 1.125rem); }
```

**Calculando o valor preferido para `clamp()`**

O valor intermediário de `clamp()` geralmente usa `vw` (ou uma combinação de `vw` + `rem`) para criar uma escala suave. Uma fórmula útil para calcular o valor preferido:

```
valor-vw = (tamanho-max - tamanho-min) / (viewport-max - viewport-min) × 100
```

Ferramentas online como **Fluid Type Scale** ([utopia.fyi](https://utopia.fyi)) geram automaticamente escalas tipográficas fluidas com `clamp()`.

### 10.5.3 — Espaçamento fluido com `clamp()`

O mesmo princípio se aplica a margens, paddings e gaps — criando espaçamentos que escalam suavemente com o viewport:

```css
:root {
  /* Espaçamentos fluidos */
  --espaco-sm:  clamp(0.75rem, 2vw, 1rem);
  --espaco-md:  clamp(1rem,    3vw, 2rem);
  --espaco-lg:  clamp(2rem,    5vw, 4rem);
  --espaco-xl:  clamp(3rem,    8vw, 6rem);
}

.secao {
  padding: var(--espaco-xl) var(--espaco-lg);
}

.grade {
  gap: var(--espaco-md);
}

h1 {
  margin-bottom: var(--espaco-sm);
}
```

Esta abordagem, combinada com variáveis CSS, cria um sistema de espaçamento que se adapta a qualquer viewport sem uma única media query para espaçamento.

### 10.5.4 — Layout fluido com unidades relativas

Layouts baseados em `%` e `fr` são intrinsecamente fluidos — eles se adaptam ao viewport sem media queries. A combinação de unidades relativas com limites (`max-width`, `min-width`, `clamp()`) cria layouts que funcionam em toda a faixa de tamanhos:

```css
/* Container fluido com largura máxima */
.container {
  width: 90%;         /* fluido */
  max-width: 1200px;  /* nunca passa disso */
  margin: 0 auto;     /* centralizado */
}

/* Grade de cards fluida — sem media queries */
.grade-fluida {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(280px, 100%), 1fr));
  gap: clamp(1rem, 3vw, 2rem);
}
/* min(280px, 100%): em viewports < 280px, o card ocupa 100% em vez de 280px */
```

**O padrão `min(280px, 100%)`** é um refinamento importante: em vez de `minmax(280px, 1fr)` — que pode forçar overflow horizontal em viewports menores que 280px —, `min(280px, 100%)` garante que o item nunca seja maior que seu container:

```css
/* Mais robusto que minmax(280px, 1fr) */
.grade-robusta {
  grid-template-columns: repeat(auto-fit, minmax(min(280px, 100%), 1fr));
}
```

### 10.5.5 — Container queries: responsividade baseada no container

As **container queries** são uma das adições mais significativas ao CSS nos últimos anos — suportadas em todos os navegadores modernos desde 2023. Elas permitem que um componente se adapte ao tamanho do seu **container imediato**, não do viewport global.

**Por que container queries importam**

O problema das media queries tradicionais é que elas são globais: um componente de card não sabe em qual contexto está sendo usado. O mesmo card pode aparecer numa coluna larga na página inicial e numa coluna estreita na sidebar — mas com media queries, ele só consegue reagir ao viewport, não ao seu container real.

```css
/* Media query tradicional: reage ao viewport */
@media (min-width: 768px) {
  .card { flex-direction: row; }
}
/* Problema: o card usa layout de linha mesmo quando está numa coluna estreita */
```

Com container queries, o card reage ao seu próprio container:

```css
/* 1. Definir o container de referência */
.card-wrapper {
  container-type: inline-size; /* monitora a largura inline */
  container-name: card;        /* nome opcional para referência */
}

/* 2. Estilos base do card (mobile-first) */
.card {
  display: flex;
  flex-direction: column;
}

/* 3. Container query: quando o container tiver ≥ 400px */
@container card (min-width: 400px) {
  .card {
    flex-direction: row;
    align-items: center;
  }

  .card__imagem {
    flex: 0 0 160px;
  }
}
```

**Sintaxe completa:**

```css
/* container-type: define como o container é medido */
.wrapper {
  container-type: inline-size; /* monitora largura (mais comum) */
  container-type: size;        /* monitora largura E altura */
  container-type: normal;      /* padrão: não é container */
}

/* @container: a query em si */
@container (min-width: 600px) {
  /* sem nome: aplica ao container mais próximo */
}

@container card (min-width: 400px) {
  /* com nome: aplica ao container chamado "card" */
}

/* Unidades de container: cqi, cqb, cqw, cqh */
.card__titulo {
  font-size: clamp(1rem, 5cqi, 1.5rem);
  /* 5cqi = 5% da largura inline do container */
}
```

**Exemplo prático: card adaptativo**

```html
<!-- Mesmo componente em dois contextos diferentes -->
<div class="grade-principal">
  <div class="card-wrapper">
    <article class="card">...</article>
  </div>
</div>

<aside class="sidebar">
  <div class="card-wrapper">
    <article class="card">...</article>  <!-- mesmo HTML -->
  </div>
</aside>
```

```css
.card-wrapper {
  container-type: inline-size;
}

/* Card: layout coluna por padrão */
.card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 1rem;
}

/* Card: layout linha quando container ≥ 380px */
@container (min-width: 380px) {
  .card {
    flex-direction: row;
    align-items: center;
  }

  .card__imagem {
    flex: 0 0 120px;
    height: 120px;
  }
}

/* Card: mais espaçamento quando container ≥ 600px */
@container (min-width: 600px) {
  .card {
    padding: 1.5rem;
    gap: 1.5rem;
  }

  .card__imagem {
    flex: 0 0 200px;
    height: 160px;
  }
}
```

Na grade principal (container largo), o card usa layout horizontal com imagem grande. Na sidebar (container estreito), o mesmo card usa layout vertical — automaticamente, sem media queries baseadas no viewport.

> **Referências:**
> - [MDN — Container queries](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_containment/Container_queries)
> - [Can I Use — Container queries](https://caniuse.com/css-container-queries)
> - [Una Kravets — Container queries explained](https://web.dev/articles/cq-stable)

---

**Referências gerais do capítulo:**
- [MDN — Design responsivo](https://developer.mozilla.org/pt-BR/docs/Learn/CSS/CSS_layout/Responsive_Design)
- [MDN — Media queries](https://developer.mozilla.org/pt-BR/docs/Web/CSS/CSS_media_queries/Using_media_queries)
- [Ethan Marcotte — Responsive Web Design (artigo original)](https://alistapart.com/article/responsive-web-design/)
- [Utopia — Fluid type & space scales](https://utopia.fyi)
- [Every Layout — Layouts sem media queries](https://every-layout.dev)

---

#### **Atividades — Capítulo 10**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Por que a meta tag <code>&lt;meta name="viewport" content="width=device-width, initial-scale=1.0"&gt;</code> é obrigatória em páginas responsivas?</p>
  <button data-option="a">Porque sem ela o CSS não é carregado em dispositivos móveis.</button>
  <button data-option="b">Porque sem ela navegadores móveis definem o layout viewport como 980px por padrão, fazendo com que a página seja renderizada em escala reduzida e as media queries de largura não funcionem corretamente.</button>
  <button data-option="c">Porque ela define o tamanho máximo da página em todos os dispositivos.</button>
  <button data-option="d">Porque ela instrui o navegador a carregar versões otimizadas de imagens para mobile.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Qual é a vantagem técnica da abordagem mobile-first em relação ao desktop-first para dispositivos móveis?</p>
  <button data-option="a">Mobile-first usa menos media queries no total.</button>
  <button data-option="b">Mobile-first é obrigatório pela especificação CSS — desktop-first não é tecnicamente válido.</button>
  <button data-option="c">Dispositivos móveis processam os estilos base simples e ignoram as media queries de desktop; com desktop-first, processam e sobrescrevem os estilos complexos desnecessariamente — gerando trabalho extra.</button>
  <button data-option="d">Mobile-first melhora automaticamente o posicionamento nos mecanismos de busca.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual é a principal vantagem das container queries em relação às media queries tradicionais para componentes reutilizáveis como cards?</p>
  <button data-option="a">Container queries têm melhor desempenho de renderização que media queries.</button>
  <button data-option="b">Container queries funcionam em navegadores mais antigos que não suportam media queries.</button>
  <button data-option="c">Container queries permitem usar unidades de viewport dentro de componentes.</button>
  <button data-option="d">Container queries permitem que um componente se adapte ao tamanho do seu container imediato — não do viewport global — resolvendo o problema de componentes usados em múltiplos contextos de largura diferente na mesma página.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> O valor <code>font-size: clamp(1rem, 4vw, 2.5rem)</code> em um viewport de 400px resulta em qual tamanho (considerando 1rem = 16px)?</p>
  <button data-option="a">16px — o mínimo, pois 4vw = 16px = 1rem, e o mínimo de clamp() se aplica quando o valor preferido é menor ou igual ao mínimo.</button>
  <button data-option="b">40px — 4vw em um viewport de 400px é sempre o valor aplicado.</button>
  <button data-option="c">2.5rem (40px) — o máximo é sempre aplicado em viewports pequenos.</button>
  <button data-option="d">0px — clamp() não funciona em viewports menores que 768px.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Tornar o projeto do bimestre completamente responsivo aplicando: meta tag viewport, estratégia mobile-first, ao menos três breakpoints com media queries, tipografia fluida com `clamp()` nos títulos, e `prefers-color-scheme` para suporte a tema escuro via variáveis CSS. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 9 — Layout com Grid](09-grid.md)
[:material-arrow-right: Ir ao Capítulo 11 — Variáveis CSS e Design System](11-design-system.md)
