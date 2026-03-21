# Capítulo 4 — Tabelas, Listas e Mídia

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 4.1 — Tabelas HTML

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Uma tabela HTML é utilizada para representar **dados organizados em linhas e colunas**.

As tabelas constituem um dos mecanismos mais antigos e ao mesmo tempo mais mal utilizados do HTML. Introduzidas desde as primeiras versões da linguagem, foram durante anos empregadas indevidamente como ferramenta de layout de página — prática que o advento do CSS tornou obsoleta e que a especificação do HTML5 condena explicitamente. Compreender o propósito correto das tabelas, sua estrutura semântica e suas implicações de acessibilidade é essencial para qualquer desenvolvedor que precise apresentar dados tabulares de forma adequada.

Os principais elementos são:

- `<table>` — define a tabela  
- `<tr>` — define uma linha  
- `<td>` — define uma célula de dado  
- `<th>` — define uma célula de cabeçalho  

> 💡 **Importante:**  
> Neste momento do curso, estamos focando apenas na **estrutura (HTML)**.  
> A aparência visual (cores, bordas, espaçamento) será estudada no próximo bimestre com **CSS**.


### 4.1.1 — Quando usar tabelas (e quando não usar)

Tabelas devem ser usadas exclusivamente para **dados tabulares**, ou seja, informações organizadas em linhas e colunas com relação lógica.

O critério de uso é objetivo: se o conteúdo pode ser descrito por uma grade onde cada célula representa a intersecção entre uma categoria de linha e uma categoria de coluna, uma tabela é o elemento correto. Se o conteúdo é apenas uma lista de itens que se beneficiaria de um layout em múltiplas colunas por razões puramente visuais, a solução correta é CSS — não uma tabela.

> ⚠️ **Erro comum:** usar tabelas para layout de página  
> Isso torna o código semanticamente incorreto e prejudica a acessibilidade.

**Usos incorretos que devem ser evitados:**

```html
<!-- INCORRETO: tabela usada para criar layout de duas colunas -->
<table>
  <tr>
    <td>
      <nav>Menu lateral</nav>
    </td>
    <td>
      <main>Conteúdo principal</main>
    </td>
  </tr>
</table>

<!-- CORRETO: layout é responsabilidade do CSS -->
<div class="layout">
  <nav>Menu lateral</nav>
  <main>Conteúdo principal</main>
</div>
```

O uso de tabelas para layout, além de semanticamente incorreto, produz documentos inacessíveis: leitores de tela anunciam o início e o fim de cada tabela, o número de linhas e colunas, e navegam célula a célula — comportamento adequado para dados tabulares, mas completamente inadequado para estrutura de página.



> **Referência:** [WHATWG — The table element](https://html.spec.whatwg.org/multipage/tables.html#the-table-element)

### 4.1.2 — Estrutura básica: `<table>`, `<tr>`, `<td>` e `<th>`

A estrutura mínima de uma tabela HTML é composta por três elementos obrigatórios:

- **`<table>`** — o contêiner raiz da tabela
- **`<tr>`** (*table row*) — uma linha da tabela
- **`<td>`** (*table data*) — uma célula de dado, dentro de uma linha
- **`<th>`** (*table header*) — uma célula de cabeçalho, semânticamente distinta de `<td>`

```html
<table>
  <tr>
    <th>Disciplina</th>
    <th>Dia</th>
    <th>Horário</th>
  </tr>
  <tr>
    <td>Programação Web 1</td>
    <td>Sexta-feira</td>
    <td>08h–10h</td>
  </tr>
  <tr>
    <td>Banco de Dados</td>
    <td>Quarta-feira</td>
    <td>14h–16h</td>
  </tr>
</table>
```

> ✔️ **Boa prática:**  
> Use `<th>` para cabeçalhos — isso melhora a acessibilidade e a compreensão da tabela.

A distinção entre `<th>` e `<td>` não é apenas visual (o `<th>` é renderizado em negrito e centralizado por padrão): ela é **semântica**. O elemento `<th>` comunica que aquela célula é um **rótulo** para as demais células da linha ou coluna, estabelecendo uma relação de cabeçalho que tecnologias assistivas utilizam para contextualizar os dados. Quando um leitor de tela navega por uma tabela, ele anuncia o cabeçalho da coluna ou linha ao ler cada célula de dado — mas apenas se `<th>` for utilizado corretamente.

### 4.1.3 — Estrutura semântica: `<thead>`, `<tbody>`, `<tfoot>` e `<caption>`

Para tabelas de qualquer complexidade real, o HTML oferece elementos de agrupamento semântico que organizam as linhas em regiões funcionais distintas:

- **`<thead>`** (*table head*) — agrupa as linhas de cabeçalho da tabela
- **`<tbody>`** (*table body*) — agrupa as linhas de dados (o corpo da tabela)
- **`<tfoot>`** (*table foot*) — agrupa as linhas de rodapé, geralmente contendo totais ou resumos
- **`<caption>`** — fornece um título descritivo para a tabela inteira

```html
<table>
  <caption><strong>Horário semanal — Sistemas de Informação, 3º Período (2026.1)</strong></caption>

  <thead>
    <tr>
      <th scope="col">Disciplina</th>
      <th scope="col">Professor</th>
      <th scope="col">Dia</th>
      <th scope="col">Horário</th>
      <th scope="col">Sala</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>Programação Web 1</td>
      <td>Prof. Silva</td>
      <td>Sexta-feira</td>
      <td>08h–10h</td>
      <td>Lab. 3</td>
    </tr>
    <tr>
      <td>Banco de Dados I</td>
      <td>Prof. Santos</td>
      <td>Quarta-feira</td>
      <td>14h–16h</td>
      <td>Lab. 2</td>
    </tr>
    <tr>
      <td>Estruturas de Dados</td>
      <td>Prof. Lima</td>
      <td>Terça-feira</td>
      <td>10h–12h</td>
      <td>Sala 7</td>
    </tr>
  </tbody>

  <tfoot>
    <tr>
      <td colspan="5">Total: 3 disciplinas — 6 horas semanais</td>
    </tr>
  </tfoot>
</table>
```

O elemento `<caption>` merece atenção especial: ele é o mecanismo semântico correto para titular uma tabela, sendo associado automaticamente a ela por leitores de tela. Ao navegar para uma tabela, o leitor de tela anuncia o caption antes de qualquer outro conteúdo — permitindo que o usuário decida se deseja explorar os dados ou pular para a próxima região. A ausência do `<caption>` obriga o usuário a navegar pela tabela para descobrir seu conteúdo, o que é uma falha de acessibilidade.

Os elementos `<thead>`, `<tbody>` e `<tfoot>` oferecem ainda uma vantagem prática no CSS: permitem que o cabeçalho e o rodapé da tabela permaneçam fixos enquanto o corpo rola — comportamento útil em tabelas longas — sem JavaScript adicional.

> **Nota técnica:** o elemento `<tfoot>` pode ser declarado antes do `<tbody>` no código-fonte HTML sem que isso afete a renderização. O navegador sempre posicionará o `<tfoot>` visualmente após o `<tbody>`, independentemente da ordem no código.

### 4.1.4 — Mesclagem de células: `colspan` e `rowspan`

Tabelas com estrutura mais complexa frequentemente requerem que uma célula ocupe o espaço de múltiplas colunas ou linhas. O HTML oferece dois atributos para esse propósito:

- **`colspan`** — indica que a célula deve se estender por *n* colunas
- **`rowspan`** — indica que a célula deve se estender por *n* linhas

```html
<table>
  <caption>Disponibilidade de laboratórios por turno</caption>

  <thead>
    <tr>
      <th scope="col">Laboratório</th>
      <th scope="col">Segunda</th>
      <th scope="col">Terça</th>
      <th scope="col">Quarta</th>
      <th scope="col">Quinta</th>
      <th scope="col">Sexta</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <!-- rowspan: "Lab. 1" abrange duas linhas (Manhã e Tarde) -->
      <th scope="row" rowspan="2">Lab. 1</th>
      <td>Livre</td>
      <td>Ocupado</td>
      <td>Livre</td>
      <td>Livre</td>
      <td>Ocupado</td>
    </tr>
    <tr>
      <!-- Linha de continuação do Lab. 1 — a primeira célula foi consumida pelo rowspan -->
      <td>Ocupado</td>
      <td>Livre</td>
      <td>Ocupado</td>
      <td>Livre</td>
      <td>Livre</td>
    </tr>
    <tr>
      <th scope="row">Lab. 2</th>
      <!-- colspan: esta célula abrange 5 colunas -->
      <td colspan="5">Em manutenção esta semana</td>
    </tr>
  </tbody>
</table>
```

Um erro frequente ao utilizar `rowspan` é não subtrair as células correspondentes nas linhas subsequentes. Quando uma célula com `rowspan="2"` é declarada em uma linha, a linha seguinte deve conter uma célula a menos — pois aquela posição já está "ocupada" pela célula que se estende. O não cumprimento dessa regra produz tabelas com colunas desalinhadas.

> **Imagem sugerida:** diagrama visual de uma tabela com `colspan` e `rowspan` destacando as células mescladas e suas fronteiras — com anotações indicando os valores dos atributos em cada célula afetada.
>
> *(imagem será adicionada posteriormente)*

### 4.1.5 — Acessibilidade em tabelas: `scope` e `headers`

Tabelas simples com uma única linha de cabeçalho no topo são interpretadas corretamente pela maioria dos leitores de tela sem atributos adicionais. Contudo, tabelas mais complexas — com cabeçalhos em múltiplas direções, células mescladas ou estruturas irregulares — requerem atributos explícitos para que a relação entre cabeçalhos e células de dado seja inequívoca.

**O atributo `scope`**

O atributo `scope` é declarado em elementos `<th>` e indica a direção em que aquele cabeçalho se aplica:

| Valor | Significado |
|---|---|
| `scope="col"` | O cabeçalho se aplica a todas as células da **coluna** abaixo |
| `scope="row"` | O cabeçalho se aplica a todas as células da **linha** à direita |
| `scope="colgroup"` | O cabeçalho se aplica a um grupo de colunas (`<colgroup>`) |
| `scope="rowgroup"` | O cabeçalho se aplica a um grupo de linhas (`<thead>`, `<tbody>`, `<tfoot>`) |

```html
<table>
  <caption>Notas bimestrais — Turma A</caption>
  <thead>
    <tr>
      <th scope="col">Aluno</th>
      <th scope="col">1º Bimestre</th>
      <th scope="col">2º Bimestre</th>
      <th scope="col">Média</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Ana Souza</th>
      <td>8.5</td>
      <td>9.0</td>
      <td>8.75</td>
    </tr>
    <tr>
      <th scope="row">Bruno Lima</th>
      <td>7.0</td>
      <td>7.5</td>
      <td>7.25</td>
    </tr>
  </tbody>
</table>
```

Neste exemplo, quando um leitor de tela navega para a célula `8.5`, ele anuncia: "1º Bimestre, Ana Souza: 8.5" — contextualizando o dado com seus dois cabeçalhos (coluna e linha). Sem o atributo `scope`, este anúncio pode não ocorrer corretamente em todos os leitores de tela.

**O atributo `headers`**

Para tabelas de alta complexidade — com múltiplos níveis de cabeçalho ou estruturas irregulares —, o atributo `headers` permite associar explicitamente cada célula de dado a um ou mais cabeçalhos por meio de seus `id`:

```html
<table>
  <caption>Consumo de recursos por servidor</caption>
  <thead>
    <tr>
      <th id="servidor">Servidor</th>
      <th id="cpu" colspan="2">CPU (%)</th>
      <th id="ram" colspan="2">RAM (GB)</th>
    </tr>
    <tr>
      <td></td>
      <th id="cpu-min" headers="cpu">Mínimo</th>
      <th id="cpu-max" headers="cpu">Máximo</th>
      <th id="ram-min" headers="ram">Mínimo</th>
      <th id="ram-max" headers="ram">Máximo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="srv1" headers="servidor">Servidor A</th>
      <td headers="srv1 cpu cpu-min">12</td>
      <td headers="srv1 cpu cpu-max">78</td>
      <td headers="srv1 ram ram-min">4.2</td>
      <td headers="srv1 ram ram-max">15.8</td>
    </tr>
  </tbody>
</table>
```

O uso de `headers` é reservado para tabelas de alta complexidade. Para a maioria das tabelas de uso cotidiano, `scope` é suficiente e mais simples de manter.

> **No DevTools:** abra a aba **Accessibility** no Chrome DevTools e selecione uma célula `<td>` de uma tabela. O painel exibirá os cabeçalhos associados àquela célula na árvore de acessibilidade — permitindo verificar se as relações `scope`/`headers` estão sendo interpretadas corretamente pelo navegador.

**Referências:**
- [MDN — `<table>`: The Table element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/table)
- [WebAIM — Creating Accessible Tables](https://webaim.org/techniques/tables/)
- [W3C — Tables Concepts](https://www.w3.org/WAI/tutorials/tables/)

---

#### **Atividade — Seção 4.1**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Por que o uso de tabelas HTML para criar layouts de página é considerado uma prática incorreta?</p>
  <button data-option="a">Porque tabelas não suportam CSS e não podem ser estilizadas.</button>
  <button data-option="b">Porque tabelas só funcionam em navegadores antigos.</button>
  <button data-option="c">Porque tabelas possuem semântica de dados tabulares; leitores de tela as anunciam como tal, tornando o layout inacessível e incoerente para usuários de tecnologias assistivas.</button>
  <button data-option="d">Porque tabelas aumentam o tempo de carregamento da página.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Qual é a função semântica do elemento <code>&lt;caption&gt;</code> em uma tabela?</p>
  <button data-option="a">Aplicar estilos visuais ao título da tabela via CSS.</button>
  <button data-option="b">Fornecer um título descritivo associado à tabela, anunciado por leitores de tela antes de qualquer dado — permitindo que o usuário decida se deseja explorar o conteúdo.</button>
  <button data-option="c">Definir o número de colunas da tabela.</button>
  <button data-option="d">Substituir o atributo <code>title</code> da tabela em navegadores modernos.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Uma célula `<th>` com `rowspan="3"` ocupa o espaço de quantas linhas?</p>
  <button data-option="a">Uma linha — <code>rowspan</code> define o número de pixels, não de linhas.</button>
  <button data-option="b">Duas linhas — a linha atual mais uma adicional.</button>
  <button data-option="c">Quatro linhas — <code>rowspan="3"</code> indica três linhas adicionais.</button>
  <button data-option="d">Três linhas — a célula se estende pela linha atual e pelas duas linhas subsequentes.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir a tabela de horários do curso com `<caption>`, `<thead>`, `<tbody>`, `<tfoot>`, atributos `scope` nos cabeçalhos e pelo menos uma célula com `colspan`. *(link será adicionado)*

---

## 4.2 — Listas avançadas

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O Capítulo 2 introduziu os três tipos fundamentais de listas em HTML: `<ul>`, `<ol>` e `<dl>`. Esta seção aprofunda os aspectos menos explorados de cada tipo — os atributos de controle de numeração de `<ol>`, as possibilidades semânticas da lista de definições e os padrões de aninhamento que permitem representar hierarquias complexas.

### 4.2.1 — Listas ordenadas em profundidade: atributos de controle

O elemento `<ol>` aceita três atributos que controlam o comportamento da numeração, todos com implicações semânticas e práticas relevantes:

**`type` — tipo de marcador**

O atributo `type` define o sistema de numeração utilizado. Embora a aparência dos marcadores possa ser controlada via CSS (propriedade `list-style-type`), o atributo HTML `type` tem peso semântico: ele comunica o *significado* do tipo de numeração, não apenas sua aparência.

| Valor | Sistema | Exemplo |
|---|---|---|
| `1` (padrão) | Arábico | 1, 2, 3... |
| `A` | Letras maiúsculas | A, B, C... |
| `a` | Letras minúsculas | a, b, c... |
| `I` | Romano maiúsculo | I, II, III... |
| `i` | Romano minúsculo | i, ii, iii... |

```html
<!-- Lista de etapas de um processo legal com numeração romana -->
<ol type="I">
  <li>Petição inicial</li>
  <li>Citação do réu</li>
  <li>Contestação</li>
  <li>Instrução processual</li>
  <li>Sentença</li>
</ol>

<!-- Subitens com letras minúsculas -->
<ol type="a">
  <li>Análise de requisitos</li>
  <li>Projeto de arquitetura</li>
  <li>Implementação</li>
</ol>
```

**`start` — valor inicial da contagem**

O atributo `start` define o número de partida da sequência. É especialmente útil quando uma lista ordenada é interrompida por outro conteúdo e precisa continuar a contagem a partir do ponto anterior:

```html
<p>Os três primeiros requisitos são obrigatórios:</p>
<ol start="1">
  <li>Autenticação de dois fatores</li>
  <li>Criptografia de dados em repouso</li>
  <li>Logs de auditoria</li>
</ol>

<p>Os requisitos a seguir são desejáveis mas opcionais:</p>
<ol start="4">
  <li>Dashboard de monitoramento em tempo real</li>
  <li>Exportação de relatórios em PDF</li>
</ol>
```

**`reversed` — contagem regressiva**

O atributo booleano `reversed` inverte a direção da contagem, produzindo uma sequência decrescente. Útil para rankings, contagens regressivas e listas onde os itens mais recentes têm numeração maior:

```html
<!-- Top 5 tecnologias mais usadas (5 → 1) -->
<ol reversed>
  <li>Vue.js</li>
  <li>Angular</li>
  <li>TypeScript</li>
  <li>React</li>
  <li>JavaScript</li>
</ol>
```

O atributo `value` em `<li>` permite sobrescrever o número de um item específico, fazendo com que os itens subsequentes continuem a partir desse valor:

```html
<ol>
  <li>Primeiro item</li>       <!-- 1 -->
  <li value="5">Quinto item</li> <!-- 5 -->
  <li>Sexto item</li>          <!-- 6 (continua a partir de 5) -->
</ol>
```

**Referência:** [MDN — `<ol>`: The Ordered List element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/ol)

### 4.2.2 — Listas de definição em profundidade: `<dl>`, `<dt>` e `<dd>`

A lista de definições é o tipo de lista menos compreendido e mais subutilizado do HTML. Sua semântica vai além de simples glossários: o elemento `<dl>` representa qualquer conjunto de pares **nome–valor** onde os nomes (`<dt>`) descrevem ou rotulam os valores (`<dd>`).

A estrutura fundamental:

```html
<dl>
  <dt>HTTP</dt>
  <dd>
    Protocolo de transferência de hipertexto; define as regras
    de comunicação entre clientes e servidores na Web.
  </dd>

  <dt>DNS</dt>
  <dd>
    Sistema de nomes de domínio; traduz nomes de domínio
    legíveis por humanos em endereços IP numéricos.
  </dd>
</dl>
```

**Variações semânticas importantes**

Um único `<dt>` pode ter múltiplos `<dd>` associados (um termo com várias definições ou valores):

```html
<dl>
  <dt>Formatos de imagem suportados</dt>
  <dd>JPEG — fotografias e gradientes complexos</dd>
  <dd>PNG — imagens com transparência e texto</dd>
  <dd>WebP — substituto moderno para JPEG e PNG</dd>
  <dd>SVG — gráficos vetoriais escaláveis</dd>
</dl>
```

Múltiplos `<dt>` podem compartilhar um único `<dd>` (sinônimos ou termos equivalentes com a mesma definição):

```html
<dl>
  <dt>Frontend</dt>
  <dt>Client-side</dt>
  <dd>
    Camada de desenvolvimento responsável pela interface
    com a qual o usuário interage diretamente no navegador.
  </dd>
</dl>
```

**Usos além do glossário**

A especificação permite o uso de `<dl>` para qualquer estrutura de metadados nome–valor, o que o torna adequado para uma variedade de contextos práticos:

```html
<!-- Ficha técnica de um produto -->
<dl>
  <dt>Autor</dt>
  <dd>Tim Berners-Lee</dd>

  <dt>Publicação</dt>
  <dd><time datetime="1989-03-12">12 de março de 1989</time></dd>

  <dt>Organização</dt>
  <dd>CERN — Organização Europeia para a Pesquisa Nuclear</dd>

  <dt>Título do documento</dt>
  <dd><cite>Information Management: A Proposal</cite></dd>
</dl>

<!-- Perguntas frequentes (FAQ) -->
<dl>
  <dt>O que é o HTML Living Standard?</dt>
  <dd>
    É a especificação em evolução contínua do HTML,
    mantida pelo WHATWG desde 2004.
  </dd>

  <dt>Qual a diferença entre HTML e XHTML?</dt>
  <dd>
    O XHTML é uma reformulação do HTML 4 com sintaxe
    XML estrita; o HTML5 retomou a abordagem mais
    tolerante do HTML original.
  </dd>
</dl>
```

**Referência:** [MDN — `<dl>`: The Description List element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/dl)

### 4.2.3 — Listas aninhadas e hierarquias complexas

O aninhamento de listas é o mecanismo HTML para representar **hierarquias de conteúdo** — estruturas onde itens possuem subitens, que por sua vez podem ter seus próprios subitens. O aninhamento é realizado inserindo um novo elemento de lista (`<ul>` ou `<ol>`) diretamente dentro de um elemento `<li>`, nunca diretamente dentro de `<ul>` ou `<ol>`.

```html
<!-- CORRETO: lista aninhada dentro de <li> -->
<ul>
  <li>Frontend
    <ul>
      <li>HTML</li>
      <li>CSS
        <ul>
          <li>Flexbox</li>
          <li>Grid</li>
        </ul>
      </li>
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

<!-- INCORRETO: lista aninhada fora do <li> -->
<ul>
  <li>Frontend</li>
  <ul>  <!-- ERRADO: <ul> não pode ser filho direto de outro <ul> -->
    <li>HTML</li>
  </ul>
</ul>
```

Listas de tipos diferentes podem ser aninhadas livremente:

```html
<!-- Sumário de um documento técnico -->
<ol>
  <li>Introdução
    <ol type="a">
      <li>Contexto e motivação</li>
      <li>Objetivos</li>
      <li>Estrutura do documento</li>
    </ol>
  </li>
  <li>Fundamentação teórica
    <ul>
      <li>Protocolos de rede</li>
      <li>Arquitetura cliente-servidor</li>
    </ul>
  </li>
  <li>Metodologia</li>
  <li>Resultados</li>
  <li>Conclusão</li>
</ol>
```

**Profundidade de aninhamento e legibilidade**

A especificação não impõe limite técnico para a profundidade de aninhamento de listas. Contudo, aninhamentos com mais de três níveis raramente são adequados para a Web: eles indicam, na maioria dos casos, que o conteúdo deveria ser reorganizado em seções distintas com títulos (`<section>` + `<h2>`/`<h3>`) em vez de uma estrutura de lista profundamente aninhada.

---

#### **Atividade — Seção 4.2**

<div class="quiz" data-answer="a">
  <p><strong>1.</strong> Em uma lista <code>&lt;ol reversed start="10"&gt;</code> com quatro itens, quais serão os números exibidos?</p>
  <button data-option="a">10, 9, 8, 7</button>
  <button data-option="b">1, 2, 3, 4 (reversed e start se anulam)</button>
  <button data-option="c">4, 3, 2, 1</button>
  <button data-option="d">10, 11, 12, 13</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Qual estrutura <code>&lt;dl&gt;</code> é semanticamente válida para representar um termo com três definições distintas?</p>
  <button data-option="a">Três elementos <code>&lt;dl&gt;</code> separados, cada um com um <code>&lt;dt&gt;</code> e um <code>&lt;dd&gt;</code>.</button>
  <button data-option="b">Um <code>&lt;dt&gt;</code> seguido de um único <code>&lt;dd&gt;</code> que contém as três definições separadas por <code>&lt;br&gt;</code>.</button>
  <button data-option="c">Um <code>&lt;dt&gt;</code> seguido de três elementos <code>&lt;dd&gt;</code> consecutivos, todos dentro do mesmo <code>&lt;dl&gt;</code>.</button>
  <button data-option="d">Três pares <code>&lt;dt&gt;</code>/<code>&lt;dd&gt;</code> com o mesmo texto no <code>&lt;dt&gt;</code>.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir um glossário de termos técnicos da Web utilizando `<dl>`, `<dt>` e `<dd>`, com pelo menos 8 termos, incluindo dois termos com múltiplas definições e dois sinônimos compartilhando uma mesma definição. *(link será adicionado)*

---

## 4.3 — Multimídia

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A Web moderna é essencialmente multimídia. Imagens, vídeos, áudios e conteúdos incorporados de plataformas externas são componentes ubíquos de páginas e aplicações web. O HTML5 consolidou o suporte nativo a esses recursos, eliminando a dependência de plugins externos como o Adobe Flash e estabelecendo uma base declarativa para a incorporação de mídia diretamente no documento.

### 4.3.1 — Imagens revisitadas: `srcset`, `sizes` e `<picture>`

O elemento `<img>` foi introduzido no Capítulo 2 com seus atributos fundamentais (`src`, `alt`, `width`, `height`, `loading`). Para cenários mais sofisticados — especialmente o contexto de design responsivo, onde a mesma página é acessada por dispositivos com telas de tamanhos e densidades radicalmente diferentes —, o HTML oferece mecanismos adicionais que permitem ao navegador selecionar a imagem mais adequada para cada contexto.

**O atributo `srcset`**

O atributo `srcset` fornece ao navegador um conjunto de imagens candidatas, cada uma com um descritor que indica sua largura em pixels ou sua densidade de pixels em relação à tela padrão. O navegador seleciona automaticamente a imagem mais adequada com base na tela do dispositivo, na resolução e na velocidade da conexão.

```html
<!-- Descritor de largura (w): o navegador escolhe com base no tamanho
     do espaço disponível para a imagem -->
<img
  src="foto-800.jpg"
  srcset="
    foto-400.jpg  400w,
    foto-800.jpg  800w,
    foto-1200.jpg 1200w
  "
  alt="Vista aérea do campus do IFAL"
  width="800"
  height="450"
/>

<!-- Descritor de densidade (x): o navegador escolhe com base
     na densidade de pixels da tela -->
<img
  src="logo.png"
  srcset="
    logo.png    1x,
    logo@2x.png 2x,
    logo@3x.png 3x
  "
  alt="Logotipo IFAL"
  width="120"
  height="60"
/>
```

**O atributo `sizes`**

Quando o atributo `srcset` utiliza descritores de largura (`w`), o atributo `sizes` é necessário para informar ao navegador qual será o tamanho de exibição da imagem em diferentes condições de viewport. Sem `sizes`, o navegador assume que a imagem ocupará 100% da largura do viewport — o que raramente é verdade.

```html
<img
  src="foto-800.jpg"
  srcset="
    foto-400.jpg  400w,
    foto-800.jpg  800w,
    foto-1200.jpg 1200w
  "
  sizes="
    (max-width: 600px) 100vw,
    (max-width: 1024px) 50vw,
    800px
  "
  alt="Diagrama da arquitetura de microsserviços"
  width="800"
  height="500"
/>
```

Neste exemplo, o navegador é informado de que: em viewports de até 600px, a imagem ocupa 100% da largura; em viewports de até 1024px, ocupa 50%; em viewports maiores, ocupa exatamente 800px. Com essa informação, o navegador pode calcular qual das imagens do `srcset` é suficiente — evitando o download de uma imagem de 1200px quando uma de 400px seria adequada.

**O elemento `<picture>`**

O elemento `<picture>` vai além de simplesmente selecionar a melhor versão de uma imagem: ele permite **trocar completamente a imagem** com base em condições de mídia, como orientação da tela, largura do viewport ou suporte a formatos modernos. É composto por zero ou mais elementos `<source>` e exatamente um elemento `<img>` de fallback.

```html
<!-- Caso de uso 1: suporte a formatos modernos com fallback -->
<picture>
  <!-- Navegadores que suportam AVIF recebem AVIF (melhor compressão) -->
  <source type="image/avif" srcset="foto.avif" />
  <!-- Navegadores que suportam WebP recebem WebP -->
  <source type="image/webp" srcset="foto.webp" />
  <!-- Fallback universal: JPEG -->
  <img src="foto.jpg" alt="Vista do laboratório de informática" width="800" height="450" />
</picture>

<!-- Caso de uso 2: imagens diferentes para diferentes viewports
     (art direction — mudança de enquadramento, não apenas de tamanho) -->
<picture>
  <!-- Em viewports largos: foto paisagem com contexto amplo -->
  <source
    media="(min-width: 768px)"
    srcset="campus-wide.jpg"
  />
  <!-- Em viewports estreitos: recorte em close da entrada principal -->
  <img
    src="campus-mobile.jpg"
    alt="Entrada principal do campus IFAL Arapiraca"
    width="400"
    height="400"
  />
</picture>
```

A ordem dos elementos `<source>` dentro de `<picture>` é importante: o navegador utiliza o **primeiro** `<source>` cujas condições são atendidas. Fontes mais específicas ou mais otimizadas devem ser listadas primeiro; o `<img>` de fallback deve ser sempre o último elemento.

**Referências:**
- [MDN — Responsive images](https://developer.mozilla.org/pt-BR/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)
- [MDN — `<picture>`: The Picture element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/picture)

### 4.3.2 — Vídeo nativo: `<video>`, múltiplas fontes e `<track>`

O elemento `<video>` foi introduzido no HTML5 como mecanismo nativo para incorporar vídeo sem dependência de plugins. Ele oferece controle declarativo sobre reprodução, dimensões, comportamento de pré-carregamento e legibilidade do conteúdo.

**Estrutura básica e atributos fundamentais**

```html
<video
  src="aula-html-semantico.mp4"
  controls
  width="800"
  height="450"
  poster="thumbnail-aula.jpg"
  preload="metadata"
>
  <p>
    Seu navegador não suporta reprodução de vídeo HTML5.
    <a href="aula-html-semantico.mp4">Baixe o vídeo aqui</a>.
  </p>
</video>
```

| Atributo | Tipo | Descrição |
|---|---|---|
| `src` | URL | Caminho do arquivo de vídeo |
| `controls` | booleano | Exibe os controles nativos do navegador (play, pause, volume, etc.) |
| `width` / `height` | número | Dimensões em pixels; previnem layout shift |
| `poster` | URL | Imagem de miniatura exibida antes da reprodução |
| `preload` | `none` / `metadata` / `auto` | Controla o pré-carregamento do vídeo |
| `autoplay` | booleano | Inicia a reprodução automaticamente (requer `muted`) |
| `muted` | booleano | Inicia sem áudio (necessário para `autoplay` funcionar) |
| `loop` | booleano | Reinicia automaticamente ao terminar |
| `playsinline` | booleano | Reproduz em linha em dispositivos iOS (sem tela cheia forçada) |

**Múltiplas fontes para compatibilidade**

Diferentes navegadores suportam diferentes formatos de vídeo. Para garantir compatibilidade universal, é recomendado fornecer o vídeo em múltiplos formatos utilizando elementos `<source>` filhos — o navegador utiliza o primeiro formato que consegue decodificar:

```html
<video controls width="800" height="450" poster="thumbnail.jpg">
  <!-- MP4/H.264: suporte universal -->
  <source src="aula.mp4" type="video/mp4" />
  <!-- WebM/VP9: melhor compressão, suporte na maioria dos navegadores modernos -->
  <source src="aula.webm" type="video/webm" />
  <!-- Fallback para navegadores sem suporte a <video> -->
  <p>
    Seu navegador não suporta vídeo HTML5.
    <a href="aula.mp4">Baixe o arquivo</a>.
  </p>
</video>
```

**Legendas e transcrições: o elemento `<track>`**

O elemento `<track>` associa arquivos de texto temporizado ao vídeo — legendas, transcrições, descrições de áudio e capítulos. É o mecanismo fundamental para tornar vídeos acessíveis a pessoas surdas ou com deficiência auditiva, e é exigido pelas diretrizes WCAG 2.1 (critério de sucesso 1.2.2 — Legendas pré-gravadas, nível A).

```html
<video controls width="800" height="450">
  <source src="aula-html.mp4" type="video/mp4" />

  <!-- Legendas em português (padrão) -->
  <track
    kind="subtitles"
    src="legendas/aula-html-pt.vtt"
    srclang="pt"
    label="Português"
    default
  />

  <!-- Legendas em inglês -->
  <track
    kind="subtitles"
    src="legendas/aula-html-en.vtt"
    srclang="en"
    label="English"
  />

  <!-- Descrição de áudio para usuários com deficiência visual -->
  <track
    kind="descriptions"
    src="legendas/aula-html-descricao.vtt"
    srclang="pt"
    label="Descrição de áudio"
  />
</video>
```

Os arquivos referenciados pelo `<track>` utilizam o formato **WebVTT** (*Web Video Text Tracks*), um formato de texto simples que associa intervalos de tempo a fragmentos de texto:

```
WEBVTT

00:00:00.000 --> 00:00:04.500
Bem-vindos à aula sobre HTML Semântico.

00:00:04.500 --> 00:00:09.000
Nesta aula, vamos aprender a utilizar os elementos
corretos para cada tipo de conteúdo.
```

Os valores possíveis para o atributo `kind` do `<track>` são: `subtitles` (legendas para conteúdo falado), `captions` (legendas completas incluindo efeitos sonoros), `descriptions` (descrição de áudio do conteúdo visual), `chapters` (marcadores de capítulo para navegação) e `metadata` (dados para uso por scripts).

**Referências:**
- [MDN — `<video>`: The Video Embed element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/video)
- [MDN — Adicionando legendas e subtítulos ao vídeo HTML5](https://developer.mozilla.org/pt-BR/docs/Web/Guide/Audio_and_video_delivery/Adding_captions_and_subtitles_to_HTML5_video)
- [W3C — WebVTT: The Web Video Text Tracks Format](https://www.w3.org/TR/webvtt1/)

### 4.3.3 — Áudio nativo: `<audio>`

O elemento `<audio>` segue o mesmo modelo do `<video>`: suporta múltiplas fontes via `<source>`, aceita os atributos `controls`, `autoplay`, `muted`, `loop` e `preload`, e oferece um conteúdo de fallback para navegadores sem suporte.

```html
<audio controls preload="metadata">
  <source src="podcast-ep01.mp3" type="audio/mpeg" />
  <source src="podcast-ep01.ogg" type="audio/ogg" />
  <p>
    Seu navegador não suporta áudio HTML5.
    <a href="podcast-ep01.mp3">Baixe o arquivo de áudio</a>.
  </p>
</audio>
```

As principais diferenças em relação ao `<video>` são a ausência dos atributos `width`, `height` e `poster` — que são específicos de conteúdo visual — e o suporte a um conjunto diferente de formatos de arquivo:

| Formato | MIME type | Suporte |
|---|---|---|
| MP3 | `audio/mpeg` | Universal |
| OGG Vorbis | `audio/ogg` | Firefox, Chrome, Opera |
| WAV | `audio/wav` | Suporte amplo, mas arquivos grandes |
| AAC | `audio/aac` | Safari, Chrome, Edge |
| WebM (Opus) | `audio/webm` | Chrome, Firefox, Edge |

Para conteúdo de áudio que acompanha informações importantes — como instruções em áudio, podcasts educacionais ou narrações de conteúdo —, as diretrizes WCAG recomendam fornecer uma transcrição textual (critério 1.2.1). O elemento `<track>` com `kind="captions"` pode ser utilizado em `<audio>` da mesma forma que em `<video>`.

**Referência:** [MDN — `<audio>`: The Embed Audio element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/audio)

### 4.3.4 — Embeds externos: `<iframe>`

O elemento `<iframe>` (*inline frame*) incorpora um documento HTML externo dentro do documento atual, renderizando-o em uma área retangular delimitada. É o mecanismo padrão para incorporar conteúdo de plataformas externas — vídeos do YouTube, podcasts do Spotify, mapas do Google Maps, visualizações do Figma, repositórios do GitHub e uma variedade de outros serviços.

**Estrutura básica**

```html
<iframe
  src="https://www.youtube.com/embed/hBRDMaxKB8Q"
  title="O que é e como funciona a internet"
  width="800"
  height="450"
  allowfullscreen
  loading="lazy"
>
</iframe>
```

O atributo `title` é **obrigatório do ponto de vista da acessibilidade**: ele fornece um rótulo descritivo para o `<iframe>` que é anunciado por leitores de tela ao focar o elemento. Sem o `title`, o usuário de leitor de tela não tem como saber o que o `<iframe>` contém antes de navegar para dentro dele.

**Atributos relevantes**

| Atributo | Descrição |
|---|---|
| `src` | URL do documento a ser incorporado |
| `title` | Descrição acessível do conteúdo (obrigatório para acessibilidade) |
| `width` / `height` | Dimensões do frame em pixels |
| `allowfullscreen` | Permite que o conteúdo entre em tela cheia |
| `loading="lazy"` | Adia o carregamento do frame até que ele esteja próximo do viewport |
| `sandbox` | Aplica restrições de segurança ao conteúdo incorporado |
| `allow` | Define permissões específicas (câmera, microfone, autoplay, etc.) |
| `referrerpolicy` | Controla as informações de referência enviadas ao servidor externo |

**Incorporando conteúdo de plataformas comuns**

As principais plataformas de mídia geram automaticamente o código de incorporação (`<iframe>`) com os atributos corretos. O fluxo padrão é: acessar a plataforma → localizar a opção "Compartilhar" ou "Incorporar" → copiar o código gerado → ajustar `width`, `height` e adicionar `title` e `loading="lazy"`.

```html
<!-- YouTube -->
<iframe
  width="800"
  height="450"
  src="https://www.youtube-nocookie.com/embed/VIDEO_ID?rel=0"
  title="Título descritivo do vídeo"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media;
         gyroscope; picture-in-picture"
  allowfullscreen
  loading="lazy"
></iframe>

<!-- Spotify — episódio de podcast -->
<iframe
  style="border-radius:12px"
  src="https://open.spotify.com/embed/episode/EPISODE_ID"
  width="100%"
  height="152"
  title="Nome do episódio do podcast"
  allow="autoplay; clipboard-write; encrypted-media; fullscreen;
         picture-in-picture"
  loading="lazy"
></iframe>

<!-- Google Maps -->
<iframe
  src="https://www.google.com/maps/embed?pb=EMBED_CODE"
  width="600"
  height="450"
  title="Localização do IFAL Campus Arapiraca"
  style="border:0;"
  allowfullscreen
  loading="lazy"
  referrerpolicy="no-referrer-when-downgrade"
></iframe>
```

**Observação sobre `youtube-nocookie.com`:** o domínio `youtube-nocookie.com` é uma alternativa ao domínio padrão do YouTube que não define cookies de rastreamento enquanto o usuário não interage com o player. Para materiais educacionais e ambientes institucionais, é a opção recomendada.

**Segurança: o atributo `sandbox`**

O atributo `sandbox` aplica um conjunto de restrições ao conteúdo do `<iframe>`, impedindo que scripts maliciosos no conteúdo incorporado acessem o documento pai, executem formulários ou abram janelas pop-up. Quando `sandbox` é declarado sem valores, todas as restrições são aplicadas:

```html
<!-- sandbox sem valores: máxima restrição -->
<iframe src="conteudo-externo.html" sandbox title="..."></iframe>

<!-- sandbox com permissões específicas habilitadas -->
<iframe
  src="widget-interativo.html"
  sandbox="allow-scripts allow-same-origin"
  title="Widget interativo"
></iframe>
```

Para conteúdo de plataformas conhecidas como YouTube e Google Maps, o uso de `sandbox` pode interferir na funcionalidade do player e geralmente não é aplicado.

**Referências:**
- [MDN — `<iframe>`: The Inline Frame element](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Element/iframe)
- [MDN — iframe sandbox](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#sandbox)

### 4.3.5 — `<figure>` e `<figcaption>` no contexto de mídia

O elemento `<figure>` — introduzido no Capítulo 3 no contexto semântico geral — tem aplicação especialmente relevante no contexto de mídia. Ele agrupa qualquer conteúdo multimídia (imagem, vídeo, áudio, `<iframe>`) com sua legenda correspondente, estabelecendo uma relação semântica entre o conteúdo e sua descrição.

```html
<!-- Vídeo com legenda -->
<figure>
  <video controls width="800" height="450" poster="thumb.jpg">
    <source src="demo-html5.mp4" type="video/mp4" />
    <track kind="subtitles" src="demo-pt.vtt" srclang="pt" label="Português" default />
  </video>
  <figcaption>
    Vídeo 1 — Demonstração das APIs multimídia do HTML5:
    elemento <code>&lt;video&gt;</code> com legendas WebVTT.
  </figcaption>
</figure>

<!-- Embed externo com legenda -->
<figure>
  <iframe
    width="100%"
    height="315"
    src="https://www.youtube-nocookie.com/embed/hBRDMaxKB8Q"
    title="O que é e como funciona a internet"
    allowfullscreen
    loading="lazy"
  ></iframe>
  <figcaption>
    Figura 3 — Vídeo introdutório: "O que é e como funciona a internet".
    Fonte: Canal Código Fonte TV, YouTube.
  </figcaption>
</figure>

<!-- Áudio com transcrição -->
<figure>
  <audio controls>
    <source src="entrevista-berners-lee.mp3" type="audio/mpeg" />
  </audio>
  <figcaption>
    Áudio 1 — Trecho da entrevista de Tim Berners-Lee sobre
    o futuro da Web aberta (2024).
    <a href="transcricao.html">Ler transcrição completa</a>.
  </figcaption>
</figure>
```

A combinação de `<figure>` com `<figcaption>` é especialmente importante para vídeos e áudios em materiais educacionais: ela fornece contexto imediato sobre o conteúdo da mídia, cita a fonte quando necessário, e oferece um ponto de ancoragem para links à transcrição ou aos recursos adicionais.


#### 🔎 Direitos autorais

> ⚠️ **Importante:**  
> Nem toda imagem, vídeo ou áudio disponível na internet pode ser utilizado livremente.

Utilize bancos de mídia gratuitos:
- Unsplash  
- Pexels  
- Pixabay  

**Referências gerais desta seção:**
- [MDN — Multimídia e incorporação](https://developer.mozilla.org/pt-BR/docs/Learn/HTML/Multimedia_and_embedding)
- [W3C — WCAG 2.1 — Guideline 1.2: Time-based Media](https://www.w3.org/TR/WCAG21/#time-based-media)
- [WebAIM — Accessible Rich Media](https://webaim.org/techniques/captions/)

---

#### **Atividade — Seção 4.3**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Qual é a diferença funcional entre o atributo <code>srcset</code> no elemento <code>&lt;img&gt;</code> e o elemento <code>&lt;picture&gt;</code>?</p>
  <button data-option="a">Não há diferença; ambos servem para fornecer múltiplas versões da mesma imagem.</button>
  <button data-option="b"><code>srcset</code> oferece versões da mesma imagem em diferentes resoluções para o navegador escolher; <code>&lt;picture&gt;</code> permite trocar completamente a imagem com base em condições de mídia, como viewport ou suporte a formatos.</button>
  <button data-option="c"><code>&lt;picture&gt;</code> é exclusivo para imagens WebP; <code>srcset</code> funciona com qualquer formato.</button>
  <button data-option="d"><code>srcset</code> só funciona em dispositivos móveis; <code>&lt;picture&gt;</code> é a versão para desktop.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>2.</strong> Por que o atributo <code>title</code> é obrigatório do ponto de vista da acessibilidade em um elemento <code>&lt;iframe&gt;</code>?</p>
  <button data-option="a">Porque sem o <code>title</code>, o iframe não é carregado em navegadores modernos.</button>
  <button data-option="b">Porque o <code>title</code> define o URL do conteúdo incorporado.</button>
  <button data-option="c">Porque o <code>title</code> controla a altura do iframe quando <code>height</code> não é declarado.</button>
  <button data-option="d">Porque leitores de tela anunciam o <code>title</code> ao focar o iframe, permitindo que o usuário saiba o que o elemento contém antes de navegar para dentro dele.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>3.</strong> Qual elemento HTML é responsável por associar arquivos de legenda no formato WebVTT a um elemento <code>&lt;video&gt;</code>?</p>
  <button data-option="a"><code>&lt;track&gt;</code></button>
  <button data-option="b"><code>&lt;caption&gt;</code></button>
  <button data-option="c"><code>&lt;source&gt;</code></button>
  <button data-option="d"><code>&lt;subtitle&gt;</code></button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir uma página multimídia que contenha: um elemento `<video>` com múltiplas fontes, um `<track>` de legendas e um `<poster>`; um elemento `<audio>` com fallback; um `<iframe>` incorporando um vídeo do YouTube com `title` e `loading="lazy"`; todos envolvidos por `<figure>` com `<figcaption>` adequados. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 3 — HTML Semântico](03-html-semantico.md)
[:material-arrow-right: Ir ao Capítulo 5 — Formulários HTML](05-formularios.md)
