# Capítulo 2 — Fundamentos do HTML

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 2.1 — Introdução ao HTML

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O HTML (*HyperText Markup Language*) constitui a linguagem de marcação que fundamenta toda a estrutura da Web. Antes de explorar seus elementos e regras sintáticas, é necessário compreender o que essa linguagem é — e, igualmente importante, o que ela **não** é — no contexto do desenvolvimento web moderno.

### 2.1.1 — O que é HTML

O **HTML** é uma linguagem de **marcação** (*markup language*), não uma linguagem de programação. Esta distinção é tecnicamente precisa e conceitualmente importante: linguagens de programação possuem estruturas de controle de fluxo (condicionais, laços de repetição), gerenciamento de estado e capacidade de realizar cômputo generalizado. O HTML, por sua vez, serve a um propósito distinto e mais específico: **descrever a estrutura e o significado do conteúdo** de um documento hipermídia.

O termo *hipertexto* (do inglês *hypertext*) refere-se à capacidade de interligar documentos por meio de referências navegáveis — os hiperlinks —, rompendo a linearidade característica dos documentos impressos e criando a "teia" não linear que deu nome à World Wide Web. O termo *marcação* (*markup*) remete à prática editorial de anotar manuscritos com instruções de formatação; no contexto digital, essas anotações são as **tags** HTML, que delimitam e descrevem os fragmentos de conteúdo.

Do ponto de vista histórico, o HTML foi concebido por **Tim Berners-Lee** em 1991 como uma aplicação simplificada do **SGML** (*Standard Generalized Markup Language*), norma ISO para estruturação de documentos técnicos. A versão que fundamenta o desenvolvimento web contemporâneo é o **HTML5**, cuja especificação foi publicada pelo **W3C** (*World Wide Web Consortium*) em 2014 e é mantida atualmente pelo **WHATWG** (*Web Hypertext Application Technology Working Group*) sob o modelo de *living standard* — uma especificação em evolução contínua, sem versionamento fixo.

> **Referência:** [WHATWG — HTML Living Standard](https://html.spec.whatwg.org/)

É fundamental compreender que o HTML não controla a aparência visual das páginas — essa responsabilidade pertence ao **CSS** — nem o comportamento interativo, que é domínio do **JavaScript**. O HTML define exclusivamente **o quê** o conteúdo é: um título, um parágrafo, uma lista, uma imagem, um link. Esta separação de responsabilidades é um dos princípios arquiteturais mais importantes do desenvolvimento web moderno.

> #### 📜 Breve Histórico do HTML
>
> - **HTML 1.0 (1991)** — Proposta inicial de Berners-Lee; cerca de 18 tags.
> - **HTML 2.0 (1995)** — Primeira especificação formal pelo IETF.
> - **HTML 3.2 (1997)** — Incorporou tabelas, applets e elementos de apresentação.
> - **HTML 4.01 (1999)** — Introduziu separação entre estrutura e apresentação; adoção do CSS.
> - **XHTML 1.0 (2000)** — Reformulação do HTML 4 com sintaxe XML estrita.
> - **HTML5 (2014)** — Revisão profunda: semântica, multimídia nativa, APIs JavaScript, formulários avançados.
> - **HTML Living Standard (atual)** — Mantido pelo WHATWG; atualizado continuamente.

---

### 2.1.2 — Estrutura básica (`<!DOCTYPE>`, `<html>`, `<head>`, `<body>`)

Todo documento HTML válido obedece a uma estrutura hierárquica mínima, composta por quatro elementos obrigatórios. Compreender a função de cada um é o ponto de partida para qualquer prática de desenvolvimento web.

```html
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Título do Documento</title>
  </head>
  <body>
    <p>Conteúdo visível da página.</p>
  </body>
</html>
```

Cada componente desta estrutura desempenha um papel específico e insubstituível:

**`<!DOCTYPE html>`**

A declaração `DOCTYPE` (*Document Type Declaration*) não é uma tag HTML propriamente dita, mas uma instrução de processamento dirigida ao navegador. Ela informa ao motor de renderização que o documento deve ser interpretado segundo a especificação do **HTML5**, ativando o chamado *standards mode* (modo de conformidade com os padrões). Na ausência desta declaração, o navegador pode ativar o *quirks mode* — um modo de compatibilidade retroativa que emula comportamentos de navegadores antigos —, produzindo resultados de renderização imprevisíveis. Por esta razão, `<!DOCTYPE html>` deve ser **sempre** a primeira linha de qualquer documento HTML.

**`<html lang="...">`**

O elemento `<html>` é o elemento raiz (*root element*) do documento: todos os demais elementos são seus descendentes. O atributo `lang` declara o idioma primário do conteúdo textual do documento, utilizando códigos definidos pela norma **BCP 47** (ex.: `pt-BR` para português brasileiro, `en-US` para inglês americano). Esta declaração é imprescindível para que leitores de tela utilizem o mecanismo de síntese de voz correto, para que ferramentas de tradução automática identifiquem o idioma de origem e para a correta aplicação de regras tipográficas (hifenização, aspas, etc.).

**`<head>`**

O elemento `<head>` constitui o cabeçalho do documento — distinto do cabeçalho visual da página. Ele contém **metadados**: informações sobre o documento que não são exibidas diretamente ao usuário, mas são consumidas pelo navegador, por mecanismos de busca e por outras aplicações. Os metadados mais comuns incluem:

| Elemento / Atributo | Função |
|---|---|
| `<meta charset="UTF-8">` | Define a codificação de caracteres do documento. UTF-8 é o padrão universal e suporta praticamente todos os sistemas de escrita. |
| `<meta name="viewport" ...>` | Controla o comportamento do *viewport* em dispositivos móveis. Essencial para o design responsivo. |
| `<title>` | Define o título do documento, exibido na aba do navegador e nos resultados de busca. |
| `<link rel="stylesheet" href="...">` | Vincula uma folha de estilos CSS externa ao documento. |
| `<meta name="description" content="...">` | Fornece uma descrição resumida do conteúdo para mecanismos de busca. |

**`<body>`**

O elemento `<body>` contém todo o conteúdo que será efetivamente **renderizado e exibido** ao usuário: textos, imagens, links, formulários, tabelas, vídeos e todos os demais elementos visuais e interativos. É dentro do `<body>` que a maior parte do trabalho de marcação HTML ocorre.

> **Boa prática:** O atributo `lang` no elemento `<html>` e a meta tag `charset="UTF-8"` devem ser considerados obrigatórios em qualquer documento HTML, não opcionais. Sua omissão constitui uma falha técnica com impacto direto em acessibilidade e internacionalização.

---

### 2.1.3 — Tags, atributos e elementos

A compreensão precisa da terminologia HTML é fundamental para evitar ambiguidades na comunicação técnica e para interpretar corretamente a documentação especializada.

**Tags**

Uma **tag** é a unidade sintática básica do HTML. Ela é delimitada pelos caracteres `<` e `>` e pode ser de dois tipos:

- **Tag de abertura:** `<p>` — indica o início de um elemento.
- **Tag de fechamento:** `</p>` — indica o término de um elemento, sendo distinguida pela barra `/` após o caractere `<`.
- **Tag vazia (*void element*):** `<img />`, `<br />`, `<meta />` — elementos que não possuem conteúdo interno e, portanto, não requerem tag de fechamento.

**Elementos**

Um **elemento** HTML é a unidade semântica completa, composta pela tag de abertura, pelo conteúdo (quando presente) e pela tag de fechamento:

```
<p>Este é o conteúdo do parágrafo.</p>
 ↑                                  ↑
Tag de abertura            Tag de fechamento
└──────────── Elemento completo ────────────┘
```

Os elementos podem ser **aninhados** (*nested*), ou seja, um elemento pode conter outros elementos, desde que o aninhamento seja realizado de forma correta — sem sobreposição de tags:

```html
<!-- Aninhamento CORRETO -->
<p>Texto com <strong>ênfase forte</strong> no meio.</p>

<!-- Aninhamento INCORRETO — tags sobrepostas -->
<p>Texto com <strong>ênfase</p></strong>
```

**Atributos**

Os **atributos** fornecem informações adicionais sobre um elemento. Eles são declarados dentro da tag de abertura, na forma de pares `nome="valor"`:

```html
<a href="https://www.exemplo.com" target="_blank" rel="noopener noreferrer">
  Visitar exemplo
</a>
```

No exemplo acima, `href`, `target` e `rel` são atributos do elemento `<a>`. Cada atributo modifica ou complementa o comportamento e o significado do elemento ao qual pertence. Alguns atributos são **globais** — aplicáveis a qualquer elemento HTML (ex.: `id`, `class`, `lang`, `title`, `hidden`) — enquanto outros são **específicos** de determinados elementos (ex.: `href` é exclusivo de `<a>` e `<link>`; `src` é exclusivo de `<img>`, `<script>`, `<iframe>`, entre outros).

> **Nota técnica:** Em HTML5, as aspas ao redor dos valores de atributos são tecnicamente opcionais para valores sem espaços. Contudo, sua utilização é **fortemente recomendada** como boa prática, pois garante consistência sintática e previne ambiguidades em casos como `<input type=text name=meu campo>`, onde `meu campo` seria interpretado incorretamente.

**Árvore DOM (*Document Object Model*)**

Quando o navegador carrega um documento HTML, ele não o interpreta como uma sequência linear de texto, mas o converte em uma estrutura de dados hierárquica em memória denominada **DOM** (*Document Object Model*). O DOM representa o documento como uma **árvore de nós**, em que cada elemento, atributo e fragmento de texto corresponde a um nó. Esta representação é o que permite ao JavaScript manipular dinamicamente o conteúdo e a estrutura da página.

```
document
└── html
    ├── head
    │   ├── meta (charset)
    │   └── title
    │       └── "Título"
    └── body
        └── p
            └── "Conteúdo visível."
```

A compreensão do DOM é essencial não apenas para o JavaScript, mas também para a correta interpretação de seletores CSS e para o diagnóstico de problemas estruturais via DevTools.

---

#### **Atividades — Seção 2.1**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Qual é a função principal do elemento <code>&lt;head&gt;</code> em um documento HTML?</p>

  <button data-option="a">Exibir o cabeçalho visual da página, como logotipo e navegação.</button>
  <button data-option="b">Conter metadados sobre o documento, como título, codificação e vínculos com folhas de estilo.</button>
  <button data-option="c">Delimitar o conteúdo principal que será renderizado ao usuário.</button>
  <button data-option="d">Declarar a versão do HTML utilizada no documento.</button>

  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> O que ocorre quando um documento HTML é carregado sem a declaração <code>&lt;!DOCTYPE html&gt;</code>?</p>

  <button data-option="a">O navegador rejeita o documento e exibe uma mensagem de erro.</button>
  <button data-option="b">O documento é carregado normalmente, sem qualquer diferença de comportamento.</button>
  <button data-option="c">O navegador pode ativar o <em>quirks mode</em>, produzindo comportamentos de renderização imprevisíveis.</button>
  <button data-option="d">O documento é tratado como XHTML automaticamente.</button>

  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual das alternativas apresenta a diferença correta entre uma <em>tag</em> e um <em>elemento</em> HTML?</p>

  <button data-option="a">São sinônimos; os dois termos descrevem a mesma coisa.</button>
  <button data-option="b">A tag inclui o conteúdo textual; o elemento inclui apenas os delimitadores <code>&lt;&gt;</code>.</button>
  <button data-option="c">Tags são exclusivas do HTML5; elementos existem desde versões anteriores.</button>
  <button data-option="d">A tag é o delimitador sintático (<code>&lt;p&gt;</code>, <code>&lt;/p&gt;</code>); o elemento é a unidade completa formada pela tag de abertura, conteúdo e tag de fechamento.</button>

  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Criar página HTML mínima *(link será adicionado)*

---

## 2.2 — Tags Essenciais

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Com a estrutura básica do documento compreendida, é possível avançar para os elementos responsáveis pela marcação do conteúdo em si. As chamadas **tags essenciais** são aquelas de uso mais frequente no desenvolvimento web e constituem o vocabulário fundamental que todo desenvolvedor deve dominar.

### 2.2.1 — Títulos, parágrafos e textos

**Títulos (`<h1>` a `<h6>`)**

O HTML define seis níveis de títulos, numerados de 1 a 6, em ordem decrescente de importância hierárquica. O elemento `<h1>` representa o título principal do documento ou da seção de maior nível, enquanto `<h6>` representa o subtítulo de menor relevância hierárquica.

```html
<h1>Título principal da página</h1>
<h2>Seção principal</h2>
<h3>Subseção</h3>
<h4>Subseção de terceiro nível</h4>
<h5>Subseção de quarto nível</h5>
<h6>Subseção de quinto nível</h6>
```

> **Atenção crítica:** Os títulos não devem ser escolhidos com base em seu tamanho visual padrão — isso é responsabilidade do CSS. Eles devem refletir fielmente a **hierarquia lógica do conteúdo**. Um erro frequente entre iniciantes é utilizar `<h3>` porque "o tamanho parece adequado" em vez de `<h2>`, violando a estrutura hierárquica. Leitores de tela utilizam a hierarquia de títulos como mecanismo primário de navegação pelo documento; saltar níveis (ex.: de `<h1>` diretamente para `<h3>`) constitui uma falha de acessibilidade.

**Parágrafos (`<p>`)**

O elemento `<p>` delimita um **parágrafo** de texto. O navegador aplica, por padrão, margens verticais entre parágrafos consecutivos. É importante destacar que quebras de linha inseridas no código-fonte HTML (tecla Enter) não produzem quebras de linha no documento renderizado — o HTML ignora espaços em branco e quebras de linha extras no código.

```html
<p>Este é o primeiro parágrafo. O HTML ignora
quebras de linha no código-fonte
e trata o texto como contínuo.</p>

<p>Este é o segundo parágrafo, separado do anterior por uma margem automática.</p>
```

Para forçar uma quebra de linha dentro de um parágrafo, utiliza-se o elemento vazio `<br>`. Entretanto, seu uso deve ser restrito a situações em que a quebra de linha faz parte do conteúdo (ex.: endereços postais, estrofes de poemas), e não como mecanismo de espaçamento — para isso, utiliza-se CSS.

**Formatação semântica de texto**

O HTML oferece um conjunto de elementos para conferir **significado semântico** a trechos de texto. É fundamental distinguir os elementos semânticos dos puramente visuais:

| Elemento | Significado semântico | Renderização padrão |
|---|---|---|
| `<strong>` | Importância ou urgência elevada | Negrito |
| `<em>` | Ênfase (muda o sentido da frase) | Itálico |
| `<mark>` | Trecho relevante para o contexto atual | Destaque amarelo |
| `<small>` | Texto de menor relevância (notas, direitos autorais) | Fonte menor |
| `<del>` | Conteúdo removido ou obsoleto | Tachado |
| `<ins>` | Conteúdo inserido ou acrescentado | Sublinhado |
| `<code>` | Fragmento de código-fonte | Fonte monoespaçada |
| `<abbr>` | Abreviação ou sigla | (variável) + tooltip |
| `<cite>` | Título de obra referenciada | Itálico |
| `<blockquote>` | Citação longa de fonte externa | Recuo |
| `<q>` | Citação curta, inline | Aspas automáticas |
| `<b>` | Destaque tipográfico sem importância semântica | Negrito |
| `<i>` | Voz alternativa, termos técnicos, estrangeirismos | Itálico |

> **`<strong>` vs. `<b>` e `<em>` vs. `<i>`:** Esta é uma das distinções semânticas mais importantes do HTML5. `<strong>` indica que o trecho possui **importância elevada** no contexto do documento; `<b>` indica apenas destaque tipográfico convencional, sem implicação semântica. Da mesma forma, `<em>` indica ênfase que **modifica o sentido** da sentença, enquanto `<i>` marca texto em voz alternativa (termos técnicos, palavras estrangeiras, títulos de obras em linha). Leitores de tela podem alterar a entonação de voz para elementos `<strong>` e `<em>`, mas não para `<b>` e `<i>`.

```html
<!-- Uso correto de strong e em -->
<p>É <strong>obrigatório</strong> fazer backup antes de prosseguir.</p>
<p>Ela <em>realmente</em> disse isso? (a ênfase muda o sentido)</p>

<!-- Uso correto de b e i -->
<p>O termo <i lang="la">lorem ipsum</i> é amplamente utilizado em tipografia.</p>
<p>Pressione o botão <b>Salvar</b> para confirmar.</p>

<!-- Uso correto de abbr -->
<p>A linguagem <abbr title="HyperText Markup Language">HTML</abbr> é mantida pelo WHATWG.</p>
```

---

### 2.2.2 — Links e navegação

O elemento de âncora `<a>` (*anchor*) é o mecanismo fundamental de navegação hipertextual — aquele que, conceitualmente, define a própria natureza da Web como uma rede de documentos interconectados.

**Anatomia do elemento `<a>`**

```html
<a href="https://www.exemplo.com" target="_blank" rel="noopener noreferrer">
  Texto do link
</a>
```

Os atributos mais relevantes do elemento `<a>` são:

| Atributo | Descrição |
|---|---|
| `href` | (*Hypertext REFerence*) Especifica o destino do link. Pode ser uma URL absoluta, uma URL relativa, uma âncora na mesma página (`#id`) ou um protocolo especial (`mailto:`, `tel:`). |
| `target` | Define onde o recurso vinculado será aberto. O valor `_blank` abre em nova aba; `_self` (padrão) abre na mesma aba. |
| `rel` | Descreve a relação entre o documento atual e o documento vinculado. |
| `download` | Indica que o recurso deve ser baixado em vez de navegado. |
| `hreflang` | Declara o idioma do documento de destino. |

**URLs absolutas e relativas**

```html
<!-- URL absoluta: inclui protocolo e domínio completo -->
<a href="https://www.ifal.edu.br">Site do IFAL</a>

<!-- URL relativa: relativa ao documento atual -->
<a href="sobre.html">Sobre</a>
<a href="../index.html">Início</a>
<a href="/contato.html">Contato</a> <!-- relativa à raiz do site -->

<!-- Âncora interna: navega para elemento com id específico -->
<a href="#secao-2">Ir para a Seção 2</a>

<!-- Protocolos especiais -->
<a href="mailto:contato@exemplo.com">Enviar e-mail</a>
<a href="tel:+558200000000">Ligar agora</a>
```

**Segurança com `target="_blank"`**

A abertura de links em nova aba com `target="_blank"` requer atenção a uma questão de segurança: por padrão, a nova página pode acessar e manipular o objeto `window` da página de origem via `window.opener`. Para neutralizar este vetor de ataque (*reverse tabnapping*), é imperativo combinar `target="_blank"` com `rel="noopener noreferrer"`:

```html
<!-- SEGURO: noopener bloqueia acesso ao window.opener -->
<a href="https://site-externo.com" target="_blank" rel="noopener noreferrer">
  Link externo seguro
</a>
```

**Acessibilidade em links**

O texto de um link deve ser **descritivo e autoexplicativo** fora de contexto, pois usuários de leitores de tela frequentemente navegam pela lista de links do documento sem ler o texto ao redor. Textos genéricos como "clique aqui" ou "saiba mais" constituem falhas de acessibilidade:

```html
<!-- INCORRETO: texto não descritivo -->
<a href="/artigo.html">Clique aqui</a>

<!-- CORRETO: texto descritivo -->
<a href="/artigo.html">Leia o artigo completo sobre HTML semântico</a>

<!-- Quando necessário, use aria-label para complementar -->
<a href="/artigo.html" aria-label="Leia o artigo completo sobre HTML semântico">
  Saiba mais
</a>
```

---

### 2.2.3 — Imagens e mídias

**O elemento `<img>`**

O elemento `<img>` incorpora imagens ao documento. Trata-se de um **elemento vazio** (*void element*): não possui tag de fechamento nem conteúdo interno.

```html
<img
  src="assets/images/diagrama-cliente-servidor.png"
  alt="Diagrama da arquitetura cliente-servidor mostrando o fluxo de requisição e resposta HTTP"
  width="800"
  height="450"
  loading="lazy"
/>
```

Os atributos fundamentais do elemento `<img>` são:

| Atributo | Obrigatoriedade | Descrição |
|---|---|---|
| `src` | **Obrigatório** | Caminho (URL absoluta ou relativa) do arquivo de imagem. |
| `alt` | **Obrigatório** | Texto alternativo que descreve a imagem. Exibido quando a imagem não pode ser carregada; lido por leitores de tela. |
| `width` / `height` | Recomendado | Dimensões em pixels. Previnem o *layout shift* durante o carregamento da página. |
| `loading` | Recomendado | `lazy` ativa o carregamento adiado (*lazy loading*), melhorando o desempenho. |
| `srcset` | Opcional | Define imagens alternativas para diferentes densidades de tela ou tamanhos de viewport. |

**O atributo `alt`: importância e uso correto**

O atributo `alt` merece atenção especial. Ele não é uma legenda — é uma **descrição funcional** da imagem para contextos em que ela não pode ser percebida visualmente. Seu uso correto segue as seguintes regras:

```html
<!-- Imagem informativa: alt descreve o conteúdo e a função -->
<img src="grafico-vendas.png" alt="Gráfico de barras mostrando crescimento de 40% nas vendas do 2º semestre de 2025" />

<!-- Imagem decorativa: alt vazio (não omitido) indica que deve ser ignorada por leitores de tela -->
<img src="decoracao-fundo.png" alt="" />

<!-- INCORRETO: alt omitido — o leitor de tela lerá o nome do arquivo -->
<img src="grafico-vendas.png" />

<!-- INCORRETO: alt redundante — não acrescenta informação -->
<img src="logo.png" alt="imagem" />
```

**Imagens com legenda: `<figure>` e `<figcaption>`**

Quando uma imagem requer uma legenda visível associada, o padrão semântico correto utiliza os elementos `<figure>` e `<figcaption>`:

```html
<figure>
  <img
    src="figures/01_cliente_servidor.png"
    alt="Diagrama da arquitetura cliente-servidor com múltiplos dispositivos conectados a um servidor central"
    width="700"
    height="400"
  />
  <figcaption>
    Figura 1 — Arquitetura cliente-servidor: múltiplos clientes submetem requisições
    a um servidor centralizado, que processa e retorna as respostas correspondentes.
  </figcaption>
</figure>
```

O elemento `<figure>` representa conteúdo autônomo — frequentemente com legenda — que é referenciado pelo fluxo principal do documento, mas que poderia ser removido sem comprometer sua continuidade. `<figcaption>` fornece a legenda ou descrição do conteúdo do `<figure>`.

**Formatos de imagem para a Web**

A escolha do formato de imagem tem impacto direto no desempenho da página:

| Formato | Características | Uso recomendado |
|---|---|---|
| **JPEG / JPG** | Compressão com perdas; não suporta transparência | Fotografias e imagens com gradientes complexos |
| **PNG** | Compressão sem perdas; suporta transparência | Logotipos, ícones, imagens com texto, screenshots |
| **SVG** | Vetor escalável; código XML; muito leve | Ícones, logotipos, ilustrações, diagramas |
| **WebP** | Compressão superior ao JPEG/PNG; suporta transparência | Substituto moderno para JPEG e PNG |
| **AVIF** | Compressão ainda mais eficiente que WebP | Imagens de alta qualidade com menor tamanho |
| **GIF** | Suporta animações simples; paleta limitada | Animações simples (prefira `<video>` ou CSS) |

**Vídeo e áudio nativos (`<video>` e `<audio>`)**

O HTML5 introduziu suporte nativo a vídeo e áudio, eliminando a dependência de plugins externos como o Adobe Flash:

```html
<!-- Elemento de vídeo com múltiplas fontes para compatibilidade -->
<video
  controls
  width="800"
  height="450"
  poster="thumbnail.jpg"
  preload="metadata"
>
  <source src="aula-intro.mp4" type="video/mp4" />
  <source src="aula-intro.webm" type="video/webm" />
  <!-- Fallback para navegadores sem suporte -->
  <p>Seu navegador não suporta reprodução de vídeo.
    <a href="aula-intro.mp4">Baixe o vídeo aqui</a>.
  </p>
</video>
```

---

### 2.2.4 — Listas (ordenadas e não ordenadas)

O HTML define três tipos de listas, cada uma com semântica específica:

**Lista não ordenada (`<ul>` — *Unordered List*)**

Utilizada quando a **ordem dos itens não é relevante** para o significado do conteúdo. O navegador renderiza cada item (`<li>`) com um marcador visual (por padrão, um ponto preenchido), que pode ser personalizado via CSS.

```html
<ul>
  <li>HTML</li>
  <li>CSS</li>
  <li>JavaScript</li>
</ul>
```

**Lista ordenada (`<ol>` — *Ordered List*)**

Utilizada quando a **ordem dos itens é semanticamente significativa** — instruções passo a passo, classificações, procedimentos, etc. O navegador renderiza os itens numerados sequencialmente por padrão.

```html
<ol>
  <li>Verificar o cache local do navegador</li>
  <li>Realizar a resolução DNS do domínio</li>
  <li>Estabelecer a conexão TCP com o servidor</li>
  <li>Enviar a requisição HTTP</li>
  <li>Receber e renderizar a resposta</li>
</ol>
```

O elemento `<ol>` aceita atributos que controlam a numeração:

```html
<!-- Começar a contagem a partir de 5 -->
<ol start="5">
  <li>Quinto item</li>
  <li>Sexto item</li>
</ol>

<!-- Contagem regressiva -->
<ol reversed>
  <li>Terceiro lugar</li>
  <li>Segundo lugar</li>
  <li>Primeiro lugar</li>
</ol>

<!-- Tipo de marcador: A, a, I, i, 1 (padrão) -->
<ol type="A">
  <li>Opção A</li>
  <li>Opção B</li>
</ol>
```

**Lista de definições (`<dl>`, `<dt>`, `<dd>` — *Description List*)**

Utilizada para pares **termo–descrição** (glossários, metadados, dicionários):

```html
<dl>
  <dt>HTTP</dt>
  <dd>Protocolo de transferência de hipertexto; define as regras de comunicação entre clientes e servidores na Web.</dd>

  <dt>DNS</dt>
  <dd>Sistema de nomes de domínio; traduz nomes de domínio legíveis por humanos em endereços IP.</dd>

  <dt>DOM</dt>
  <dd>Modelo de objeto do documento; representação em árvore de um documento HTML em memória.</dd>
</dl>
```

**Listas aninhadas**

Listas podem ser aninhadas para representar hierarquias:

```html
<ul>
  <li>Frontend
    <ul>
      <li>HTML</li>
      <li>CSS</li>
      <li>JavaScript</li>
    </ul>
  </li>
  <li>Backend
    <ul>
      <li>Node.js</li>
      <li>Python</li>
    </ul>
  </li>
</ul>
```

---

#### **Atividades — Seção 2.2**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Qual é a diferença semântica entre os elementos <code>&lt;strong&gt;</code> e <code>&lt;b&gt;</code>?</p>

  <button data-option="a">Não há diferença; ambos produzem texto em negrito da mesma forma.</button>
  <button data-option="b"><code>&lt;strong&gt;</code> indica importância elevada com implicação semântica; <code>&lt;b&gt;</code> indica apenas destaque tipográfico convencional, sem semântica associada.</button>
  <button data-option="c"><code>&lt;b&gt;</code> é o elemento correto para textos importantes; <code>&lt;strong&gt;</code> é uma alternativa obsoleta.</button>
  <button data-option="d"><code>&lt;strong&gt;</code> é exclusivo do HTML5; <code>&lt;b&gt;</code> existe desde versões anteriores.</button>

  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Por que o atributo <code>alt</code> em imagens é tecnicamente obrigatório, mesmo em imagens decorativas?</p>

  <button data-option="a">Para que o texto alternativo seja exibido ao lado da imagem como legenda.</button>
  <button data-option="b">Para melhorar exclusivamente o posicionamento da página em mecanismos de busca.</button>
  <button data-option="c">Porque leitores de tela leem o nome do arquivo quando o atributo é omitido; em imagens decorativas, o <code>alt=""</code> vazio instrui a tecnologia assistiva a ignorá-las.</button>
  <button data-option="d">Porque sem o atributo <code>alt</code>, o navegador não carrega a imagem.</button>

  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>3.</strong> Em qual situação o uso de <code>&lt;ol&gt;</code> é semanticamente mais apropriado do que <code>&lt;ul&gt;</code>?</p>

  <button data-option="a">Quando a ordem dos itens é semanticamente significativa, como em instruções passo a passo ou classificações.</button>
  <button data-option="b">Quando se deseja que os itens sejam exibidos horizontalmente.</button>
  <button data-option="c">Quando a lista contém mais de cinco itens.</button>
  <button data-option="d">Quando os itens possuem descrições associadas.</button>

  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Criar página com textos, links, imagens e listas *(link será adicionado)*

---

## 2.3 — Estruturação de Conteúdo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A marcação de elementos individuais — títulos, parágrafos, links, imagens — é apenas o primeiro nível do trabalho de estruturação em HTML. O segundo nível, igualmente importante, consiste em **agrupar e organizar esses elementos** em regiões lógicas e coerentes que reflitam a arquitetura informacional da página. É neste domínio que reside a essência do **HTML semântico** — conceito que será aprofundado no Capítulo 3, mas cujos fundamentos são introduzidos nesta seção.

### 2.3.1 — Divs e seções

**O elemento `<div>`**

O `<div>` (*division*) é um **elemento de contêiner genérico**, desprovido de qualquer significado semântico intrínseco. Seu único propósito é **agrupar** outros elementos para fins de estilização via CSS ou manipulação via JavaScript. Quando nenhum elemento semântico adequado existe para representar um determinado agrupamento, o `<div>` é a escolha correta.

```html
<!-- Uso legítimo de div: contêiner para layout, sem semântica específica -->
<div class="grid-container">
  <div class="coluna-principal">
    <!-- conteúdo principal -->
  </div>
  <div class="coluna-lateral">
    <!-- conteúdo lateral -->
  </div>
</div>
```

Contudo, um erro recorrente — denominado pejorativamente de ***divitis*** na comunidade de desenvolvimento — consiste em utilizar `<div>` para todo e qualquer agrupamento, ignorando os elementos semânticos disponíveis no HTML5. Esta prática produz documentos estruturalmente opacos, inacessíveis e de difícil manutenção.

**O elemento `<span>`**

O `<span>` é o equivalente **inline** do `<div>`: um contêiner genérico sem semântica, utilizado para aplicar estilos ou comportamentos a fragmentos de texto dentro de um parágrafo ou outro elemento inline.

```html
<p>
  O código de status
  <span class="destaque-codigo">404</span>
  indica que o recurso solicitado não foi encontrado.
</p>
```

**Quando usar `<div>` e `<span>`**

A regra de uso é direta: utilize `<div>` e `<span>` **somente quando nenhum elemento semântico for apropriado**. Se existe um elemento HTML que descreva com precisão o conteúdo agrupado — `<article>`, `<section>`, `<nav>`, `<aside>`, etc. — esse elemento deve ser preferido.

---

### 2.3.2 — Cabeçalho, rodapé e navegação

O HTML5 introduziu um conjunto de elementos de **seção estrutural** (*sectioning elements*) que permitem delimitar as regiões funcionais canônicas de uma página web. Estes elementos não apenas organizam visualmente o layout, mas comunicam a função de cada região a navegadores, tecnologias assistivas e mecanismos de busca.

> **Importante:** Os elementos de seção estrutural não possuem hierarquia visual automática — eles não empurram conteúdo, não aplicam espaçamento, não criam colunas. Toda a apresentação visual continua sendo responsabilidade do CSS. O que esses elementos oferecem é **significado semântico** sobre a função de cada região.

**`<header>` — Cabeçalho**

O elemento `<header>` representa o **conteúdo introdutório** de sua seção de escopo. Tipicamente contém o título principal, logotipo, subtítulo e/ou navegação primária. Importante: `<header>` não se limita ao cabeçalho global da página — ele pode ser usado como cabeçalho de um `<article>` ou `<section>` específico.

```html
<!-- Cabeçalho global da página -->
<header>
  <img src="logo.svg" alt="Logotipo IFAL" width="120" height="60" />
  <h1>Programação Web 1</h1>
  <nav>
    <!-- navegação principal -->
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

**`<nav>` — Navegação**

O elemento `<nav>` delimita um conjunto de **links de navegação** — seja a navegação principal do site, um menu de seções, um sumário ou links de paginação. Não é necessário marcar todos os grupos de links com `<nav>`; o elemento deve ser reservado para blocos de navegação de importância significativa.

```html
<nav aria-label="Navegação principal">
  <ul>
    <li><a href="/">Início</a></li>
    <li><a href="/capitulos">Capítulos</a></li>
    <li><a href="/atividades">Atividades</a></li>
    <li><a href="/sobre">Sobre</a></li>
  </ul>
</nav>
```

**`<footer>` — Rodapé**

O elemento `<footer>` representa o **rodapé** de sua seção de escopo. Tipicamente contém informações como autoria, direitos autorais, links secundários, dados de contato e metadados sobre o conteúdo. Assim como `<header>`, pode ser usado tanto no nível global da página quanto no nível de um `<article>` ou `<section>`.

```html
<footer>
  <p>© 2026 IFAL — Instituto Federal de Alagoas</p>
  <nav aria-label="Links do rodapé">
    <a href="/politica-privacidade">Política de Privacidade</a>
    <a href="/acessibilidade">Acessibilidade</a>
    <a href="/contato">Contato</a>
  </nav>
</footer>
```

---

### 2.3.3 — Agrupamento de conteúdo

Além do cabeçalho, navegação e rodapé, o HTML5 disponibiliza elementos para estruturar o corpo do conteúdo principal com precisão semântica.

**`<main>` — Conteúdo principal**

O elemento `<main>` delimita o **conteúdo principal e único** da página — o conteúdo diretamente relacionado ao seu tópico central, excluindo elementos repetidos em outras páginas (cabeçalho, navegação, rodapé, *sidebars*). Deve existir **apenas um `<main>` por página** e ele não deve ser descendente de `<article>`, `<aside>`, `<header>`, `<footer>` ou `<nav>`.

**`<article>` — Conteúdo autônomo**

O elemento `<article>` representa um **conteúdo independente e autossuficiente** — um fragmento que faria sentido publicado de forma isolada, como uma postagem de blog, um artigo jornalístico, um comentário de usuário ou uma ficha de produto.

**`<section>` — Seção temática**

O elemento `<section>` delimita uma **seção temática genérica** de um documento ou aplicação, tipicamente acompanhada de um título. Deve ser utilizado quando o conteúdo pode ser identificado como um grupo temático distinto, mas não constitui um conteúdo autônomo (que justificaria `<article>`).

**`<aside>` — Conteúdo tangencial**

O elemento `<aside>` representa conteúdo **tangencialmente relacionado** ao conteúdo ao seu redor — informações que poderiam ser removidas sem comprometer o fluxo principal. Exemplos: notas de rodapé, caixas de destaque, listas de links relacionados, publicidade, perfis de autor.

**Estrutura de página completa com elementos semânticos**

O exemplo a seguir ilustra a composição de uma página típica utilizando todos os elementos discutidos nesta seção:

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Programação Web 1 — Capítulo 2</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>

  <!-- Cabeçalho global da página -->
  <header>
    <a href="/" aria-label="Ir para a página inicial">
      <img src="assets/images/logo.svg" alt="IFAL" width="80" height="40" />
    </a>
    <h1>Programação Web 1</h1>

    <!-- Navegação principal -->
    <nav aria-label="Navegação principal">
      <ul>
        <li><a href="/capitulos/01">Capítulo 1</a></li>
        <li><a href="/capitulos/02" aria-current="page">Capítulo 2</a></li>
        <li><a href="/capitulos/03">Capítulo 3</a></li>
      </ul>
    </nav>
  </header>

  <!-- Conteúdo principal: único por página -->
  <main>

    <!-- Artigo: conteúdo autônomo e identificável -->
    <article>
      <header>
        <h2>Capítulo 2 — Fundamentos do HTML</h2>
        <p>
          Atualizado em
          <time datetime="2026-03-01">1º de março de 2026</time>
        </p>
      </header>

      <!-- Seção temática dentro do artigo -->
      <section aria-labelledby="titulo-intro">
        <h3 id="titulo-intro">2.1 — Introdução ao HTML</h3>
        <p>O HTML é a linguagem de marcação que estrutura o conteúdo da Web...</p>
      </section>

      <section aria-labelledby="titulo-tags">
        <h3 id="titulo-tags">2.2 — Tags Essenciais</h3>
        <p>As tags essenciais constituem o vocabulário fundamental do HTML...</p>

        <!-- Figura com legenda semântica -->
        <figure>
          <img
            src="assets/figures/estrutura-html.png"
            alt="Diagrama da estrutura hierárquica de um documento HTML"
            width="600"
            height="350"
            loading="lazy"
          />
          <figcaption>
            Figura 2 — Representação hierárquica da estrutura de um documento HTML5.
          </figcaption>
        </figure>
      </section>

      <footer>
        <p>
          Autoria: Prof. [Nome] —
          <a href="/licenca">Licença Creative Commons BY-SA 4.0</a>
        </p>
      </footer>
    </article>

    <!-- Conteúdo tangencial: relacionado mas não central -->
    <aside aria-label="Recursos complementares">
      <h2>Recursos complementares</h2>
      <ul>
        <li><a href="https://developer.mozilla.org/pt-BR/docs/Web/HTML">MDN Web Docs — HTML</a></li>
        <li><a href="https://html.spec.whatwg.org/">WHATWG — HTML Living Standard</a></li>
        <li><a href="https://validator.w3.org/">W3C Markup Validation Service</a></li>
      </ul>
    </aside>

  </main>

  <!-- Rodapé global da página -->
  <footer>
    <p>© 2026 IFAL — Instituto Federal de Alagoas. Material didático de uso livre.</p>
    <nav aria-label="Links institucionais">
      <a href="/acessibilidade">Acessibilidade</a>
      <a href="/contato">Contato</a>
    </nav>
  </footer>

  <script src="js/script.js" defer></script>
</body>
</html>
```

**Mapa visual da estrutura semântica**

```
<body>
├── <header>          ← Cabeçalho global (logo, h1, nav principal)
│   └── <nav>         ← Navegação principal
├── <main>            ← Conteúdo principal (único por página)
│   ├── <article>     ← Conteúdo autônomo (o capítulo em si)
│   │   ├── <header>  ← Cabeçalho do artigo (h2, metadados)
│   │   ├── <section> ← Seção 2.1
│   │   ├── <section> ← Seção 2.2
│   │   └── <footer>  ← Rodapé do artigo (autoria, licença)
│   └── <aside>       ← Conteúdo tangencial (links relacionados)
└── <footer>          ← Rodapé global (copyright, links inst.)
```

> **Validação do documento HTML**
>
> O W3C disponibiliza o **Markup Validation Service**, uma ferramenta online que verifica a conformidade sintática de documentos HTML com a especificação. A validação regular do código é uma prática profissional essencial e deve ser incorporada ao fluxo de desenvolvimento desde as primeiras atividades.
>
> **Referência:** [https://validator.w3.org/](https://validator.w3.org/)

---

#### **Atividades — Seção 2.3**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Qual é a distinção semântica entre os elementos <code>&lt;article&gt;</code> e <code>&lt;section&gt;</code>?</p>

  <button data-option="a">Não há distinção; ambos são contêineres genéricos equivalentes ao <code>&lt;div&gt;</code>.</button>
  <button data-option="b"><code>&lt;article&gt;</code> representa conteúdo autônomo e independente que faria sentido isolado; <code>&lt;section&gt;</code> representa uma seção temática de um documento, geralmente não autocontida.</button>
  <button data-option="c"><code>&lt;section&gt;</code> é utilizado para o conteúdo principal da página; <code>&lt;article&gt;</code> para conteúdo secundário.</button>
  <button data-option="d"><code>&lt;article&gt;</code> é exclusivo para artigos jornalísticos; <code>&lt;section&gt;</code> pode ser utilizado em qualquer tipo de conteúdo.</button>

  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Por que o elemento <code>&lt;main&gt;</code> deve ocorrer apenas uma vez por página?</p>

  <button data-option="a">Por ser um elemento HTML5 recente, navegadores antigos não suportam múltiplas instâncias.</button>
  <button data-option="b">Para evitar conflitos de estilo com o CSS.</button>
  <button data-option="c">Porque ele representa o conteúdo <strong>principal e único</strong> da página; múltiplas instâncias criariam ambiguidade sobre qual região contém o conteúdo central do documento.</button>
  <button data-option="d">Porque o <code>&lt;main&gt;</code> só pode ser filho direto do <code>&lt;body&gt;</code>, que é único.</button>

  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual dos cenários a seguir justifica semanticamente o uso do elemento <code>&lt;aside&gt;</code>?</p>

  <button data-option="a">Um bloco de código de exemplo dentro de um tutorial técnico.</button>
  <button data-option="b">O menu de navegação principal do site.</button>
  <button data-option="c">O conteúdo central de uma postagem de blog.</button>
  <button data-option="d">Uma caixa lateral com links para artigos relacionados, tangencialmente vinculada ao conteúdo principal.</button>

  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Criar layout simples com `<header>`, `<main>` e `<footer>` *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 1 — Introdução à Web e Ferramentas](01-introducao.md)
[:material-arrow-right: Ir ao Capítulo 3 — HTML Semântico e Acessibilidade](03-html-semantico.md)
