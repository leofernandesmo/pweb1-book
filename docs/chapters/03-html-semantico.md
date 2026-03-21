# Capítulo 3 — HTML Semântico

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 3.1 — O que é semântica no contexto do HTML

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A palavra **semântica** deriva do grego *sēmantikós*, que significa "relativo ao significado". No contexto da linguagem HTML, o termo designa a prática de escolher elementos de marcação não com base em sua aparência visual padrão, mas com base no **significado** que eles atribuem ao conteúdo que delimitam.

Esta distinção — aparentemente sutil — tem consequências técnicas profundas. Considere dois trechos de código que produzem resultado visual idêntico no navegador:

```html
<!-- Abordagem não semântica -->
<div style="font-size: 2em; font-weight: bold;">Bem-vindo ao curso</div>

<!-- Abordagem semântica -->
<h1>Bem-vindo ao curso</h1>
```

Para o olho humano, o resultado renderizado pode ser indistinguível. Para um leitor de tela, para um mecanismo de busca e para o próprio navegador, contudo, a diferença é fundamental: o elemento `<h1>` comunica que aquele texto é o **título principal do documento**, enquanto o `<div>` estilizado comunica apenas uma instrução de formatação visual — sem qualquer significado estrutural intrínseco.

O HTML semântico, portanto, não é uma preferência estética ou uma convenção opcional: é a aplicação correta da linguagem conforme sua especificação. O WHATWG (*Web Hypertext Application Technology Working Group*), responsável pelo **HTML Living Standard**, define para cada elemento não apenas sua renderização padrão, mas sua **semântica** — isto é, o tipo de conteúdo que ele representa e o papel que desempenha na estrutura do documento.

### 3.1.1 — A separação entre estrutura, apresentação e comportamento

Um dos princípios arquiteturais mais importantes do desenvolvimento web moderno é a **separação de responsabilidades** entre as três tecnologias fundamentais da Web:

- **HTML** — define a estrutura e o significado do conteúdo
- **CSS** — define a apresentação visual
- **JavaScript** — define o comportamento interativo

O HTML semântico é a realização plena desse princípio na camada de marcação. Quando se utiliza um `<h2>` para marcar um subtítulo, está-se comunicando estrutura e significado — não aparência. O tamanho visual do `<h2>` pode ser alterado livremente via CSS; o que não muda é seu papel semântico no documento.

A violação desse princípio — utilizando `<div>` e `<span>` para tudo, e CSS para simular a aparência de títulos, listas e seções — produz documentos tecnicamente funcionais para usuários sem necessidades especiais, mas estruturalmente opacos: inacessíveis para tecnologias assistivas, pouco indexáveis por mecanismos de busca e de difícil manutenção.

### 3.1.2 — Por que a semântica importa: quatro dimensões

**Acessibilidade**

Tecnologias assistivas como leitores de tela (*screen readers*) — software utilizado por pessoas com deficiência visual para navegar na Web de forma auditiva ou tátil (via display Braille) — dependem inteiramente da estrutura semântica do documento para funcionar corretamente. Um leitor de tela constrói uma representação auditiva da página interpretando os elementos HTML: ele anuncia "título de nível 1", "lista com 5 itens", "link", "botão". Sem a semântica correta, essa representação se torna incoerente ou inacessível.

As diretrizes **WCAG 2.1** (*Web Content Accessibility Guidelines*), publicadas pelo W3C, estabelecem que o uso correto de elementos semânticos é requisito de conformidade nos níveis A e AA — os níveis mínimos exigidos por legislações de acessibilidade digital em vários países, incluindo o Brasil (Lei Brasileira de Inclusão, Lei nº 13.146/2015).

**Indexabilidade (SEO)**

Os algoritmos dos mecanismos de busca modernos utilizam a estrutura semântica do documento para inferir a hierarquia e a relevância do conteúdo. Um `<h1>` possui peso semântico significativamente superior ao de um parágrafo; o conteúdo dentro de um `<article>` é tratado como conteúdo editorial primário; o conteúdo em um `<nav>` é reconhecido como navegação e não como conteúdo relevante para indexação. A semântica correta, portanto, influencia diretamente o posicionamento nos resultados de busca.

**Manutenibilidade**

Um documento HTML semanticamente estruturado é autoexplicativo. Ao analisar a hierarquia de elementos, qualquer desenvolvedor compreende imediatamente a arquitetura da página sem precisar interpretar classes CSS arbitrárias. Isso reduz o tempo de integração de novos membros em equipes e diminui a probabilidade de erros em manutenções futuras.

**Interoperabilidade**

Navegadores, leitores de RSS, aplicações de leitura (*read-it-later apps*), ferramentas de raspagem de dados (*web scraping*) e sistemas de síntese de voz todos se beneficiam de documentos semanticamente corretos para extrair e apresentar o conteúdo de forma adequada.

> #### 📜 A evolução da semântica no HTML
>
> O HTML original de 1991 era fortemente orientado à apresentação: elementos como `<font>`, `<center>` e `<b>` misturavam estrutura e aparência de forma indissociável. Com a adoção do CSS em 1996 e a publicação do HTML 4.01 em 1999, iniciou-se a separação entre estrutura e apresentação — mas a linguagem ainda carecia de elementos para descrever regiões funcionais de uma página.
>
> O **HTML5**, publicado pelo W3C em 2014, representou o salto semântico mais significativo da história da linguagem. Foram introduzidos elementos como `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>` e `<footer>`, que permitem descrever não apenas o conteúdo, mas sua **função** na arquitetura da página — algo que antes só era possível por convenção de classes CSS (`.header`, `.nav`, `.footer`).
>
> **Referência:** [WHATWG — HTML Living Standard: Semantics](https://html.spec.whatwg.org/multipage/semantics.html)

---

## 3.2 — Elementos de seção e sua semântica

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O HTML5 introduziu um conjunto de **elementos de seção** (*sectioning elements*) cujo propósito é delimitar as regiões funcionais canônicas de um documento web. Esses elementos não substituem o CSS na definição do layout visual — eles comunicam o **papel funcional** de cada região do documento.

É fundamental compreender que os elementos de seção **não produzem efeitos visuais automáticos**: não empurram conteúdo, não criam colunas, não aplicam espaçamento. Toda a apresentação visual continua sendo responsabilidade exclusiva do CSS. O que esses elementos oferecem é **significado semântico** interpretável por agentes de usuário, tecnologias assistivas e mecanismos de busca.

### 3.2.1 — `<header>`: cabeçalho

O elemento `<header>` representa o **conteúdo introdutório** de sua seção de escopo. Em seu uso mais comum — como filho direto do `<body>` — representa o cabeçalho global da página, tipicamente contendo logotipo, título principal e navegação primária. Contudo, `<header>` não é exclusivo do cabeçalho global: ele pode ser usado como cabeçalho de um `<article>` ou `<section>` específico, introduzindo o conteúdo daquele bloco.

```html
<!-- Cabeçalho global da página -->
<header>
  <img src="logo.svg" alt="Logotipo da instituição" />
  <h1>Programação Web 1</h1>
  <nav>
    <ul>
      <li><a href="/">Início</a></li>
      <li><a href="/capitulos">Capítulos</a></li>
    </ul>
  </nav>
</header>

<!-- Cabeçalho de um artigo específico -->
<article>
  <header>
    <h2>Introdução ao HTML Semântico</h2>
    <p>Publicado em <time datetime="2026-03-01">1º de março de 2026</time></p>
  </header>
  <p>Conteúdo do artigo...</p>
</article>
```

**Restrição importante:** o elemento `<header>` não pode ser descendente de `<address>`, `<footer>` ou de outro `<header>`.

### 3.2.2 — `<nav>`: navegação

O elemento `<nav>` delimita um conjunto de **links de navegação** de importância significativa. Não é necessário — nem recomendado — marcar todos os grupos de links da página com `<nav>`; o elemento deve ser reservado para blocos de navegação primária: menu principal, sumário de capítulo, navegação de paginação, índice de seções.

O atributo `aria-label` é especialmente importante quando uma página contém múltiplos elementos `<nav>`, pois permite que leitores de tela distingam entre eles:

```html
<!-- Navegação principal -->
<nav aria-label="Navegação principal">
  <ul>
    <li><a href="/">Início</a></li>
    <li><a href="/sobre">Sobre</a></li>
  </ul>
</nav>

<!-- Navegação secundária: sumário do capítulo -->
<nav aria-label="Sumário do capítulo">
  <ol>
    <li><a href="#secao-1">3.1 — O que é semântica</a></li>
    <li><a href="#secao-2">3.2 — Elementos de seção</a></li>
  </ol>
</nav>
```

### 3.2.3 — `<main>`: conteúdo principal

O elemento `<main>` delimita o **conteúdo principal e único** da página — o conteúdo diretamente relacionado ao seu tópico central, excluindo elementos que se repetem em outras páginas (cabeçalho, navegação, rodapé, barras laterais).

Duas regras fundamentais regem seu uso:

1. **Deve existir apenas um `<main>` por página** — múltiplas instâncias criariam ambiguidade sobre qual região contém o conteúdo central.
2. **Não deve ser descendente de `<article>`, `<aside>`, `<header>`, `<footer>` ou `<nav>`** — é sempre filho direto do `<body>` ou de um elemento de divisão genérico.

O `<main>` é especialmente relevante para acessibilidade: leitores de tela e tecnologias assistivas o utilizam como ponto de salto direto para o conteúdo principal, permitindo que o usuário ignore a navegação repetida no topo.

```html
<body>
  <header>...</header>
  <nav>...</nav>

  <main>
    <!-- Todo o conteúdo central da página vai aqui -->
    <h1>Título da página</h1>
    <p>Conteúdo principal...</p>
  </main>

  <footer>...</footer>
</body>
```

### 3.2.4 — `<article>`: conteúdo autônomo

O elemento `<article>` representa um **fragmento de conteúdo autônomo e independente** — um bloco que faria sentido existir isoladamente, sem o contexto do restante da página. O critério de autonomia é a chave para seu uso correto: se o conteúdo poderia ser publicado de forma independente (em outro site, num feed RSS, num e-mail), ele é um candidato ao `<article>`.

Exemplos de uso apropriado: postagens de blog, artigos jornalísticos, avaliações de produtos, comentários de usuários, fichas de produtos em um e-commerce, episódios de podcast.

```html
<main>
  <!-- Um artigo de blog -->
  <article>
    <header>
      <h2>O que é o protocolo HTTP?</h2>
      <p>Por Prof. Silva —
        <time datetime="2026-02-15">15 de fevereiro de 2026</time>
      </p>
    </header>

    <p>O HTTP (<em>Hypertext Transfer Protocol</em>) é o protocolo
    de comunicação que fundamenta a transferência de dados na Web...</p>

    <footer>
      <p>Categorias: <a href="/fundamentos">Fundamentos da Web</a></p>
    </footer>
  </article>

  <!-- Outro artigo independente -->
  <article>
    <h2>Introdução ao CSS</h2>
    <p>...</p>
  </article>
</main>
```

`<article>` pode ser **aninhado**: um artigo pode conter artigos filhos que representam conteúdo relacionado mas autônomo, como os comentários de uma postagem:

```html
<article>
  <h2>Postagem principal</h2>
  <p>Conteúdo da postagem...</p>

  <section>
    <h3>Comentários</h3>

    <!-- Cada comentário é um artigo autônomo -->
    <article>
      <header>
        <p>Comentário de <strong>Maria</strong></p>
      </header>
      <p>Excelente explicação!</p>
    </article>

    <article>
      <header>
        <p>Comentário de <strong>João</strong></p>
      </header>
      <p>Muito didático, obrigado.</p>
    </article>
  </section>
</article>
```

### 3.2.5 — `<section>`: seção temática

O elemento `<section>` delimita uma **seção temática genérica** de um documento ou aplicação. Seu critério de uso é distinto do `<article>`: enquanto `<article>` pressupõe autonomia (o conteúdo faz sentido sozinho), `<section>` pressupõe pertencimento — é uma parte de um todo maior, identificada por um tema específico.

A especificação do WHATWG recomenda que `<section>` seja utilizado apenas quando o conteúdo do bloco seria listado explicitamente no sumário do documento. Se o bloco não merece uma entrada no sumário — se é apenas um contêiner para fins de layout —, deve-se usar `<div>`.

Uma regra prática amplamente adotada: **`<section>` deve sempre conter um título** (`<h2>` a `<h6>`), pois é o título que identifica a seção como uma unidade temática distinta.

```html
<article>
  <h2>Guia completo de HTML</h2>

  <section>
    <h3>História do HTML</h3>
    <p>O HTML foi criado por Tim Berners-Lee em 1991...</p>
  </section>

  <section>
    <h3>Estrutura básica de um documento</h3>
    <p>Todo documento HTML possui uma estrutura mínima...</p>
  </section>

  <section>
    <h3>Elementos semânticos</h3>
    <p>O HTML5 introduziu um conjunto de elementos...</p>
  </section>
</article>
```

**`<article>` vs. `<section>`: a distinção fundamental**

Esta é uma das dúvidas mais comuns entre desenvolvedores iniciantes. A forma mais objetiva de distingui-los:

- Use `<article>` quando o conteúdo **faz sentido sozinho**, fora do contexto da página.
- Use `<section>` quando o conteúdo **é parte de um todo** e está agrupado por tema.
- Use `<div>` quando o agrupamento é **puramente estrutural ou de layout**, sem semântica.

### 3.2.6 — `<aside>`: conteúdo tangencial

O elemento `<aside>` representa conteúdo **tangencialmente relacionado** ao conteúdo ao seu redor — informações que complementam, mas não são essenciais ao fluxo principal. A remoção do `<aside>` não deve comprometer a compreensão do conteúdo principal.

Exemplos de uso: notas de rodapé, caixas de destaque ("saiba mais"), glossários laterais, listas de links relacionados, publicidade contextual, perfis de autor, widgets de redes sociais.

```html
<main>
  <article>
    <h2>Protocolo HTTP</h2>
    <p>O HTTP é o protocolo que governa a comunicação entre
    clientes e servidores na Web. Cada interação é composta
    por uma requisição e uma resposta...</p>

    <!-- Nota tangencial: não é essencial, mas enriquece -->
    <aside>
      <h3>Curiosidade</h3>
      <p>O HTTP foi criado por Tim Berners-Lee em 1989 como
      parte do projeto que daria origem à World Wide Web.</p>
    </aside>

    <p>O protocolo é definido como <em>stateless</em>...</p>
  </article>

  <!-- Aside no nível da página: conteúdo lateral -->
  <aside aria-label="Leituras recomendadas">
    <h2>Leituras recomendadas</h2>
    <ul>
      <li><a href="https://developer.mozilla.org">MDN Web Docs</a></li>
      <li><a href="https://html.spec.whatwg.org">HTML Living Standard</a></li>
    </ul>
  </aside>
</main>
```

### 3.2.7 — `<footer>`: rodapé

O elemento `<footer>` representa o **rodapé** de sua seção de escopo. Tipicamente contém informações sobre autoria, direitos autorais, links institucionais, dados de contato e metadados sobre o conteúdo. Como `<header>`, pode ser usado tanto no nível global da página quanto no nível de um `<article>` ou `<section>`.

```html
<!-- Rodapé de um artigo -->
<article>
  <h2>Introdução ao HTML</h2>
  <p>Conteúdo do artigo...</p>
  <footer>
    <p>Autor: Prof. Silva |
      Última atualização:
      <time datetime="2026-03-01">março de 2026</time>
    </p>
  </footer>
</article>

<!-- Rodapé global da página -->
<footer>
  <p>© 2026 IFAL — Instituto Federal de Alagoas</p>
  <nav aria-label="Links institucionais">
    <a href="/acessibilidade">Acessibilidade</a>
    <a href="/privacidade">Política de Privacidade</a>
    <a href="/contato">Contato</a>
  </nav>
</footer>
```

**Restrição:** `<footer>` não pode ser descendente de `<address>` ou de outro `<footer>`, e não pode conter um elemento `<header>`.

### 3.2.8 — O algoritmo de outline e a hierarquia de títulos

Compreender os elementos de seção individualmente não é suficiente para escrever HTML semântico correto: é preciso entender como eles interagem com os títulos (`<h1>`–`<h6>`) para formar o **outline** do documento — a estrutura hierárquica que navegadores, leitores de tela e ferramentas de indexação constroem a partir da marcação.

O **outline** é, em essência, o sumário implícito do documento. Cada elemento de seção (`<article>`, `<section>`, `<aside>`, `<nav>`) cria um **contexto de seção** próprio, e os títulos dentro dele são interpretados relativamente a esse contexto. Isso tem uma consequência prática importante: um `<h1>` dentro de um `<article>` representa o título principal *daquele artigo*, não necessariamente o título principal da página inteira.

Considere o seguinte documento:

```html
<body>
  <h1>Blog de Tecnologia</h1>        <!-- Título da página -->

  <main>
    <article>
      <h2>O que é HTTP?</h2>         <!-- Título do artigo -->
      <section>
        <h3>História do HTTP</h3>    <!-- Subtítulo da seção -->
      </section>
    </article>

    <article>
      <h2>Introdução ao CSS</h2>     <!-- Título do segundo artigo -->
    </article>
  </main>
</body>
```

O outline resultante desse documento seria:

```
1. Blog de Tecnologia
   1.1 O que é HTTP?
       1.1.1 História do HTTP
   1.2 Introdução ao CSS
```

Este outline é o que um leitor de tela apresenta ao usuário quando ele solicita a lista de títulos da página — o mecanismo mais comum de navegação rápida em tecnologias assistivas. Se a hierarquia de títulos estiver incorreta (por exemplo, saltar de `<h1>` para `<h3>` sem um `<h2>` intermediário), o outline gerado será incoerente, prejudicando a experiência de quem depende desse mecanismo.

**A regra prática mais importante:** nunca salte níveis de título. A sequência `<h1>` → `<h2>` → `<h3>` deve ser respeitada como uma hierarquia lógica, não visual.

> **Imagem sugerida:** captura lado a lado da aba **Accessibility** do Chrome DevTools mostrando o outline de uma página com hierarquia de títulos correta versus uma página com títulos fora de ordem — ilustrando visualmente como a estrutura é percebida por leitores de tela.
>
> *(imagem será adicionada posteriormente)*

> **No DevTools:** abra a aba **Elements**, selecione qualquer elemento de seção e, no painel lateral, clique em **Accessibility**. O painel exibe o *role* semântico do elemento, seu nome acessível e sua posição na árvore de acessibilidade — a mesma estrutura que um leitor de tela enxerga.

**Referências:**
- [WHATWG — Headings and sections](https://html.spec.whatwg.org/multipage/sections.html#headings-and-sections)
- [MDN — Document and website structure](https://developer.mozilla.org/pt-BR/docs/Learn/HTML/Introduction_to_HTML/Document_and_website_structure)

### 3.2.9 — `<section>` sem título: consequências práticas e solução

A orientação de que `<section>` deve sempre conter um título tem uma justificativa técnica precisa que vai além da convenção editorial. Quando um elemento `<section>` não possui um título visível associado, ele se torna **opaco para tecnologias assistivas**: o leitor de tela não consegue nomear a seção, o que prejudica a navegação por regiões do documento.

A solução para casos em que o título não deve ser visível — por razões de design — é utilizar o atributo `aria-labelledby` (quando o título existe mas está fora do `<section>`) ou `aria-label` (quando não há título no DOM):

```html
<!-- Caso 1: título visível — uso convencional -->
<section>
  <h2>Depoimentos de alunos</h2>
  <p>...</p>
</section>

<!-- Caso 2: sem título visível, mas com aria-label
     — a seção é nomeada para leitores de tela -->
<section aria-label="Depoimentos de alunos">
  <p>...</p>
</section>

<!-- Caso 3: título existe no DOM mas está fora da section
     — aria-labelledby referencia o id do título -->
<h2 id="titulo-depoimentos">Depoimentos de alunos</h2>
<section aria-labelledby="titulo-depoimentos">
  <p>...</p>
</section>
```

A omissão tanto do título quanto dos atributos ARIA transforma o `<section>` em um contêiner semanticamente anônimo — nesse caso, `<div>` seria igualmente adequado e mais honesto quanto à ausência de semântica.

**Referência:** [MDN — `<section>`: The Generic Section element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/section)

### 3.2.10 — `<figure>` e `<figcaption>`: conteúdo autônomo referenciado

O elemento `<figure>` representa **conteúdo autônomo e autocontido que é referenciado pelo fluxo principal do documento**, mas que poderia, em princípio, ser movido para outro lugar (um apêndice, uma barra lateral, outro documento) sem prejudicar a compreensão do texto que o referencia.

Um equívoco comum é associar `<figure>` exclusivamente a imagens. Na especificação, `<figure>` pode conter qualquer tipo de conteúdo autorreferenciado: imagens, diagramas, gráficos, trechos de código, tabelas, citações e até mesmo vídeos. O critério é a **autonomia e a referencialidade** — o fluxo principal menciona ou depende desse conteúdo, mas o conteúdo em si poderia ser deslocado.

```html
<!-- Figura com imagem -->
<figure>
  <img
    src="figures/outline-semantico.png"
    alt="Diagrama mostrando o outline de um documento HTML semântico"
    width="700"
    height="400"
  />
  <figcaption>
    Figura 1 — Representação do outline gerado por um documento
    com hierarquia semântica correta.
  </figcaption>
</figure>

<!-- Figura com bloco de código -->
<figure>
  <pre><code>&lt;article&gt;
  &lt;h2&gt;Título&lt;/h2&gt;
  &lt;p&gt;Conteúdo...&lt;/p&gt;
&lt;/article&gt;</code></pre>
  <figcaption>
    Figura 2 — Estrutura mínima de um elemento &lt;article&gt;.
  </figcaption>
</figure>

<!-- Figura com citação longa -->
<figure>
  <blockquote cite="https://html.spec.whatwg.org/">
    <p>The article element represents a complete, or self-contained,
    composition in a document, page, application, or site.</p>
  </blockquote>
  <figcaption>
    — <cite>HTML Living Standard</cite>, WHATWG
  </figcaption>
</figure>
```

O elemento `<figcaption>`, quando presente, deve ser o primeiro ou o último filho direto do `<figure>`. Ele fornece a legenda ou descrição do conteúdo da figura e é associado automaticamente ao conteúdo pelo leitor de tela — tornando desnecessário repetir a informação da legenda no atributo `alt` da imagem quando ambos descrevem a mesma coisa.

**Referências:**
- [MDN — `<figure>`: The Figure with Optional Caption element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/figure)
- [WHATWG — The figure element](https://html.spec.whatwg.org/multipage/grouping-content.html#the-figure-element)

---

## 3.3 — Elementos de texto com semântica específica

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Além dos elementos de seção, o HTML oferece um conjunto de elementos para atribuir **significado semântico específico** a fragmentos de texto. Compreender a distinção entre esses elementos — especialmente entre os pares que produzem aparência visual similar — é essencial para escrever HTML correto.

### 3.3.1 — Ênfase e importância: `<em>` e `<strong>`

Estes dois elementos são frequentemente confundidos por sua aparência visual padrão (itálico e negrito, respectivamente), mas possuem semânticas distintas e não intercambiáveis.

**`<em>` — ênfase**

O elemento `<em>` (*emphasis*) indica que o trecho possui **ênfase linguística** — uma entonação que, na fala, alteraria o sentido da frase. Seu efeito é semântico, não decorativo: leitores de tela podem alterar a entonação de síntese de voz para elementos `<em>`.

```html
<!-- A ênfase muda o sentido da frase em cada caso -->
<p><em>Eu</em> nunca disse que ela roubou o dinheiro.</p>
<p>Eu nunca disse que <em>ela</em> roubou o dinheiro.</p>
<p>Eu nunca disse que ela <em>roubou</em> o dinheiro.</p>
```

**`<strong>` — importância elevada**

O elemento `<strong>` indica que o trecho possui **importância, seriedade ou urgência** elevada no contexto do documento. É utilizado para avisos, alertas, informações críticas ou termos que o leitor não deve ignorar.

```html
<p>
  <strong>Atenção:</strong> é obrigatório realizar o commit
  antes de fechar o terminal.
</p>

<p>
  O prazo de entrega é <strong>improrrogável</strong>.
</p>
```

### 3.3.2 — Destaque tipográfico sem semântica: `<b>` e `<i>`

Os elementos `<b>` e `<i>` existem no HTML5 com semânticas mais restritas do que seu nome sugere.

**`<b>` — destaque tipográfico convencional**

O elemento `<b>` (*bold*) é usado para atrair a atenção do leitor para um trecho de texto sem que isso implique importância elevada ou ênfase especial. Exemplos: palavras-chave em um resumo, nome de produto em uma resenha, primeiras palavras de um parágrafo em um artigo jornalístico.

**`<i>` — voz alternativa ou convenção tipográfica**

O elemento `<i>` (*italic*) é usado para texto em uma "voz" ou modo alternativo ao prosa principal: termos técnicos, palavras estrangeiras, títulos de obras citadas em linha, pensamentos de personagens em ficção.

```html
<!-- <b>: palavra-chave em destaque, sem importância semântica -->
<p>O protocolo <b>HTTP</b> é a base da comunicação na Web.</p>

<!-- <i>: termo técnico em latim -->
<p>O princípio <i lang="la">ad hoc</i> é frequentemente
aplicado em redes sem fio.</p>

<!-- <i>: título de obra inline -->
<p>Para aprofundar o tema, consulte
<cite>HTML: The Living Standard</cite>.</p>
```

### 3.3.3 — Outros elementos semânticos de texto

| Elemento | Semântica | Exemplo de uso |
|---|---|---|
| `<mark>` | Trecho relevante para o contexto atual (como resultado de busca) | Destacar termos pesquisados |
| `<small>` | Texto de menor relevância: notas, asteriscos, direitos autorais | Letra miúda em contratos |
| `<del>` | Conteúdo removido ou obsoleto | Preço anterior riscado |
| `<ins>` | Conteúdo inserido ou acrescentado | Correções em documentos |
| `<code>` | Fragmento de código-fonte | `console.log("olá")` |
| `<pre>` | Texto pré-formatado (preserva espaços e quebras) | Blocos de código |
| `<kbd>` | Entrada de teclado do usuário | Pressione `Ctrl+S` |
| `<samp>` | Saída de programa ou sistema | Resultado de um comando |
| `<var>` | Variável matemática ou de programação | *x* = 2 |
| `<abbr>` | Abreviação ou sigla, com expansão via `title` | `<abbr title="HyperText Markup Language">HTML</abbr>` |
| `<cite>` | Título de obra referenciada | Nome de livro, artigo |
| `<time>` | Data ou hora legível por máquina | `<time datetime="2026-03-01">` |
| `<address>` | Informações de contato do autor ou da seção | E-mail, endereço postal |
| `<blockquote>` | Citação longa de fonte externa | Trecho de discurso ou artigo |
| `<q>` | Citação curta, inline | Frase citada dentro de parágrafo |
| `<dfn>` | Definição de um termo | Primeira ocorrência de um conceito |

**O elemento `<time>`** merece atenção especial por seu impacto prático. Ele permite que datas e horários sejam legíveis por máquinas (navegadores, mecanismos de busca, aplicativos de calendário) sem sacrificar a legibilidade humana:

```html
<!-- datetime usa o formato ISO 8601 -->
<p>A aula ocorre toda
  <time datetime="2026-03-20">sexta-feira, 20 de março de 2026</time>
  às <time datetime="08:00">8h</time>.
</p>

<!-- Duração -->
<p>O evento tem duração de <time datetime="PT2H">2 horas</time>.</p>
```

**Referências para esta seção:**
- [MDN — Referência de elementos HTML (completa)](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element)
- [WHATWG — Text-level semantics](https://html.spec.whatwg.org/multipage/text-level-semantics.html)
- [W3C — Using semantic elements](https://www.w3.org/WAI/WCAG21/Techniques/html/H49)

---

## 3.4 — Refatoração: de marcação não semântica para semântica

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A melhor forma de consolidar o entendimento do HTML semântico é observar o processo de **refatoração** — a transformação de um documento funcional, mas semanticamente incorreto, em um documento estruturalmente correto. Refatorar não significa alterar o visual da página; significa corrigir o significado da marcação.

### 3.4.1 — Exemplo completo de refatoração

A seguir, apresenta-se uma página típica construída inteiramente com `<div>` e classes CSS — uma abordagem comum entre desenvolvedores que não dominam os elementos semânticos — seguida de sua versão refatorada.

**Versão original (não semântica):**

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Blog de Tecnologia</title>
</head>
<body>

  <div class="cabecalho">
    <div class="logo">
      <img src="logo.png" alt="Logo" />
    </div>
    <div class="titulo-site">Blog de Tecnologia</div>
    <div class="menu">
      <div class="item-menu"><a href="/">Início</a></div>
      <div class="item-menu"><a href="/artigos">Artigos</a></div>
      <div class="item-menu"><a href="/contato">Contato</a></div>
    </div>
  </div>

  <div class="conteudo">
    <div class="postagem">
      <div class="titulo-postagem">O que é HTML Semântico?</div>
      <div class="meta">Por Prof. Silva — 01/03/2026</div>
      <div class="texto">
        <p>O HTML semântico é a prática de usar elementos
        que descrevem o significado do conteúdo...</p>
      </div>
      <div class="rodape-post">
        <span class="categoria">Categoria: HTML</span>
      </div>
    </div>
  </div>

  <div class="barra-lateral">
    <div class="titulo-lateral">Artigos relacionados</div>
    <div class="lista-links">
      <div><a href="/html-basico">HTML Básico</a></div>
      <div><a href="/css-intro">Introdução ao CSS</a></div>
    </div>
  </div>

  <div class="rodape">
    <div class="copyright">© 2026 Blog de Tecnologia</div>
  </div>

</body>
</html>
```

**Versão refatorada (semântica):**

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Blog de Tecnologia</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>

  <header>
    <a href="/">
      <img src="logo.png" alt="Blog de Tecnologia" />
    </a>
    <h1>Blog de Tecnologia</h1>
    <nav aria-label="Navegação principal">
      <ul>
        <li><a href="/">Início</a></li>
        <li><a href="/artigos">Artigos</a></li>
        <li><a href="/contato">Contato</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <article>
      <header>
        <h2>O que é HTML Semântico?</h2>
        <p>
          Por <strong>Prof. Silva</strong> —
          <time datetime="2026-03-01">1º de março de 2026</time>
        </p>
      </header>

      <p>O HTML semântico é a prática de usar elementos
      que descrevem o significado do conteúdo...</p>

      <footer>
        <p>Categoria: <a href="/categoria/html">HTML</a></p>
      </footer>
    </article>

    <aside aria-label="Artigos relacionados">
      <h2>Artigos relacionados</h2>
      <ul>
        <li><a href="/html-basico">HTML Básico</a></li>
        <li><a href="/css-intro">Introdução ao CSS</a></li>
      </ul>
    </aside>
  </main>

  <footer>
    <p>© 2026 Blog de Tecnologia</p>
  </footer>

</body>
</html>
```

### 3.4.2 — Análise das decisões de refatoração

Cada substituição realizada no exemplo acima obedece a um critério semântico preciso:

`<div class="cabecalho">` → `<header>`: o bloco introduz a página com logotipo, título e navegação — função exata do `<header>`.

`<div class="titulo-site">` → `<h1>`: o nome do site é o título principal do documento. Não há razão semântica para que seja um `<div>` estilizado.

`<div class="menu">` + `<div class="item-menu">` → `<nav>` + `<ul>` + `<li>`: a navegação é uma lista de links — semântica de lista e semântica de navegação devem ser combinadas.

`<div class="conteudo">` → `<main>`: o bloco contém o conteúdo principal e único da página.

`<div class="postagem">` → `<article>`: a postagem é um conteúdo autônomo — faria sentido publicado isoladamente.

`<div class="titulo-postagem">` → `<h2>` dentro de `<header>` do artigo: o título da postagem é um título de nível 2 (subordinado ao `<h1>` da página).

`<div class="meta">` → `<p>` com `<time>`: a data é um dado estruturado que se beneficia do elemento `<time>` para legibilidade por máquina.

`<div class="barra-lateral">` → `<aside>`: o conteúdo lateral é tangencialmente relacionado ao artigo principal — semântica exata do `<aside>`.

`<div class="rodape">` → `<footer>`: o rodapé global da página.

---

## 3.5 — Validação semântica e diagnóstico com ferramentas

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Escrever HTML semântico correto é uma habilidade que se aprimora com feedback constante. Existem ferramentas especializadas — algumas online, outras integradas diretamente ao navegador — que permitem verificar se um documento está sintaticamente válido, semanticamente coerente e acessível. Incorporar essas ferramentas ao fluxo de desenvolvimento desde os primeiros projetos é uma prática profissional essencial.

### 3.5.1 — W3C Markup Validation Service

O **W3C Markup Validation Service** é a ferramenta oficial de validação sintática de documentos HTML, mantida pelo *World Wide Web Consortium*. Ela verifica se o documento está em conformidade com a especificação HTML e reporta erros como tags não fechadas, atributos inválidos, elementos aninhados incorretamente e ausência de elementos obrigatórios (como `<!DOCTYPE>` ou `<title>`).

A validação pode ser realizada de três formas: por URL (para páginas publicadas), por upload de arquivo ou por entrada direta de código. Para as atividades desta disciplina, a entrada direta de código é a mais prática.

> **Acesse:** [https://validator.w3.org/](https://validator.w3.org/)

Um documento com erros de validação não é necessariamente disfuncional — os navegadores modernos são tolerantes e realizam correções automáticas. Contudo, depender dessa tolerância é uma prática frágil: o comportamento de correção automática não é padronizado entre navegadores, e erros estruturais podem produzir resultados imprevisíveis em contextos específicos (leitores de tela, parsers automatizados, ambientes embarcados).

### 3.5.2 — WAVE — Web Accessibility Evaluation Tool

O **WAVE** é uma ferramenta gratuita de avaliação de acessibilidade desenvolvida pela *WebAIM (Web Accessibility In Mind)*. Diferentemente do validador W3C — que verifica apenas a sintaxe —, o WAVE analisa o documento sob a perspectiva da acessibilidade: identifica ausência de textos alternativos, hierarquias de título incorretas, falta de labels em formulários, contraste insuficiente e outros problemas que afetam diretamente usuários de tecnologias assistivas.

O WAVE exibe os resultados sobrepostos à própria página, com ícones codificados por cor: erros (vermelho), alertas (amarelo) e itens estruturais positivos (verde e azul). Essa visualização in-page é especialmente eficaz para diagnosticar problemas em relação ao contexto em que ocorrem.

> **Acesse:** [https://wave.webaim.org/](https://wave.webaim.org/)

> **Imagem sugerida:** captura de tela do WAVE analisando uma página com problemas semânticos (ausência de `alt`, hierarquia de títulos incorreta), mostrando os ícones de erro sobrepostos à página.
>
> *(imagem será adicionada posteriormente)*

### 3.5.3 — DevTools: Accessibility Tree e Lighthouse

O Chrome DevTools (e o Firefox DevTools, de forma similar) oferece dois recursos diretamente relevantes para o diagnóstico semântico de documentos HTML:

**Accessibility Tree (Árvore de Acessibilidade)**

A aba **Elements** do DevTools exibe a árvore DOM do documento. Ao selecionar qualquer elemento e abrir o painel lateral **Accessibility** (`F12` → Elements → painel Accessibility à direita), é possível visualizar:

- O **role** semântico do elemento (ex.: `heading`, `navigation`, `article`, `generic`)
- O **nome acessível** — o texto ou rótulo que o leitor de tela anuncia ao focar o elemento
- O **estado** — se está expandido, selecionado, desabilitado, etc.
- A posição do elemento na **Accessibility Tree** completa

Esta visualização revela, de forma concreta, a diferença entre um `<div>` (role: `generic`, sem nome acessível) e um `<nav aria-label="Navegação principal">` (role: `navigation`, nome: "Navegação principal"). A Accessibility Tree é exatamente o que um leitor de tela como o NVDA ou o VoiceOver enxerga ao processar a página.

> **Imagem sugerida:** captura do painel Accessibility do Chrome DevTools mostrando o role e o nome acessível de um elemento `<nav aria-label="...">` versus um `<div class="nav">` sem semântica — lado a lado.
>
> *(imagem será adicionada posteriormente)*

**Como usar no DevTools:**
1. Abra o DevTools (`F12` ou `Ctrl+Shift+I`)
2. Na aba **Elements**, clique em qualquer elemento da árvore DOM
3. No painel lateral direito, localize a seção **Accessibility**
4. Observe o *role*, o *name* e os *states* do elemento selecionado
5. Marque a opção **"Enable full-page accessibility tree"** para visualizar a árvore completa de acessibilidade no painel Elements

**Lighthouse**

O **Lighthouse** é uma ferramenta de auditoria automatizada integrada ao Chrome DevTools (aba **Lighthouse**). Ela gera relatórios sobre desempenho, acessibilidade, boas práticas e SEO da página. A auditoria de acessibilidade é baseada nas diretrizes WCAG e verifica automaticamente dezenas de critérios, incluindo:

- Presença e qualidade dos atributos `alt` em imagens
- Hierarquia de títulos (`<h1>`–`<h6>`)
- Uso correto de `<label>` em formulários
- Contraste de cores entre texto e fundo
- Presença de atributos ARIA adequados
- Navegabilidade por teclado

O resultado é uma pontuação de 0 a 100, acompanhada de uma lista de problemas com links diretos para a documentação relevante.

> **Como usar o Lighthouse:**
> 1. Abra o DevTools (`F12`)
> 2. Navegue até a aba **Lighthouse**
> 3. Em **Categories**, selecione **Accessibility** (e opcionalmente **Best practices** e **SEO**)
> 4. Clique em **Analyze page load**
> 5. Analise o relatório gerado, corrigindo os problemas identificados

### 3.5.4 — Fluxo de diagnóstico recomendado

Para as atividades desta disciplina, recomenda-se seguir o seguinte fluxo de diagnóstico em ordem, do mais básico ao mais específico:

1. **W3C Validator** — garantir que o documento não tem erros sintáticos
2. **DevTools → Elements → Accessibility** — verificar o role e o nome acessível dos elementos-chave (`<nav>`, `<main>`, `<article>`, `<header>`, `<footer>`)
3. **WAVE** — auditar a página completa sob a perspectiva de acessibilidade
4. **Lighthouse** — obter pontuação geral e lista priorizada de problemas a corrigir

Este fluxo não substitui o teste com leitores de tela reais (como NVDA, JAWS ou VoiceOver), mas fornece uma base sólida de diagnóstico automatizado antes de testes manuais.

**Referências:**
- [W3C Markup Validation Service](https://validator.w3.org/)
- [WAVE Web Accessibility Evaluation Tool](https://wave.webaim.org/)
- [Chrome DevTools — Accessibility features](https://developer.chrome.com/docs/devtools/accessibility/reference/)
- [Lighthouse — Accessibility audits](https://developer.chrome.com/docs/lighthouse/accessibility/)
- [WebAIM — Introduction to Web Accessibility](https://webaim.org/intro/)
- [NVDA Screen Reader (gratuito)](https://www.nvaccess.org/download/)

---

#### **Atividades — Capítulo 3**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Um desenvolvedor precisa marcar um bloco de conteúdo que contém uma lista de links para outras páginas do site (menu principal). Qual elemento é semanticamente mais apropriado?</p>
  <button data-option="a"><code>&lt;div class="menu"&gt;</code></button>
  <button data-option="b"><code>&lt;section&gt;</code></button>
  <button data-option="c"><code>&lt;nav&gt;</code></button>
  <button data-option="d"><code>&lt;aside&gt;</code></button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Qual é a distinção semântica correta entre <code>&lt;article&gt;</code> e <code>&lt;section&gt;</code>?</p>
  <button data-option="a">São equivalentes; ambos agrupam conteúdo temático e podem ser usados de forma intercambiável.</button>
  <button data-option="b"><code>&lt;article&gt;</code> representa conteúdo autônomo que faria sentido publicado isoladamente; <code>&lt;section&gt;</code> representa uma seção temática que é parte de um todo maior.</button>
  <button data-option="c"><code>&lt;section&gt;</code> é usado para conteúdo principal; <code>&lt;article&gt;</code> para conteúdo secundário.</button>
  <button data-option="d"><code>&lt;article&gt;</code> só pode ser usado para artigos jornalísticos; <code>&lt;section&gt;</code> é de uso geral.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Por que o elemento <code>&lt;main&gt;</code> deve ocorrer apenas uma vez por página?</p>
  <button data-option="a">Por limitação técnica do HTML5 — o navegador ignora instâncias adicionais.</button>
  <button data-option="b">Para evitar conflitos com as regras de CSS.</button>
  <button data-option="c">Porque o <code>&lt;main&gt;</code> só pode ser filho direto do <code>&lt;body&gt;</code>.</button>
  <button data-option="d">Porque ele representa o conteúdo principal e único da página; múltiplas instâncias criariam ambiguidade semântica sobre qual região contém o conteúdo central.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> Qual é a diferença semântica entre <code>&lt;em&gt;</code> e <code>&lt;i&gt;</code>?</p>
  <button data-option="a"><code>&lt;em&gt;</code> indica ênfase linguística que pode alterar o sentido da frase; <code>&lt;i&gt;</code> indica texto em voz alternativa (termos técnicos, estrangeirismos) sem implicação de ênfase.</button>
  <button data-option="b">São sinônimos; ambos produzem texto em itálico com o mesmo significado semântico.</button>
  <button data-option="c"><code>&lt;i&gt;</code> é o elemento correto para ênfase; <code>&lt;em&gt;</code> é uma alternativa obsoleta.</button>
  <button data-option="d"><code>&lt;em&gt;</code> aplica itálico apenas em navegadores modernos; <code>&lt;i&gt;</code> tem suporte universal.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Refatorar a página não semântica fornecida, substituindo todos os `<div>` por elementos semânticos apropriados e justificando cada decisão em comentários HTML. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 2 — Fundamentos do HTML](02-html-fundamentos.md)
[:material-arrow-right: Ir ao Capítulo 4 — Tabelas, Listas e Mídia](04-tabelas-listas-midia.md)
