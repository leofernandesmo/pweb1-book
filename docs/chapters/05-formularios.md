# Capítulo 5 — Formulários HTML

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 5.1 — O papel dos formulários na Web

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Formulários são o principal mecanismo de **comunicação bidirecional** entre o usuário e um servidor na Web. Enquanto a maioria dos elementos HTML serve para *apresentar* informações ao usuário — textos, imagens, vídeos —, os formulários invertem essa direção: eles coletam dados inseridos pelo usuário e os transmitem para processamento.

Essa distinção é fundamental para compreender o papel dos formulários no desenvolvimento web: **o HTML apenas estrutura e envia os dados. Ele não os processa.** O processamento — autenticar um login, salvar um cadastro em banco de dados, enviar um e-mail, processar um pagamento — é sempre responsabilidade do **backend**, um programa executado no servidor escrito em linguagens como Python, PHP, Node.js ou Java.

### 5.1.1 — O fluxo completo de envio de um formulário

Quando um usuário preenche e envia um formulário, ocorre a seguinte sequência de eventos:

```
[1] Usuário preenche os campos e clica em "Enviar"
        ↓
[2] Navegador coleta os dados dos campos
        ↓
[3] Navegador monta uma requisição HTTP com os dados
        ↓
[4] Requisição é enviada ao servidor indicado no atributo action do <form>
        ↓
[5] Servidor recebe os dados, executa a lógica de negócio e gera uma resposta
        ↓
[6] Navegador recebe a resposta e exibe o resultado ao usuário
```

Este fluxo é idêntico ao ciclo de requisição-resposta HTTP estudado no Capítulo 1 — a diferença é que, em vez de simplesmente solicitar um recurso, o navegador está *enviando dados* junto com a requisição.

> **Ponto crítico:** toda validação realizada no navegador via HTML (atributos `required`, `pattern`, etc.) ou via JavaScript pode ser **contornada** por um usuário técnico. Por essa razão, a validação no frontend é uma conveniência para o usuário — nunca uma medida de segurança. **A validação definitiva sempre deve ocorrer no servidor (backend)**. Este princípio será aprofundado nos capítulos de back-end e segurança.

---

## 5.2 — Estrutura básica: `<form>`, `action` e `method`

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O elemento `<form>` é o contêiner que delimita um formulário HTML. Ele possui dois atributos fundamentais que determinam *para onde* e *como* os dados serão enviados:

```html
<form action="/cadastro" method="post">
  <!-- campos do formulário -->
</form>
```

### 5.2.1 — O atributo `action`

O atributo `action` especifica a **URL de destino** para a qual os dados do formulário serão enviados quando o usuário submeter o formulário. Pode ser uma URL absoluta ou relativa:

```html
<!-- URL relativa: envia para /login no mesmo servidor -->
<form action="/login" method="post">...</form>

<!-- URL absoluta: envia para um servidor externo -->
<form action="https://api.exemplo.com/contato" method="post">...</form>

<!-- Sem action: envia para a própria página atual -->
<form method="get">...</form>
```

Quando `action` é omitido, o formulário é enviado para a URL da página atual — comportamento útil em páginas que processam o próprio formulário no servidor.

### 5.2.2 — O atributo `method`: GET vs POST

O atributo `method` define o **método HTTP** utilizado para enviar os dados. Os dois valores possíveis são `get` e `post`, e a escolha entre eles tem implicações técnicas, semânticas e de segurança significativas.

**`method="get"` — dados na URL**

Com o método GET, os dados do formulário são codificados na **query string** da URL, visíveis na barra de endereços do navegador:

```html
<form action="https://httpbin.org/get" method="get">
  <label for="busca">Buscar:</label>
  <input type="text" id="busca" name="q" />
  <button type="submit">Buscar</button>
</form>
```

Após o envio com o valor "HTML semântico", a URL resultante seria:

```
https://httpbin.org/get?q=HTML+sem%C3%A2ntico
```

Os dados aparecem após o `?` na forma de pares `nome=valor`, separados por `&` quando há múltiplos campos.

**`method="post"` — dados no corpo da requisição**

Com o método POST, os dados são enviados no **corpo (*body*) da requisição HTTP**, invisíveis na URL:

```html
<form action="https://httpbin.org/post" method="post">
  <label for="email">E-mail:</label>
  <input type="email" id="email" name="email" />

  <label for="senha">Senha:</label>
  <input type="password" id="senha" name="senha" />

  <button type="submit">Entrar</button>
</form>
```

Após o envio, a URL permanece `https://httpbin.org/post` — sem nenhum dado exposto.

**Comparativo GET vs POST**

| Critério | GET | POST |
|---|---|---|
| Dados na URL | ✅ Sim | ❌ Não |
| Histórico do navegador | Dados ficam no histórico | Dados não ficam no histórico |
| Bookmarkável | ✅ Sim | ❌ Não |
| Limite de dados | ~2.000 caracteres (varia por navegador/servidor) | Sem limite prático |
| Cache | Pode ser cacheado | Não é cacheado por padrão |
| Idempotência | Idempotente (repetir não muda estado) | Não idempotente |
| Uso adequado | Buscas, filtros, navegação | Login, cadastro, envio de arquivos, pagamentos |

> **⚠️ Alerta de segurança:** nunca use `method="get"` para formulários que transmitem dados sensíveis — senhas, tokens, dados pessoais, informações financeiras. Com GET, esses dados aparecem na URL, ficam armazenados no histórico do navegador e nos logs do servidor, e podem ser expostos no cabeçalho HTTP `Referer` ao navegar para outra página.

### 5.2.3 — Testando o envio com httpbin.org

O serviço **httpbin.org** é uma ferramenta gratuita que recebe requisições HTTP e retorna seus dados em formato JSON — ideal para inspecionar exatamente o que um formulário está enviando durante o desenvolvimento:

```html
<!-- Teste com GET: observe os dados na URL e no JSON retornado -->
<form action="https://httpbin.org/get" method="get">
  <input type="text" name="usuario" placeholder="Seu nome" />
  <input type="email" name="email" placeholder="Seu e-mail" />
  <button type="submit">Testar GET</button>
</form>

<!-- Teste com POST: observe os dados no corpo JSON retornado -->
<form action="https://httpbin.org/post" method="post">
  <input type="text" name="usuario" placeholder="Seu nome" />
  <input type="email" name="email" placeholder="Seu e-mail" />
  <button type="submit">Testar POST</button>
</form>
```

Ao submeter esses formulários, o httpbin retorna uma resposta JSON que exibe exatamente quais dados foram recebidos — incluindo cabeçalhos, método, IP de origem e os parâmetros enviados. É uma forma concreta de visualizar a diferença entre GET e POST sem necessidade de um backend próprio.

> **Acesse:** [https://httpbin.org](https://httpbin.org)

---

## 5.3 — Campos de entrada: `<input>` e seus tipos fundamentais

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O elemento `<input>` é o componente mais versátil dos formulários HTML. Seu comportamento é inteiramente determinado pelo atributo `type` — que define não apenas a aparência do campo, mas também o teclado virtual exibido em dispositivos móveis, as restrições de entrada aceitas e o comportamento de validação nativa do navegador.

### 5.3.1 — Os atributos `name` e `id`: distinção fundamental

Antes de explorar os tipos de `<input>`, é essencial compreender a diferença entre dois atributos que frequentemente causam confusão em iniciantes: `name` e `id`.

**`name` — identidade para envio de dados**

O atributo `name` define o **identificador do campo nos dados enviados ao servidor**. Quando o formulário é submetido, o navegador monta pares `nome=valor` para cada campo — e o "nome" é exatamente o valor do atributo `name`.

> **⚠️ Erro muito comum:** campos sem o atributo `name` **não são enviados** ao servidor. Um campo pode estar visível, preenchido e validado — mas se não tiver `name`, seus dados simplesmente não chegam ao backend. Este é um dos erros mais frequentes em formulários criados por iniciantes.

```html
<!-- Este campo SERÁ enviado: tem name -->
<input type="text" name="usuario" id="campo-usuario" />

<!-- Este campo NÃO será enviado: não tem name -->
<input type="text" id="campo-teste" />
```

**`id` — identidade no documento HTML**

O atributo `id` identifica o elemento de forma única no **documento HTML**. Ele é utilizado para: associar um `<label>` ao campo (via `for`), referenciar o campo via CSS (seletores `#id`) e manipular o campo via JavaScript (`document.getElementById`). O `id` não tem nenhuma influência sobre o envio de dados.

**Resumo prático:**

| Atributo | Para que serve | Obrigatório para envio? |
|---|---|---|
| `name` | Identificar o dado no servidor | ✅ Sim |
| `id` | Identificar o elemento no documento | ❌ Não (mas recomendado para acessibilidade) |

Na prática, ambos são geralmente declarados e, por convenção, recebem o mesmo valor — mas são conceitualmente independentes:

```html
<input type="text" name="email" id="email" />
```

### 5.3.2 — Tipos fundamentais de `<input>`

**`type="text"` — texto livre**

```html
<label for="nome">Nome completo:</label>
<input
  type="text"
  id="nome"
  name="nome"
  placeholder="Ex.: Maria Silva"
  autocomplete="name"
/>
```

**`type="email"` — endereço de e-mail**

O navegador valida automaticamente o formato básico de e-mail (presença de `@` e domínio):

```html
<label for="email">E-mail:</label>
<input
  type="email"
  id="email"
  name="email"
  placeholder="usuario@dominio.com"
  autocomplete="email"
/>
```

**`type="password"` — senha**

O valor digitado é ocultado visualmente. O dado é enviado em texto simples pelo HTML — a criptografia da transmissão é responsabilidade do protocolo HTTPS, não do formulário:

```html
<label for="senha">Senha:</label>
<input
  type="password"
  id="senha"
  name="senha"
  minlength="8"
  autocomplete="current-password"
/>
```

**`type="number"` — valor numérico**

```html
<label for="idade">Idade:</label>
<input
  type="number"
  id="idade"
  name="idade"
  min="18"
  max="120"
  step="1"
/>
```

**`type="checkbox"` — múltiplas escolhas independentes**

Checkboxes representam opções **independentes entre si** — o usuário pode marcar zero, uma ou várias. Cada checkbox envia seu valor apenas quando marcado; quando desmarcado, o campo não é enviado.

```html
<!-- Cada checkbox tem name diferente: são dados independentes -->
<fieldset>
  <legend>Tecnologias que você conhece:</legend>

  <label>
    <input type="checkbox" name="html" value="sim" /> HTML
  </label>
  <label>
    <input type="checkbox" name="css" value="sim" /> CSS
  </label>
  <label>
    <input type="checkbox" name="javascript" value="sim" /> JavaScript
  </label>
</fieldset>
```

Para enviar múltiplos valores sob o mesmo nome (como um array), todos os checkboxes de um grupo recebem o mesmo `name` com colchetes:

```html
<!-- Todos com o mesmo name: enviados como array no backend -->
<input type="checkbox" name="tecnologias[]" value="html" /> HTML
<input type="checkbox" name="tecnologias[]" value="css" /> CSS
<input type="checkbox" name="tecnologias[]" value="js" /> JavaScript
```

**`type="radio"` — escolha exclusiva**

Radio buttons representam opções **mutuamente exclusivas** — o usuário deve escolher exatamente uma. O agrupamento é definido pelo atributo `name`: todos os radio buttons com o mesmo `name` pertencem ao mesmo grupo, e apenas um pode estar selecionado por vez.

```html
<fieldset>
  <legend>Período de preferência:</legend>

  <!-- Mesmo name = mesmo grupo = escolha exclusiva -->
  <label>
    <input type="radio" name="periodo" value="manha" /> Manhã
  </label>
  <label>
    <input type="radio" name="periodo" value="tarde" /> Tarde
  </label>
  <label>
    <input type="radio" name="periodo" value="noite" /> Noite
  </label>
</fieldset>
```

**Diferença prática entre checkbox e radio:**

| | `checkbox` | `radio` |
|---|---|---|
| Quantas opções o usuário pode escolher | Zero ou mais | Exatamente uma |
| Agrupamento | Por convenção (mesmo `name[]`) | Por `name` (obrigatório) |
| Valor enviado quando não marcado | Nenhum | Nenhum |
| Caso de uso | "Quais linguagens você conhece?" | "Qual seu período preferido?" |

**`type="submit"` — botão de envio**

```html
<input type="submit" value="Enviar formulário" />
```

Na prática, o elemento `<button type="submit">` é mais flexível e preferível, pois aceita conteúdo HTML interno (como ícones):

```html
<button type="submit">Enviar formulário</button>
```

> **⚠️ Alerta:** um elemento `<button>` sem o atributo `type` explícito é tratado como `type="submit"` por padrão — e submeterá o formulário ao ser clicado, mesmo que o desenvolvedor não tenha essa intenção. Sempre declare o `type` explicitamente em botões dentro de formulários:
>
> ```html
> <button type="submit">Enviar</button>   <!-- envia o formulário -->
> <button type="button">Cancelar</button> <!-- não envia nada -->
> <button type="reset">Limpar</button>    <!-- limpa os campos -->
> ```

---

## 5.4 — Tipos de input menos conhecidos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Além dos tipos fundamentais, o HTML5 introduziu uma série de tipos de `<input>` especializados que oferecem interfaces nativas do sistema operacional — seletores de data, sliders, paletas de cor — sem necessidade de JavaScript. A adoção desses tipos melhora significativamente a experiência do usuário, especialmente em dispositivos móveis, onde o navegador exibe teclados virtuais otimizados para cada tipo de dado.

> **⚠️ Compatibilidade:** o suporte a tipos de input avançados varia entre navegadores e sistemas operacionais. Em navegadores que não reconhecem um `type` específico, o campo é renderizado como `type="text"` — o que garante degradação graceful (o campo ainda funciona, mas sem a interface especializada). Antes de usar esses tipos em produção, verifique o suporte atual em [https://caniuse.com](https://caniuse.com).

### 5.4.1 — Data e hora

```html
<!-- Data (ano-mês-dia) -->
<label for="nascimento">Data de nascimento:</label>
<input
  type="date"
  id="nascimento"
  name="nascimento"
  min="1900-01-01"
  max="2010-12-31"
/>

<!-- Hora (horas:minutos) -->
<label for="horario">Horário preferido:</label>
<input type="time" id="horario" name="horario" min="08:00" max="22:00" />

<!-- Data e hora local (sem fuso horário) -->
<label for="agendamento">Agendamento:</label>
<input type="datetime-local" id="agendamento" name="agendamento" />

<!-- Mês e ano -->
<label for="competencia">Competência:</label>
<input type="month" id="competencia" name="competencia" />

<!-- Semana do ano -->
<label for="semana">Semana de início:</label>
<input type="week" id="semana" name="semana" />
```

O valor enviado ao servidor segue o formato **ISO 8601** (ex.: `2026-03-20` para datas, `14:30` para horas) — independentemente do formato visual exibido ao usuário, que varia conforme as configurações de locale do sistema operacional.

> **Nota de compatibilidade:** `type="date"` tem suporte amplo em navegadores modernos, mas a aparência do seletor varia significativamente entre plataformas. Em Safari iOS, o seletor usa rodas giratórias; no Chrome Android, usa um calendário visual. Para projetos que exigem aparência consistente entre plataformas, bibliotecas JavaScript de date picker são frequentemente preferidas.

### 5.4.2 — Intervalo numérico: `type="range"`

Renderiza um controle deslizante (*slider*) para seleção de valores numéricos em um intervalo:

```html
<label for="volume">Volume: <span id="valor-volume">50</span>%</label>
<input
  type="range"
  id="volume"
  name="volume"
  min="0"
  max="100"
  step="5"
  value="50"
/>
```

O `type="range"` não exibe o valor atual por padrão — é necessário JavaScript para atualizar um elemento de texto em tempo real. O valor enviado é numérico.

### 5.4.3 — Cor: `type="color"`

Abre o seletor de cores nativo do sistema operacional:

```html
<label for="cor-tema">Cor do tema:</label>
<input
  type="color"
  id="cor-tema"
  name="cor_tema"
  value="#E8632A"
/>
```

O valor enviado ao servidor é sempre um código hexadecimal de 6 dígitos em minúsculas (ex.: `#e8632a`).

> **Nota de compatibilidade:** o seletor de cor nativo varia significativamente entre sistemas operacionais — macOS, Windows e Android exibem interfaces completamente diferentes. O atributo `value` deve ser sempre um código hexadecimal de 6 dígitos; valores como `rgb()` ou nomes de cor não são aceitos.

### 5.4.4 — Upload de arquivo: `type="file"`

Permite que o usuário selecione um ou mais arquivos do dispositivo para envio:

```html
<!-- Arquivo único -->
<label for="curriculo">Currículo (PDF):</label>
<input
  type="file"
  id="curriculo"
  name="curriculo"
  accept=".pdf"
/>

<!-- Múltiplos arquivos -->
<label for="fotos">Fotos do projeto:</label>
<input
  type="file"
  id="fotos"
  name="fotos[]"
  accept="image/jpeg, image/png, image/webp"
  multiple
/>
```

> **⚠️ Atenção técnica:** formulários com `type="file"` **obrigatoriamente** requerem `method="post"` e o atributo `enctype="multipart/form-data"` no elemento `<form>`. Sem essas configurações, o arquivo não é enviado corretamente — apenas o nome do arquivo é transmitido.
>
> ```html
> <form action="/upload" method="post" enctype="multipart/form-data">
>   <input type="file" name="arquivo" />
>   <button type="submit">Enviar arquivo</button>
> </form>
> ```

### 5.4.5 — Outros tipos úteis

```html
<!-- Busca: semântica de campo de pesquisa (pode exibir botão de limpar) -->
<input type="search" name="q" placeholder="Buscar..." />

<!-- Telefone: exibe teclado numérico em dispositivos móveis -->
<input type="tel" name="telefone" placeholder="(82) 99999-9999" />

<!-- URL: valida formato de endereço web -->
<input type="url" name="website" placeholder="https://www.exemplo.com" />

<!-- Campo oculto: envia dados sem exibição ao usuário -->
<!-- Uso comum: tokens CSRF, IDs de sessão, dados de contexto -->
<input type="hidden" name="csrf_token" value="abc123xyz" />
```

---

## 5.5 — Elementos de formulário complementares

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 5.5.1 — `<textarea>`: texto multilinha

O elemento `<textarea>` cria um campo de texto de múltiplas linhas, adequado para mensagens, descrições e comentários. Diferentemente de `<input>`, ele possui tag de abertura e fechamento, e seu valor padrão é definido pelo conteúdo entre as tags:

```html
<label for="mensagem">Mensagem:</label>
<textarea
  id="mensagem"
  name="mensagem"
  rows="5"
  cols="50"
  maxlength="500"
  placeholder="Descreva sua dúvida com detalhes..."
></textarea>
```

Os atributos `rows` e `cols` definem o tamanho inicial em linhas e caracteres, respectivamente — mas o usuário pode redimensionar o campo em navegadores que o permitem. O controle preciso do tamanho deve ser feito via CSS (propriedade `resize`).

### 5.5.2 — `<select>`: lista de opções

O elemento `<select>` cria uma lista suspensa (*dropdown*) de opções. Cada opção é definida por um elemento `<option>`:

```html
<label for="curso">Curso:</label>
<select id="curso" name="curso">
  <!-- O primeiro option como placeholder -->
  <option value="">Selecione um curso...</option>
  <option value="si">Sistemas de Informação</option>
  <option value="cc">Ciência da Computação</option>
  <option value="ec">Engenharia da Computação</option>
</select>
```

> **Boa prática:** sempre inclua um `<option value="">` vazio como primeiro item, funcionando como placeholder. Isso evita que a primeira opção real seja selecionada por padrão sem que o usuário tenha feito uma escolha consciente.

O atributo `value` do `<option>` define o dado enviado ao servidor — que pode ser diferente do texto exibido ao usuário. Se `value` for omitido, o texto exibido é enviado como valor.

**Agrupando opções com `<optgroup>`**

Para listas longas, `<optgroup>` organiza as opções em grupos visuais rotulados:

```html
<label for="linguagem">Linguagem de programação:</label>
<select id="linguagem" name="linguagem">
  <option value="">Selecione...</option>

  <optgroup label="Frontend">
    <option value="html">HTML</option>
    <option value="css">CSS</option>
    <option value="js">JavaScript</option>
  </optgroup>

  <optgroup label="Backend">
    <option value="python">Python</option>
    <option value="nodejs">Node.js</option>
    <option value="php">PHP</option>
  </optgroup>
</select>
```

**Seleção múltipla**

O atributo `multiple` transforma o `<select>` em uma lista de seleção múltipla. O usuário deve usar `Ctrl` (ou `Cmd`) para selecionar mais de uma opção:

```html
<label for="interesses">Áreas de interesse (selecione uma ou mais):</label>
<select id="interesses" name="interesses[]" multiple size="4">
  <option value="web">Desenvolvimento Web</option>
  <option value="dados">Ciência de Dados</option>
  <option value="infra">Infraestrutura e DevOps</option>
  <option value="seguranca">Segurança da Informação</option>
</select>
```

### 5.5.3 — `<datalist>`: sugestões automáticas

O elemento `<datalist>` oferece uma lista de sugestões para um campo de texto, sem restringir o usuário a apenas essas opções — ao contrário do `<select>`, que limita as escolhas disponíveis:

```html
<label for="cidade">Cidade:</label>
<input
  type="text"
  id="cidade"
  name="cidade"
  list="sugestoes-cidade"
  placeholder="Digite sua cidade..."
/>
<datalist id="sugestoes-cidade">
  <option value="Maceió" />
  <option value="Arapiraca" />
  <option value="Palmeira dos Índios" />
  <option value="União dos Palmares" />
  <option value="Penedo" />
</datalist>
```

A associação entre o `<input>` e o `<datalist>` é feita pelo atributo `list` do input, cujo valor deve corresponder ao `id` do `<datalist>`.

---

## 5.6 — Formulários acessíveis

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Formulários são componentes de interface que exigem atenção especial à acessibilidade: o usuário precisa compreender o que cada campo solicita, receber feedback quando comete erros e ser capaz de navegar pelo formulário inteiramente via teclado. As fundações da acessibilidade em formulários são alcançadas com elementos e atributos HTML nativos — sem necessidade de ARIA na maioria dos casos.

### 5.6.1 — `<label>`: associando rótulos a campos

O elemento `<label>` é o mecanismo fundamental de acessibilidade em formulários. Ele associa um rótulo textual a um campo, tornando claro para o usuário — e para tecnologias assistivas — o que aquele campo solicita.

Existem duas formas de associar um `<label>` a um campo:

**Associação explícita (recomendada):** via atributo `for` no `<label>` referenciando o `id` do campo:

```html
<label for="nome">Nome completo:</label>
<input type="text" id="nome" name="nome" />
```

**Associação implícita:** envolvendo o campo dentro do `<label>`:

```html
<label>
  Nome completo:
  <input type="text" name="nome" />
</label>
```

Ambas as formas são válidas. A associação explícita é preferida quando o layout visual separa o rótulo do campo.

**Por que `<label>` é indispensável:**

- Leitores de tela anunciam o rótulo ao focar o campo — sem ele, o usuário ouve apenas "campo de texto" sem saber o que preencher
- Clicar no `<label>` move o foco para o campo associado — ampliando a área clicável, o que beneficia usuários com dificuldades motoras
- O WCAG 2.1 exige que todos os campos de formulário tenham um rótulo programaticamente associado (critério 1.3.1, nível A)

> **⚠️ Erro comum:** usar `placeholder` como substituto de `<label>`. O `placeholder` desaparece quando o usuário começa a digitar, o que dificulta a revisão do formulário preenchido. `placeholder` deve ser usado apenas como exemplo do formato esperado, nunca como rótulo principal do campo.

### 5.6.2 — `<fieldset>` e `<legend>`: agrupando campos relacionados

O elemento `<fieldset>` agrupa semanticamente campos relacionados de um formulário, e `<legend>` fornece um título para esse grupo. São especialmente importantes para grupos de radio buttons e checkboxes, onde o `<legend>` fornece o contexto da pergunta:

```html
<form action="/matricula" method="post">

  <fieldset>
    <legend>Dados pessoais</legend>

    <label for="nome">Nome completo:</label>
    <input type="text" id="nome" name="nome" required />

    <label for="cpf">CPF:</label>
    <input type="text" id="cpf" name="cpf" pattern="\d{3}\.\d{3}\.\d{3}-\d{2}" />
  </fieldset>

  <fieldset>
    <legend>Período de preferência:</legend>

    <label>
      <input type="radio" name="periodo" value="manha" /> Manhã
    </label>
    <label>
      <input type="radio" name="periodo" value="tarde" /> Tarde
    </label>
    <label>
      <input type="radio" name="periodo" value="noite" /> Noite
    </label>
  </fieldset>

  <button type="submit">Enviar matrícula</button>
</form>
```

Quando um leitor de tela foca um radio button, ele anuncia: "Manhã, botão de opção, 1 de 3 — Período de preferência". O `<legend>` fornece o contexto "Período de preferência", sem o qual o usuário ouvia apenas "Manhã" sem saber a qual pergunta a opção pertence.

### 5.6.3 — ARIA em formulários: uso avançado

Os atributos ARIA são utilizados em formulários para situações que os elementos HTML nativos não cobrem diretamente — como mensagens de erro dinâmicas, descrições adicionais e estados de validação. O princípio fundamental é: **use elementos HTML nativos primeiro; recorra ao ARIA apenas quando não há elemento semântico adequado**.

Os atributos ARIA mais comuns em formulários:

```html
<!-- aria-required: indica campo obrigatório (equivalente semântico ao required) -->
<input type="text" name="nome" aria-required="true" />

<!-- aria-describedby: associa uma descrição adicional ao campo -->
<label for="senha">Senha:</label>
<input
  type="password"
  id="senha"
  name="senha"
  aria-describedby="dica-senha"
/>
<p id="dica-senha">A senha deve ter no mínimo 8 caracteres, incluindo letras e números.</p>

<!-- aria-invalid: indica que o campo contém um valor inválido
     (normalmente definido via JavaScript após validação) -->
<input
  type="email"
  name="email"
  aria-invalid="true"
  aria-describedby="erro-email"
/>
<p id="erro-email" role="alert">Por favor, informe um e-mail válido.</p>
```

> **Referência:** [MDN — Formulários HTML: Validação de dados de formulário](https://developer.mozilla.org/pt-BR/docs/Learn/Forms/Form_validation)

---

## 5.7 — Validação nativa do navegador

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O HTML5 introduziu um conjunto de atributos que habilitam a **validação nativa do navegador** — verificação dos dados diretamente no cliente, antes do envio ao servidor. Essa funcionalidade melhora a experiência do usuário ao fornecer feedback imediato, sem necessidade de JavaScript ou de uma viagem ao servidor.

> **⚠️ Princípio fundamental:** a validação nativa do navegador é uma conveniência para o usuário — **não é uma medida de segurança**. Qualquer usuário com conhecimento técnico pode desabilitar a validação do navegador, modificar o HTML via DevTools ou enviar requisições HTTP diretamente sem usar o formulário. **A validação definitiva deve sempre ser implementada no backend.** Validações mais complexas no frontend (máscaras, verificação em tempo real, formatação automática) serão abordadas nos capítulos de JavaScript.

### 5.7.1 — O atributo `required`

Impede o envio do formulário quando o campo está vazio:

```html
<label for="nome">Nome completo: *</label>
<input type="text" id="nome" name="nome" required />
```

### 5.7.2 — Restrições de comprimento: `minlength` e `maxlength`

```html
<label for="bio">Biografia:</label>
<textarea
  id="bio"
  name="bio"
  minlength="50"
  maxlength="500"
  placeholder="Escreva entre 50 e 500 caracteres..."
></textarea>
```

### 5.7.3 — Restrições numéricas: `min`, `max` e `step`

```html
<label for="nota">Nota (0 a 10):</label>
<input
  type="number"
  id="nota"
  name="nota"
  min="0"
  max="10"
  step="0.5"
/>
```

### 5.7.4 — Validação por padrão: `pattern`

O atributo `pattern` aceita uma **expressão regular** que o valor do campo deve satisfazer. É a forma mais poderosa de validação nativa, permitindo definir formatos específicos:

```html
<!-- CEP no formato 00000-000 -->
<label for="cep">CEP:</label>
<input
  type="text"
  id="cep"
  name="cep"
  pattern="\d{5}-\d{3}"
  placeholder="00000-000"
  title="CEP no formato 00000-000"
/>

<!-- Placa de veículo: formato antigo (ABC-1234) ou Mercosul (ABC1D23) -->
<label for="placa">Placa do veículo:</label>
<input
  type="text"
  id="placa"
  name="placa"
  pattern="[A-Z]{3}-?\d{4}|[A-Z]{3}\d[A-Z]\d{2}"
  title="Placa no formato ABC-1234 ou ABC1D23"
/>

<!-- Senha: mínimo 8 caracteres, ao menos uma letra e um número -->
<label for="nova-senha">Nova senha:</label>
<input
  type="password"
  id="nova-senha"
  name="nova_senha"
  pattern="(?=.*[A-Za-z])(?=.*\d).{8,}"
  title="Mínimo de 8 caracteres, incluindo ao menos uma letra e um número"
/>
```

O atributo `title` fornece a mensagem de erro exibida pelo navegador quando o padrão não é satisfeito — tornando o feedback compreensível para o usuário.

### 5.7.5 — Validação implícita por `type`

Muitos tipos de `<input>` realizam validação implícita sem atributos adicionais:

| Tipo | Validação implícita |
|---|---|
| `email` | Verifica presença de `@` e formato básico |
| `url` | Verifica formato de URL (protocolo + domínio) |
| `number` | Aceita apenas valores numéricos |
| `date` | Aceita apenas datas válidas no formato do sistema |
| `tel` | Sem validação de formato (formatos variam por país) |

### 5.7.6 — Desabilitando a validação nativa

Em alguns cenários — como quando se implementa validação customizada via JavaScript — pode ser necessário desabilitar a validação nativa com o atributo booleano `novalidate` no elemento `<form>`:

```html
<form action="/cadastro" method="post" novalidate>
  <!-- Validação gerenciada inteiramente por JavaScript -->
</form>
```

---

## 5.8 — Formulário completo: exemplo integrado

A seguir, um formulário de contato que integra todos os conceitos abordados neste capítulo — estrutura semântica, acessibilidade, tipos de campos, validação nativa e boas práticas:

```html
<form action="/contato" method="post" novalidate>

  <fieldset>
    <legend>Dados de identificação</legend>

    <div class="campo">
      <label for="nome">Nome completo: <span aria-hidden="true">*</span></label>
      <input
        type="text"
        id="nome"
        name="nome"
        required
        minlength="3"
        maxlength="100"
        autocomplete="name"
        aria-required="true"
      />
    </div>

    <div class="campo">
      <label for="email">E-mail: <span aria-hidden="true">*</span></label>
      <input
        type="email"
        id="email"
        name="email"
        required
        autocomplete="email"
        aria-required="true"
        aria-describedby="dica-email"
      />
      <small id="dica-email">Utilizaremos este e-mail apenas para responder sua mensagem.</small>
    </div>

    <div class="campo">
      <label for="telefone">Telefone:</label>
      <input
        type="tel"
        id="telefone"
        name="telefone"
        pattern="\(\d{2}\)\s\d{4,5}-\d{4}"
        placeholder="(82) 99999-9999"
        title="Telefone no formato (DDD) NNNNN-NNNN"
        autocomplete="tel"
      />
    </div>
  </fieldset>

  <fieldset>
    <legend>Assunto da mensagem</legend>

    <div class="campo">
      <label for="tipo">Tipo de solicitação: <span aria-hidden="true">*</span></label>
      <select id="tipo" name="tipo" required aria-required="true">
        <option value="">Selecione...</option>
        <option value="duvida">Dúvida sobre o curso</option>
        <option value="sugestao">Sugestão</option>
        <option value="problema">Relato de problema</option>
        <option value="outro">Outro assunto</option>
      </select>
    </div>

    <div class="campo">
      <label for="mensagem">Mensagem: <span aria-hidden="true">*</span></label>
      <textarea
        id="mensagem"
        name="mensagem"
        required
        minlength="20"
        maxlength="1000"
        rows="6"
        aria-required="true"
        placeholder="Descreva sua solicitação com detalhes..."
      ></textarea>
    </div>
  </fieldset>

  <fieldset>
    <legend>Como prefere ser contatado?</legend>

    <label>
      <input type="radio" name="contato" value="email" checked />
      Por e-mail
    </label>
    <label>
      <input type="radio" name="contato" value="telefone" />
      Por telefone
    </label>
  </fieldset>

  <div class="campo">
    <label>
      <input type="checkbox" name="aceite" value="sim" required />
      Li e aceito os <a href="/termos">termos de uso</a>
    </label>
  </div>

  <!-- Campo oculto: dado de contexto enviado automaticamente -->
  <input type="hidden" name="origem" value="pagina-contato" />

  <div class="acoes">
    <button type="reset">Limpar formulário</button>
    <button type="submit">Enviar mensagem</button>
  </div>

</form>
```

---

## 5.9 — Boas práticas em formulários HTML

Um formulário tecnicamente correto não é necessariamente um formulário bem projetado. As boas práticas a seguir reúnem os princípios de usabilidade, acessibilidade e integridade de dados mais relevantes para o desenvolvimento de formulários na Web:

**Sempre declare `name` em campos que devem ser enviados.** Campos sem `name` são silenciosamente ignorados pelo navegador — um dos erros mais difíceis de diagnosticar em formulários.

**Sempre use `<label>` associado a cada campo.** `placeholder` não é um substituto de `<label>` — ele desaparece quando o usuário começa a digitar e não é anunciado de forma consistente por leitores de tela.

**Declare `type` explicitamente em todos os `<button>`.** O padrão `type="submit"` de um `<button>` sem `type` causa envios acidentais de formulário com frequência.

**Agrupe campos relacionados com `<fieldset>` e `<legend>`.** Isso é especialmente importante para grupos de radio buttons e checkboxes, onde o `<legend>` fornece o contexto da pergunta.

**Use o método HTTP correto.** `GET` para buscas e filtros (os parâmetros na URL são desejáveis); `POST` para ações que modificam estado no servidor (cadastros, logins, envios de mensagem). Nunca use `GET` para dados sensíveis.

**Informe o usuário sobre campos obrigatórios.** A convenção `*` é amplamente reconhecida, mas deve ser acompanhada de uma nota como "* campos obrigatórios" no início ou no final do formulário.

**Forneça mensagens de erro claras.** O atributo `title` em conjunto com `pattern` melhora as mensagens de erro nativas do navegador. Mensagens genéricas como "Valor inválido" são inadequadas — informe o formato esperado.

**Nunca confie apenas na validação do frontend.** Toda validação HTML e JavaScript pode ser contornada. A validação definitiva ocorre no servidor.

**Prefira `autocomplete` adequado.** O atributo `autocomplete` com valores semânticos corretos (`name`, `email`, `tel`, `current-password`, etc.) melhora a experiência do usuário e é reconhecido por gerenciadores de senha.

**Referências:**
- [MDN — Guia de formulários HTML](https://developer.mozilla.org/pt-BR/docs/Learn/Forms)
- [WebAIM — Creating Accessible Forms](https://webaim.org/techniques/forms/)
- [W3C — Web Accessibility Tutorials: Forms](https://www.w3.org/WAI/tutorials/forms/)
- [WHATWG — The form element](https://html.spec.whatwg.org/multipage/forms.html)

---

#### **Atividades — Capítulo 5**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Um formulário tem um campo <code>&lt;input type="text" id="usuario"&gt;</code> sem o atributo <code>name</code>. O que ocorre quando o formulário é enviado?</p>
  <button data-option="a">O navegador usa o valor do <code>id</code> como <code>name</code> automaticamente.</button>
  <button data-option="b">O campo é ignorado — seus dados não são incluídos na requisição enviada ao servidor.</button>
  <button data-option="c">O navegador exibe um erro de validação impedindo o envio.</button>
  <button data-option="d">O campo é enviado com o valor <code>name=""</code>.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Qual é a diferença fundamental entre <code>type="checkbox"</code> e <code>type="radio"</code>?</p>
  <button data-option="a">Checkboxes enviam valores booleanos; radio buttons enviam strings.</button>
  <button data-option="b">Radio buttons permitem múltiplas seleções; checkboxes permitem apenas uma.</button>
  <button data-option="c">Checkboxes permitem zero ou mais seleções independentes; radio buttons com o mesmo <code>name</code> formam um grupo de escolha exclusiva — apenas um pode estar selecionado.</button>
  <button data-option="d">Não há diferença funcional; a escolha é apenas estética.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Por que a validação nativa do navegador (atributos <code>required</code>, <code>pattern</code>, etc.) não substitui a validação no servidor?</p>
  <button data-option="a">Porque a validação do navegador só funciona em Chrome e Firefox.</button>
  <button data-option="b">Porque o HTML5 não suporta expressões regulares complexas no atributo <code>pattern</code>.</button>
  <button data-option="c">Porque a validação do navegador só é executada quando o usuário está online.</button>
  <button data-option="d">Porque qualquer usuário técnico pode desabilitar a validação do navegador, modificar o HTML via DevTools ou enviar requisições HTTP diretamente — contornando inteiramente o formulário.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> Um <code>&lt;button&gt;</code> sem o atributo <code>type</code> está dentro de um <code>&lt;form&gt;</code>. O que acontece quando ele é clicado?</p>
  <button data-option="a">O formulário é submetido, pois o valor padrão de <code>type</code> em um <code>&lt;button&gt;</code> dentro de um formulário é <code>submit</code>.</button>
  <button data-option="b">Nada acontece, pois sem <code>type</code> o botão não tem comportamento definido.</button>
  <button data-option="c">O formulário é limpo, como se fosse <code>type="reset"</code>.</button>
  <button data-option="d">O navegador exibe um aviso solicitando a declaração explícita do <code>type</code>.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir um formulário de matrícula com: `<fieldset>` e `<legend>` para agrupamento, ao menos um campo de cada tipo (`text`, `email`, `select`, `radio`, `checkbox`, `textarea`), todos com `name`, `id` e `<label>` associado, validação nativa com `required` e `pattern`, e envio para `https://httpbin.org/post` para inspeção da requisição. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 4 — Tabelas, Listas e Mídia](04-tabelas-listas-midia.md)
[:material-arrow-right: Ir ao Capítulo 6 — Introdução à Acessibilidade Web](06-acessibilidade.md)
