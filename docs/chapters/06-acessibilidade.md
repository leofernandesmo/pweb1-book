# Capítulo 6 — Introdução à Acessibilidade Web

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 6.1 — O que é acessibilidade web e por que importa

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A **acessibilidade web** é a prática de projetar e desenvolver páginas e aplicações que possam ser percebidas, compreendidas, navegadas e utilizadas por **todas as pessoas** — independentemente de suas capacidades físicas, sensoriais, cognitivas ou tecnológicas. Isso inclui pessoas com deficiência visual, auditiva, motora ou cognitiva, mas também pessoas em situações temporárias (um braço imobilizado, um ambiente com muito ruído) ou contextuais (conexão lenta, tela pequena, luz solar intensa).

Uma forma precisa de compreender acessibilidade é pela definição do **W3C** (*World Wide Web Consortium*): a Web acessível é aquela em que pessoas com deficiência podem perceber, compreender, navegar, interagir e contribuir de forma equivalente às demais.

O termo **equivalente** é deliberado. Acessibilidade não significa oferecer uma experiência inferior ou simplificada para determinados grupos — significa garantir que a experiência seja funcionalmente equivalente para todos, ainda que os meios de acesso sejam diferentes.

### 6.1.1 — Quem se beneficia

É tentador imaginar acessibilidade como um conjunto de medidas destinadas a uma minoria específica. Essa percepção é equivocada por dois motivos.

Primeiro, o universo de pessoas beneficiadas é muito maior do que intuitivamente se imagina. Segundo dados da **Organização Mundial da Saúde (OMS)**, aproximadamente **1,3 bilhão de pessoas** — cerca de 16% da população mundial — vivem com alguma forma de deficiência significativa. No Brasil, o **Censo IBGE 2022** identificou que mais de **18,6 milhões de pessoas** declararam ter deficiência, o que representa aproximadamente 8,9% da população.

Segundo, muitos recursos desenvolvidos para acessibilidade beneficiam diretamente toda a população. Legendas em vídeos foram criadas para pessoas surdas, mas são amplamente utilizadas em ambientes barulhentos ou por pessoas aprendendo um idioma. O contraste elevado entre texto e fundo foi criado para pessoas com baixa visão, mas melhora a legibilidade para qualquer pessoa em condições de iluminação adversa. A navegação por teclado foi criada para pessoas com limitações motoras, mas é amplamente utilizada por desenvolvedores e usuários avançados. Este fenômeno é conhecido como **curb-cut effect** — uma analogia às rampas nas calçadas, criadas para cadeirantes mas utilizadas por ciclistas, pais com carrinhos de bebê e idosos.

### 6.1.2 — Contexto legal: a obrigação jurídica

No Brasil, a acessibilidade digital não é apenas uma boa prática — é uma **obrigação legal** para um conjunto crescente de organizações.

A **Lei Brasileira de Inclusão da Pessoa com Deficiência** (Lei nº 13.146/2015), conhecida como **Estatuto da Pessoa com Deficiência**, estabelece em seu artigo 63 que:

> "É obrigatória a acessibilidade nos sítios da internet mantidos por empresas com sede ou representação comercial no País ou por órgãos de governo, para uso da pessoa com deficiência."

O **Decreto nº 5.296/2004** e as normas da **ABNT NBR 15599** e **NBR 9050** regulamentam aspectos técnicos da acessibilidade em diferentes contextos, incluindo o digital.

Para órgãos públicos federais, o **e-MAG** (*Modelo de Acessibilidade em Governo Eletrônico*) define diretrizes específicas baseadas nas WCAG para portais governamentais brasileiros.

No cenário internacional, a **Seção 508** da legislação norte-americana e a **Diretiva de Acessibilidade Web da União Europeia (2016/2102)** estabelecem obrigações similares em seus respectivos contextos.

**Referências:**
- [Lei nº 13.146/2015 — Estatuto da Pessoa com Deficiência](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2015/lei/l13146.htm)
- [e-MAG — Modelo de Acessibilidade em Governo Eletrônico](https://emag.governoeletronico.gov.br/)
- [OMS — Disability and health](https://www.who.int/news-room/fact-sheets/detail/disability-and-health)

---

## 6.2 — Os quatro princípios WCAG: o modelo POUR

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

As **WCAG** (*Web Content Accessibility Guidelines*) são as diretrizes internacionais de acessibilidade para conteúdo web, publicadas e mantidas pelo W3C. A versão atual em uso amplo é a **WCAG 2.1**, publicada em 2018, com a **WCAG 2.2** publicada em 2023 introduzindo refinamentos adicionais.

As WCAG organizam seus critérios em torno de quatro princípios fundamentais, conhecidos pelo acrônimo **POUR**:

### 6.2.1 — Perceptível (*Perceivable*)

O conteúdo deve ser apresentado de forma que **todos os usuários possam percebê-lo** — independentemente do sentido utilizado. Informações que existem apenas em uma modalidade sensorial (apenas visual ou apenas auditiva) excluem automaticamente usuários que não têm acesso a essa modalidade.

**Exemplos práticos:**

- Imagens informativas devem ter texto alternativo (`alt`) descritivo — pessoas cegas usam leitores de tela que convertem o `alt` em áudio ou Braille
- Vídeos devem ter legendas — pessoas surdas dependem do texto para acessar o conteúdo auditivo
- O conteúdo não deve depender exclusivamente de cor para transmitir informação — pessoas com daltonismo podem não distinguir vermelho de verde
- O contraste entre texto e fundo deve ser suficiente — a WCAG 2.1 nível AA exige razão de contraste mínima de **4,5:1** para texto normal e **3:1** para texto grande

```html
<!-- Perceptível: imagem informativa com alt descritivo -->
<img
  src="grafico-vendas-2026.png"
  alt="Gráfico de barras mostrando crescimento de 40% nas vendas
       do 1º semestre de 2026 em relação ao mesmo período de 2025"
/>

<!-- Perceptível: não dependendo apenas de cor para transmitir erro -->
<!-- INCORRETO: apenas vermelho indica o erro -->
<input type="text" style="border: 2px solid red;" />

<!-- CORRETO: cor + ícone + texto comunicam o erro -->
<input type="text" aria-invalid="true" aria-describedby="erro-campo" />
<p id="erro-campo">⚠ Campo obrigatório — por favor, preencha este campo.</p>
```

### 6.2.2 — Operável (*Operable*)

A interface deve ser **operável por todos os usuários**, independentemente do dispositivo de entrada utilizado. Pessoas com limitações motoras podem não usar mouse — elas navegam com teclado, switches, rastreadores oculares ou voz.

**Exemplos práticos:**

- Toda funcionalidade deve ser acessível via teclado — navegação por `Tab`, ativação por `Enter`/`Espaço`, fechamento de modais por `Esc`
- O foco do teclado deve ser sempre visível — nunca remover o outline do foco via CSS sem fornecer uma alternativa visual
- Links e botões devem ter área clicável adequada — a WCAG 2.2 recomenda área mínima de 24×24 pixels
- Conteúdos com movimento ou animação automática devem ter mecanismo de pausa

```html
<!-- Operável: botão com foco visível e navegável por teclado -->
<button type="button" class="btn-primario">
  Salvar alterações
</button>

<!-- CSS: nunca faça isso -->
/* INCORRETO: remove completamente o indicador de foco */
button:focus { outline: none; }

/* CORRETO: substitui pelo indicador customizado com contraste adequado */
button:focus-visible {
  outline: 3px solid #0057B8;
  outline-offset: 2px;
}
```

### 6.2.3 — Compreensível (*Understandable*)

O conteúdo e a operação da interface devem ser **compreensíveis** — tanto o texto quanto o comportamento da página devem ser previsíveis e inteligíveis.

**Exemplos práticos:**

- O idioma da página deve ser declarado no atributo `lang` do `<html>` — leitores de tela utilizam essa informação para selecionar o sintetizador de voz correto
- Mudanças de idioma dentro do documento devem ser marcadas com `lang` no elemento correspondente
- Mensagens de erro em formulários devem identificar o campo problemático e sugerir como corrigi-lo
- A navegação deve ser consistente entre páginas — elementos repetidos (menu, rodapé) devem aparecer sempre na mesma posição relativa

```html
<!-- Compreensível: idioma declarado -->
<html lang="pt-BR">

<!-- Compreensível: trecho em outro idioma -->
<p>O princípio <span lang="la">ad hoc</span> é amplamente aplicado.</p>

<!-- Compreensível: mensagem de erro descritiva -->
<label for="cep">CEP:</label>
<input
  type="text"
  id="cep"
  name="cep"
  aria-describedby="cep-erro"
  aria-invalid="true"
/>
<p id="cep-erro" role="alert">
  CEP inválido. Informe o CEP no formato 00000-000.
</p>
```

### 6.2.4 — Robusto (*Robust*)

O conteúdo deve ser **robusto o suficiente** para ser interpretado de forma confiável por uma ampla variedade de agentes de usuário — navegadores atuais, navegadores antigos, leitores de tela, motores de indexação e tecnologias assistivas em geral.

Na prática, robustez significa essencialmente duas coisas: usar **HTML semântico correto** (conforme estudado nos capítulos anteriores) e garantir que o código seja **válido e bem formado**. Tecnologias assistivas dependem da estrutura semântica do documento para construir sua representação da página — um documento com erros estruturais produz comportamentos imprevisíveis.

**Exemplos práticos:**

- Usar elementos HTML semânticos nativos em vez de recriar comportamentos com `<div>` e ARIA
- Manter atributos ARIA consistentes com o estado real do componente
- Validar o documento regularmente com o W3C Validator

```html
<!-- Robusto: botão nativo — comportamento previsível em todos os contextos -->
<button type="button">Abrir menu</button>

<!-- Frágil: div tentando se comportar como botão —
     requer ARIA, JavaScript e tratamento de teclado manual -->
<div role="button" tabindex="0">Abrir menu</div>
```

> A regra fundamental de robustez pode ser resumida assim: **a primeira regra de ARIA é não usar ARIA**. Se existe um elemento HTML nativo que expressa a semântica necessária, use-o. ARIA é um complemento para situações que o HTML nativo não cobre — não um substituto para HTML semântico.

**Referências:**
- [W3C — WCAG 2.1](https://www.w3.org/TR/WCAG21/)
- [W3C — WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [MDN — Accessibility](https://developer.mozilla.org/pt-BR/docs/Web/Accessibility)

---

## 6.3 — ARIA básico

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

**ARIA** (*Accessible Rich Internet Applications*) é uma especificação do W3C que define um conjunto de atributos HTML capazes de complementar a semântica nativa dos elementos — comunicando funções, estados e propriedades de componentes de interface a tecnologias assistivas quando o HTML sozinho não é suficiente.

É importante compreender o escopo correto do ARIA: ele **não adiciona funcionalidade**, não muda a aparência visual e não afeta o comportamento do elemento para usuários sem tecnologia assistiva. ARIA comunica *significado* para a camada de acessibilidade do navegador — a **Accessibility Tree** — que por sua vez informa os leitores de tela e outros agentes.

### 6.3.1 — Quando usar (e quando não usar) ARIA

A especificação WAI-ARIA do W3C estabelece cinco regras de uso, das quais a mais importante é a primeira:

> **Primeira regra do ARIA:** se você pode usar um elemento HTML nativo ou atributo com a semântica e o comportamento que você precisa, use-o em vez de redefinir um elemento e adicionar ARIA.

Isso significa que `<button>` é sempre preferível a `<div role="button">`, que `<nav>` é sempre preferível a `<div role="navigation">`, e que `<h2>` é sempre preferível a `<div role="heading" aria-level="2">`.

ARIA é necessário em situações genuínas: componentes de interface personalizados sem equivalente HTML nativo (como abas, accordions, sliders customizados), estados dinâmicos que mudam via JavaScript, e regiões de conteúdo que precisam de rótulos adicionais.

### 6.3.2 — Os três pilares do ARIA: roles, states e properties

**Roles (funções)**

O atributo `role` define a *função* semântica de um elemento — o que ele *é* na interface:

```html
<!-- Quando um elemento não-semântico precisa comunicar sua função -->
<div role="alert">
  Sua sessão expirará em 5 minutos.
</div>

<div role="tablist">
  <button role="tab" aria-selected="true" aria-controls="painel-1">Aba 1</button>
  <button role="tab" aria-selected="false" aria-controls="painel-2">Aba 2</button>
</div>

<div role="tabpanel" id="painel-1">Conteúdo da Aba 1</div>
```

**States (estados)**

Atributos ARIA de estado comunicam a *condição atual* de um elemento — informações que mudam dinamicamente conforme o usuário interage:

```html
<!-- aria-expanded: indica se um elemento colapsável está aberto ou fechado -->
<button aria-expanded="false" aria-controls="menu-dropdown">
  Menu
</button>
<ul id="menu-dropdown" hidden>
  <li><a href="/inicio">Início</a></li>
  <li><a href="/sobre">Sobre</a></li>
</ul>

<!-- aria-selected: indica item selecionado em uma lista -->
<li role="option" aria-selected="true">JavaScript</li>

<!-- aria-checked: estado de checkbox customizado -->
<div role="checkbox" aria-checked="false" tabindex="0">
  Aceitar termos
</div>
```

**Properties (propriedades)**

Atributos ARIA de propriedade fornecem informações descritivas sobre um elemento — geralmente estáticas ou raramente alteradas:

```html
<!-- aria-label: rótulo para elementos sem texto visível -->
<button aria-label="Fechar modal" type="button">✕</button>

<!-- aria-labelledby: referencia outro elemento como rótulo -->
<h2 id="titulo-secao">Configurações de conta</h2>
<section aria-labelledby="titulo-secao">
  ...
</section>

<!-- aria-describedby: associa descrição adicional a um elemento -->
<input
  type="password"
  aria-describedby="requisitos-senha"
/>
<p id="requisitos-senha">
  Mínimo de 8 caracteres, incluindo letras maiúsculas, minúsculas e números.
</p>

<!-- aria-hidden: oculta elemento da árvore de acessibilidade -->
<!-- Útil para ícones decorativos que não devem ser anunciados -->
<button type="button">
  <svg aria-hidden="true" focusable="false">...</svg>
  Salvar documento
</button>

<!-- aria-live: anuncia atualizações dinâmicas de conteúdo -->
<div aria-live="polite" aria-atomic="true">
  <!-- Conteúdo atualizado via JavaScript será anunciado pelo leitor de tela -->
  3 resultados encontrados
</div>
```

### 6.3.3 — Atributos ARIA mais utilizados na prática

| Atributo | Tipo | Uso principal |
|---|---|---|
| `role` | role | Define a função semântica do elemento |
| `aria-label` | property | Rótulo para elementos sem texto visível |
| `aria-labelledby` | property | Referencia outro elemento como rótulo |
| `aria-describedby` | property | Associa descrição adicional |
| `aria-hidden` | state | Oculta da árvore de acessibilidade |
| `aria-expanded` | state | Estado de expansão (aberto/fechado) |
| `aria-selected` | state | Item selecionado em lista ou abas |
| `aria-checked` | state | Estado de marcação |
| `aria-disabled` | state | Elemento desabilitado |
| `aria-required` | property | Campo obrigatório em formulários |
| `aria-invalid` | state | Campo com valor inválido |
| `aria-live` | property | Anuncia atualizações dinâmicas |
| `aria-current` | state | Item atual (página, passo, localização) |

**Referências:**
- [W3C — WAI-ARIA 1.2](https://www.w3.org/TR/wai-aria-1.2/)
- [MDN — ARIA](https://developer.mozilla.org/pt-BR/docs/Web/Accessibility/ARIA)
- [W3C — ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/)

---

## 6.4 — Boas práticas imediatas

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Acessibilidade pode parecer um tema vasto e complexo, mas a maior parte dos problemas mais frequentes é resolvida por um conjunto relativamente pequeno de boas práticas que qualquer desenvolvedor pode aplicar imediatamente — sem conhecimento avançado de ARIA ou tecnologias assistivas.

### 6.4.1 — Hierarquia de títulos

A hierarquia de títulos (`<h1>`–`<h6>`) é o principal mecanismo de navegação de usuários de leitores de tela. Segundo pesquisas da WebAIM, **67,7% dos usuários de leitores de tela** navegam páginas web primeiramente pela lista de títulos.

A regra é direta: os títulos devem refletir a estrutura lógica do documento, sem saltar níveis. Uma página deve ter exatamente um `<h1>`, e os demais títulos devem seguir uma hierarquia coerente.

```html
<!-- INCORRETO: salto de h1 para h3 -->
<h1>Programação Web 1</h1>
  <h3>Capítulo 2</h3>  <!-- deveria ser h2 -->
    <h4>Introdução</h4>

<!-- CORRETO: hierarquia sem saltos -->
<h1>Programação Web 1</h1>
  <h2>Capítulo 2 — Fundamentos do HTML</h2>
    <h3>2.1 — Introdução ao HTML</h3>
    <h3>2.2 — Tags Essenciais</h3>
  <h2>Capítulo 3 — HTML Semântico</h2>
```

### 6.4.2 — Textos alternativos para imagens

O atributo `alt` é obrigatório em todos os elementos `<img>`. A qualidade do texto alternativo, porém, varia enormemente na prática. Algumas orientações:

- **Imagens informativas:** descreva o conteúdo e a função da imagem — não apenas o que ela mostra, mas o que ela comunica no contexto
- **Imagens decorativas:** use `alt=""` (vazio) — o leitor de tela ignorará a imagem
- **Imagens de texto:** transcreva o texto exato contido na imagem
- **Gráficos e infográficos:** descreva a conclusão ou tendência principal, não os dados brutos

```html
<!-- Informativa: descreve conteúdo e contexto -->
<img
  src="grafico-crescimento.png"
  alt="Gráfico de linha mostrando crescimento de 127% no número
       de matrículas em cursos de TI entre 2020 e 2025"
/>

<!-- Decorativa: alt vazio -->
<img src="divider-ornamental.svg" alt="" />

<!-- Imagem de texto: transcrição exata -->
<img
  src="citacao-berners-lee.jpg"
  alt="Citação de Tim Berners-Lee: 'The Web is more a social
       creation than a technical one.'"
/>
```

### 6.4.3 — Contraste de cores

O contraste insuficiente entre texto e fundo é um dos problemas de acessibilidade mais comuns e mais fáceis de verificar. As WCAG 2.1 definem os seguintes requisitos mínimos de contraste:

| Nível | Texto normal (< 18pt) | Texto grande (≥ 18pt ou ≥ 14pt negrito) |
|---|---|---|
| AA (mínimo) | 4,5:1 | 3:1 |
| AAA (aprimorado) | 7:1 | 4,5:1 |

Ferramentas para verificar contraste:
- **WebAIM Contrast Checker:** [https://webaim.org/resources/contrastchecker/](https://webaim.org/resources/contrastchecker/)
- **Colour Contrast Analyser** (aplicativo desktop gratuito)
- **DevTools:** aba Elements → inspecionar propriedade `color` → o Chrome exibe a razão de contraste automaticamente

> **Imagem sugerida:** captura do Chrome DevTools mostrando o painel de cor com a razão de contraste exibida ao inspecionar um elemento de texto — destacando a diferença entre uma razão abaixo de 4,5:1 (reprovada) e uma acima (aprovada).
>
> *(imagem será adicionada posteriormente)*

### 6.4.4 — Navegação por teclado

Toda a funcionalidade de uma página deve ser acessível sem o uso do mouse. O fluxo de navegação por teclado segue esta sequência:

- `Tab` — avança para o próximo elemento focável
- `Shift+Tab` — retorna ao elemento focável anterior
- `Enter` — ativa links e botões
- `Espaço` — ativa botões e checkboxes
- `Setas` — navega entre itens de radio buttons e menus

Para garantir navegação por teclado adequada:

```html
<!-- Elementos interativos nativos são focáveis automaticamente -->
<a href="/pagina">Link</a>
<button>Botão</button>
<input type="text" />
<select>...</select>

<!-- tabindex="0": torna qualquer elemento focável na ordem natural -->
<div tabindex="0" role="button">Elemento customizado focável</div>

<!-- tabindex="-1": torna elemento programaticamente focável
     (via JavaScript), mas não na navegação por Tab -->
<div tabindex="-1" id="conteudo-modal">...</div>

<!-- NUNCA use tabindex positivo (tabindex="1", "2", etc.)
     — cria uma ordem de foco artificial e confusa -->
```

**Nunca remova o indicador de foco sem fornecer uma alternativa:**

```css
/* INCORRETO: remove completamente o foco visível */
* { outline: none; }

/* CORRETO: customiza o foco com contraste adequado */
:focus-visible {
  outline: 3px solid #0057B8;
  outline-offset: 3px;
  border-radius: 2px;
}
```

### 6.4.5 — Links descritivos

O texto de um link deve fazer sentido fora de contexto — pois usuários de leitores de tela frequentemente navegam pela lista de links da página sem ler o texto ao redor.

```html
<!-- INCORRETO: texto não descritivo -->
<a href="/relatorio-2026.pdf">Clique aqui</a>
<a href="/sobre">Saiba mais</a>

<!-- CORRETO: texto descritivo -->
<a href="/relatorio-2026.pdf">Relatório anual 2026 (PDF, 2,4 MB)</a>
<a href="/sobre">Saiba mais sobre o IFAL Arapiraca</a>

<!-- Quando o texto visível for inevitavelmente curto,
     use aria-label para complementar -->
<a href="/relatorio-2026.pdf" aria-label="Baixar relatório anual 2026 em PDF">
  Baixar
</a>
```

### 6.4.6 — Formulários acessíveis: revisão

Os princípios de acessibilidade em formulários foram abordados em profundidade no Capítulo 5. Como revisão, os pontos essenciais são:

- Todo campo deve ter um `<label>` associado programaticamente — nunca depender apenas de `placeholder`
- Grupos de campos relacionados devem ser envolvidos por `<fieldset>` com `<legend>`
- Mensagens de erro devem ser associadas ao campo via `aria-describedby` e anunciadas dinamicamente via `role="alert"` ou `aria-live`
- O `<button>` dentro de formulários deve sempre ter `type` declarado explicitamente

---

## 6.5 — Ferramentas e próximos passos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 6.5.1 — Ferramentas de diagnóstico

As ferramentas de diagnóstico de acessibilidade foram apresentadas no Capítulo 3 (seção 3.5). Como referência consolidada para este capítulo:

| Ferramenta | Tipo | O que verifica | Acesso |
|---|---|---|---|
| **W3C Validator** | Online | Validade sintática do HTML | [validator.w3.org](https://validator.w3.org) |
| **WAVE** | Online / extensão | Acessibilidade geral (erros, alertas, estrutura) | [wave.webaim.org](https://wave.webaim.org) |
| **Lighthouse** | DevTools | Pontuação de acessibilidade + lista priorizada | `F12` → Lighthouse |
| **Accessibility Tree** | DevTools | Árvore de acessibilidade, roles, nomes | `F12` → Elements → Accessibility |
| **Contrast Checker** | Online | Razão de contraste entre texto e fundo | [webaim.org/resources/contrastchecker](https://webaim.org/resources/contrastchecker) |
| **NVDA** | Leitor de tela | Teste real com tecnologia assistiva | [nvaccess.org](https://www.nvaccess.org/download/) |

> **No DevTools:** para inspecionar a árvore de acessibilidade completa de uma página, abra o DevTools (`F12`), vá até a aba **Elements**, selecione qualquer elemento e expanda o painel **Accessibility** no lado direito. Ative a opção **"Enable full-page accessibility tree"** para visualizar toda a hierarquia de elementos acessíveis da página em formato de árvore, paralela à árvore DOM.

### 6.5.2 — O fluxo de diagnóstico recomendado

Para os projetos desta disciplina, o fluxo de diagnóstico recomendado é o apresentado no Capítulo 3, seção 3.5.4 — resumido aqui como referência:

1. **W3C Validator** — garantir ausência de erros sintáticos
2. **DevTools → Accessibility Tree** — verificar roles e nomes acessíveis dos elementos principais
3. **WAVE** — auditoria completa de acessibilidade da página
4. **Lighthouse** — pontuação geral e lista priorizada de problemas

### 6.5.3 — Acessibilidade no contexto profissional de SI

Para estudantes de Sistemas de Informação, acessibilidade não é apenas uma questão de front-end. Ela atravessa múltiplas dimensões do desenvolvimento de software:

**No backend:** APIs que retornam mensagens de erro claras e estruturadas permitem que o frontend construa feedback acessível para o usuário. A estrutura dos dados influencia como o frontend pode apresentá-los de forma acessível.

**No banco de dados:** textos alternativos, transcrições e metadados de acessibilidade frequentemente precisam ser armazenados e gerenciados como dados de primeira classe.

**Em sistemas de informação:** relatórios, dashboards e interfaces administrativas — os produtos mais comuns de projetos de SI — são frequentemente acessados por uma ampla variedade de usuários, incluindo pessoas com deficiência visual que usam leitores de tela para navegar por tabelas de dados.

**Na gestão de projetos:** requisitos de acessibilidade devem ser incluídos desde a fase de levantamento de requisitos, não tratados como ajustes finais. Incorporar acessibilidade tardiamente é significativamente mais custoso do que projetá-la desde o início.

### 6.5.4 — Para aprofundamento

Este capítulo oferece uma visão panorâmica da acessibilidade web. Para aprofundamento progressivo, recomenda-se a seguinte sequência de recursos:

**Nível introdutório:**
- [WebAIM — Introduction to Web Accessibility](https://webaim.org/intro/) — leitura inicial recomendada
- [Google — Web Accessibility (curso gratuito no Udacity)](https://www.udacity.com/course/web-accessibility--ud891)

**Nível intermediário:**
- [W3C — WAI Tutorials](https://www.w3.org/WAI/tutorials/) — tutoriais práticos por componente (menus, formulários, tabelas, imagens)
- [MDN — Accessibility](https://developer.mozilla.org/pt-BR/docs/Web/Accessibility)

**Referência técnica:**
- [WCAG 2.1 — Especificação completa](https://www.w3.org/TR/WCAG21/)
- [WCAG 2.2 — Especificação completa](https://www.w3.org/TR/WCAG22/)
- [ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) — padrões de implementação de componentes interativos acessíveis

---

#### **Atividades — Capítulo 6**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> O que significa dizer que a acessibilidade web visa uma experiência "equivalente" para todos os usuários?</p>
  <button data-option="a">Que todos os usuários devem ver exatamente a mesma interface visual.</button>
  <button data-option="b">Que usuários com deficiência devem receber uma versão simplificada da página.</button>
  <button data-option="c">Que a experiência deve ser funcionalmente equivalente para todos, ainda que os meios de acesso sejam diferentes — como teclado em vez de mouse, ou leitor de tela em vez de visão.</button>
  <button data-option="d">Que a página deve funcionar igualmente em todos os navegadores.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Qual dos quatro princípios WCAG (POUR) está sendo violado quando uma mensagem de erro é comunicada apenas pela cor vermelha de um campo, sem texto ou ícone adicional?</p>
  <button data-option="a">Operável — o usuário não consegue interagir com o campo.</button>
  <button data-option="b">Perceptível — a informação do erro depende exclusivamente de percepção visual de cor, excluindo usuários daltônicos ou com baixa visão.</button>
  <button data-option="c">Compreensível — o usuário não entende o significado da cor.</button>
  <button data-option="d">Robusto — o código não é interpretado corretamente por leitores de tela.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual é a "primeira regra do ARIA"?</p>
  <button data-option="a">Sempre adicionar atributos ARIA a todos os elementos interativos.</button>
  <button data-option="b">ARIA deve ser usado apenas em formulários.</button>
  <button data-option="c">Nunca usar ARIA — ele é obsoleto no HTML5.</button>
  <button data-option="d">Se existe um elemento HTML nativo com a semântica necessária, usá-lo em vez de adicionar ARIA a um elemento genérico.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> Por que nunca se deve remover o <code>outline</code> de foco via CSS sem fornecer uma alternativa visual?</p>
  <button data-option="a">Porque o indicador de foco é o único mecanismo visual que permite a usuários que navegam por teclado saber qual elemento está atualmente ativo — sua remoção torna a navegação por teclado inoperável.</button>
  <button data-option="b">Porque o CSS não tem permissão de sobrescrever estilos nativos do navegador.</button>
  <button data-option="c">Porque o outline afeta o cálculo do box model e pode quebrar o layout.</button>
  <button data-option="d">Porque navegadores modernos ignoram a propriedade <code>outline: none</code>.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Auditar a página construída nas atividades anteriores utilizando WAVE e Lighthouse, documentar os problemas encontrados em um arquivo `acessibilidade.md` com: lista de erros identificados, descrição do impacto de cada erro para o usuário afetado, e as correções aplicadas no HTML. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 5 — Formulários HTML](05-formularios-html.md)
[:material-arrow-right: Ir ao Capítulo 7 — Fundamentos do CSS](07-fundamentos-css.md)
