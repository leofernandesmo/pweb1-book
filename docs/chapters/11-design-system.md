# Capítulo 11 — Variáveis CSS e Design System

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 11.1 — O que é um Design System

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Um **Design System** é um conjunto de padrões, componentes, diretrizes e ferramentas que governam a linguagem visual e de interação de um produto digital — ou de uma família de produtos. Mais do que uma coleção de elementos visuais, um Design System é uma **infraestrutura de design e desenvolvimento compartilhada**: um contrato entre designers e desenvolvedores que estabelece como os elementos da interface devem ser construídos, nomeados, documentados e reutilizados de forma consistente ao longo do tempo e entre equipes.

A motivação para a existência de Design Systems é diretamente rastreável a problemas recorrentes em projetos de software de médio e grande porte: inconsistências visuais entre telas de uma mesma aplicação, retrabalho na implementação de componentes semelhantes, dificuldade de manutenção quando regras visuais mudam, e ausência de vocabulário comum entre as equipes de design e desenvolvimento. O Design System resolve esses problemas ao centralizar as decisões de design em uma fonte única de verdade (*single source of truth*).

### 11.1.1 — Definição e propósito

Nathan Curtis, um dos pesquisadores mais influentes na área, define Design System como "o conjunto completo de padrões de design, documentação e princípios, juntamente com o kit de ferramentas (padrões de UI, biblioteca de código) para alcançar esses padrões". Esta definição aponta para três dimensões interdependentes:

**Dimensão visual:** tokens de design (cores, tipografia, espaçamento, sombras, bordas), princípios de composição e hierarquia visual.

**Dimensão de componentes:** biblioteca de componentes reutilizáveis — botões, formulários, cards, navegação, modais — com variantes documentadas e comportamentos definidos.

**Dimensão de documentação:** diretrizes de uso, exemplos de aplicação correta e incorreta, princípios de acessibilidade, guias de contribuição para equipes que mantêm e evoluem o sistema.

O propósito central é a **consistência com eficiência**: garantir que elementos similares sejam tratados de forma idêntica em toda a aplicação, sem que cada desenvolvedor precise tomar as mesmas decisões visuais do zero.

### 11.1.2 — Design System vs biblioteca de componentes vs style guide

Estes três termos são frequentemente usados de forma intercambiável no mercado, o que gera confusão. A distinção conceitual é precisa:

**Style guide:** documento — frequentemente estático — que descreve a identidade visual de uma marca ou produto: paleta de cores, tipografia, logotipo e suas regras de uso. É a camada mais superficial e não necessariamente inclui código.

**Biblioteca de componentes:** coleção de componentes de interface implementados em código (HTML/CSS/JavaScript ou um framework específico como React). Foca na implementação, não necessariamente na documentação de princípios ou no porquê das decisões.

**Design System:** o conjunto mais abrangente — inclui os tokens de design, a biblioteca de componentes, o style guide e a documentação de princípios, padrões de acessibilidade e diretrizes de contribuição. É um sistema vivo, mantido como produto por uma equipe.

```
Style Guide ⊂ Biblioteca de Componentes ⊂ Design System
```

Para os fins deste capítulo, construiremos o núcleo técnico de um Design System: os tokens de design implementados como variáveis CSS e uma biblioteca mínima de componentes reutilizáveis.

### 11.1.3 — Por que Design Systems importam para Sistemas de Informação

A relevância dos Design Systems para profissionais de Sistemas de Informação vai além do desenvolvimento front-end:

**Sistemas corporativos e dashboards** — os produtos mais comuns em projetos de SI — são caracterizados por grande quantidade de telas com elementos repetitivos: tabelas de dados, formulários de cadastro, painéis de controle, relatórios. Sem um sistema de componentes, cada tela é implementada de forma ad hoc, acumulando inconsistências e duplicações.

**Manutenção a longo prazo** — sistemas de informação frequentemente têm ciclos de vida de décadas. Um Design System bem estruturado permite que mudanças visuais globais (como uma nova identidade corporativa ou uma migração para tema escuro) sejam aplicadas alterando tokens, não caçando instâncias espalhadas por centenas de arquivos CSS.

**Trabalho em equipe** — projetos de SI são desenvolvidos por equipes, frequentemente com rotatividade de membros. Um Design System documentado reduz o tempo de onboarding e garante que novos membros sigam os mesmos padrões sem depender de conhecimento tácito.

**Acessibilidade sistemática** — incorporar requisitos de acessibilidade (contrastes mínimos, tamanhos de alvo, estados de foco) nos próprios componentes do Design System garante que toda interface construída com eles herde essas propriedades — em vez de depender da memória de cada desenvolvedor em cada implementação.

### 11.1.4 — Exemplos reais: Material Design, Fluent, Carbon e Radix

Analisar Design Systems de organizações de referência é uma forma eficaz de compreender sua estrutura e ambição:

**Material Design (Google)** — [m3.material.io](https://m3.material.io)
O Design System mais influente da última década. Sua terceira versão (Material You / M3) introduziu o conceito de *color tokens* dinâmicos gerados a partir de uma cor-semente, com suporte nativo a tema claro/escuro. É a base visual do ecossistema Android e de produtos Google como Gmail, Maps e Docs.

**Fluent Design System (Microsoft)** — [fluent2.microsoft.design](https://fluent2.microsoft.design)
Governa a interface de produtos Microsoft: Windows, Office, Teams, Azure. Notável pela sua implementação de tokens em múltiplas camadas (global → alias → component) e pela documentação extensiva de padrões de acessibilidade baseados nas WCAG.

**Carbon Design System (IBM)** — [carbondesignsystem.com](https://carbondesignsystem.com)
Design System de código aberto amplamente adotado em sistemas corporativos e enterprise. Particularmente relevante para SI por sua ênfase em componentes de dados: tabelas, gráficos, formulários complexos e dashboards.

**Radix UI** — [radix-ui.com](https://www.radix-ui.com)
Design System focado em acessibilidade, com componentes *headless* (sem estilo predefinido) que implementam padrões WAI-ARIA corretamente. Usado como base por Shadcn/UI e outros sistemas populares.

> **Exercício de análise:** acesse [tokens.studio](https://tokens.studio) e examine como tokens de design são estruturados em projetos reais. Compare a hierarquia de tokens do Material Design (disponível em [github.com/material-components](https://github.com/material-components)) com a do Carbon Design System.

---

## 11.2 — Variáveis CSS como fundação do sistema

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 11.2.1 — Revisão: Custom Properties no contexto de sistemas

As variáveis CSS (*Custom Properties*), introduzidas no Capítulo 7 (seção 7.12), são o mecanismo técnico que torna possível implementar um Design System diretamente em CSS puro — sem dependência de pré-processadores como Sass ou de ferramentas de build. Sua capacidade de herança, escopo e modificação em tempo de execução (via JavaScript ou media queries) as torna significativamente mais poderosas do que variáveis de pré-processadores.

No contexto de um Design System, variáveis CSS cumprem um papel que vai além da conveniência de evitar repetição: elas implementam o conceito de **token de design** — a unidade atômica do sistema de design.

### 11.2.2 — Tokens de design: o que são e por que existem

**Tokens de design** são as decisões de design armazenadas como pares nome-valor. O conceito foi formalizado pela equipe do Salesforce Lightning Design System em 2014 e tornou-se o padrão da indústria para representar decisões visuais de forma portável, independente de tecnologia.

Um token não é apenas uma variável com um valor — é um **nome com significado semântico** que representa uma decisão de design específica:

```css
/* Isso NÃO é um token — é apenas um valor nomeado */
--azul: #0057B8;

/* Isso É um token — representa uma decisão semântica */
--cor-interativa-padrao: #0057B8;
/* Significa: "a cor padrão de elementos interativos neste sistema" */
```

A diferença é sutil mas fundamental: quando a decisão de design muda — por exemplo, a cor interativa passa a ser verde em vez de azul —, o token semântico `--cor-interativa-padrao` é atualizado em um único lugar, e todos os componentes que o referenciam refletem a mudança automaticamente.

### 11.2.3 — Hierarquia de tokens: primitivos, semânticos e de componente

A arquitetura de tokens mais robusta organiza os valores em três camadas hierárquicas, um padrão adotado por Material Design, Fluent e Carbon:

**Camada 1 — Tokens primitivos (Global Tokens)**

São os valores brutos do sistema — todas as cores, tamanhos e pesos disponíveis, sem qualquer intenção semântica. Funcionam como a paleta completa de possibilidades:

```css
:root {
  /* Escala de azul */
  --azul-50:  #EFF6FF;
  --azul-100: #DBEAFE;
  --azul-200: #BFDBFE;
  --azul-300: #93C5FD;
  --azul-400: #60A5FA;
  --azul-500: #3B82F6;
  --azul-600: #2563EB;
  --azul-700: #1D4ED8;
  --azul-800: #1E40AF;
  --azul-900: #1E3A8A;

  /* Escala de cinza */
  --cinza-50:  #F9FAFB;
  --cinza-100: #F3F4F6;
  --cinza-200: #E5E7EB;
  --cinza-300: #D1D5DB;
  --cinza-400: #9CA3AF;
  --cinza-500: #6B7280;
  --cinza-600: #4B5563;
  --cinza-700: #374151;
  --cinza-800: #1F2937;
  --cinza-900: #111827;

  /* Escala tipográfica */
  --tamanho-xs:   0.75rem;
  --tamanho-sm:   0.875rem;
  --tamanho-base: 1rem;
  --tamanho-lg:   1.125rem;
  --tamanho-xl:   1.25rem;
  --tamanho-2xl:  1.5rem;
  --tamanho-3xl:  1.875rem;
  --tamanho-4xl:  2.25rem;

  /* Escala de espaçamento */
  --espaco-1: 0.25rem;
  --espaco-2: 0.5rem;
  --espaco-3: 0.75rem;
  --espaco-4: 1rem;
  --espaco-6: 1.5rem;
  --espaco-8: 2rem;
  --espaco-12: 3rem;
  --espaco-16: 4rem;
}
```

**Camada 2 — Tokens semânticos (Alias Tokens)**

Referenciam tokens primitivos e atribuem intenção semântica. Esta é a camada que conecta decisões de design a propósitos de interface:

```css
:root {
  /* Cores semânticas — referenciam primitivos */
  --cor-primaria:         var(--azul-700);
  --cor-primaria-hover:   var(--azul-800);
  --cor-primaria-suave:   var(--azul-100);

  --cor-texto-padrao:     var(--cinza-900);
  --cor-texto-secundario: var(--cinza-600);
  --cor-texto-desabilitado: var(--cinza-400);
  --cor-texto-inverso:    var(--cinza-50);

  --cor-fundo-pagina:     var(--cinza-50);
  --cor-fundo-card:       #FFFFFF;
  --cor-fundo-sutil:      var(--cinza-100);

  --cor-borda-padrao:     var(--cinza-200);
  --cor-borda-forte:      var(--cinza-400);

  --cor-sucesso:          #16A34A;
  --cor-sucesso-suave:    #DCFCE7;
  --cor-aviso:            #D97706;
  --cor-aviso-suave:      #FEF3C7;
  --cor-erro:             #DC2626;
  --cor-erro-suave:       #FEE2E2;
  --cor-informacao:       var(--azul-600);
  --cor-informacao-suave: var(--azul-100);

  /* Tipografia semântica */
  --fonte-corpo:    'Inter', system-ui, sans-serif;
  --fonte-titulo:   'Inter', system-ui, sans-serif;
  --fonte-codigo:   'Fira Code', 'Cascadia Code', monospace;

  --tamanho-corpo:  var(--tamanho-base);
  --tamanho-label:  var(--tamanho-sm);
  --tamanho-caption: var(--tamanho-xs);

  --peso-regular: 400;
  --peso-medio:   500;
  --peso-semibold: 600;
  --peso-bold:    700;

  --altura-linha-corpo:   1.6;
  --altura-linha-titulo:  1.2;
  --altura-linha-codigo:  1.5;

  /* Bordas semânticas */
  --raio-sm:      4px;
  --raio-md:      8px;
  --raio-lg:      12px;
  --raio-xl:      16px;
  --raio-circulo: 9999px;

  /* Sombras semânticas */
  --sombra-sm:  0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
  --sombra-md:  0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --sombra-lg:  0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
  --sombra-xl:  0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);

  /* Transições semânticas */
  --transicao-rapida:  150ms ease;
  --transicao-padrao:  200ms ease;
  --transicao-lenta:   300ms ease;

  /* Z-index semântico */
  --z-base:    0;
  --z-elevado: 10;
  --z-sticky:  100;
  --z-overlay: 1000;
  --z-modal:   1100;
  --z-toast:   1200;
}
```

**Camada 3 — Tokens de componente (Component Tokens)**

Específicos de cada componente — referenciam tokens semânticos e permitem personalização granular sem quebrar o sistema:

```css
/* Tokens do componente Button */
:root {
  --btn-padding-v:         var(--espaco-2);
  --btn-padding-h:         var(--espaco-4);
  --btn-raio:              var(--raio-md);
  --btn-tamanho-fonte:     var(--tamanho-base);
  --btn-peso-fonte:        var(--peso-semibold);
  --btn-transicao:         var(--transicao-padrao);

  /* Variante primária */
  --btn-primario-fundo:    var(--cor-primaria);
  --btn-primario-texto:    var(--cor-texto-inverso);
  --btn-primario-hover:    var(--cor-primaria-hover);

  /* Variante secundária */
  --btn-secundario-fundo:  transparent;
  --btn-secundario-texto:  var(--cor-primaria);
  --btn-secundario-borda:  var(--cor-primaria);

  /* Variante de perigo */
  --btn-perigo-fundo:      var(--cor-erro);
  --btn-perigo-texto:      var(--cor-texto-inverso);
}

/* Tokens do componente Card */
:root {
  --card-fundo:     var(--cor-fundo-card);
  --card-raio:      var(--raio-lg);
  --card-sombra:    var(--sombra-md);
  --card-padding:   var(--espaco-6);
  --card-borda:     1px solid var(--cor-borda-padrao);
}
```

### 11.2.4 — Nomenclatura de tokens: convenções e boas práticas

A nomenclatura consistente é um dos aspectos mais importantes de um Design System — nomes ruins tornam o sistema difícil de aprender e usar. Algumas convenções amplamente adotadas:

**Estrutura de nome:** `--[categoria]-[propriedade]-[variante]-[estado]`

```css
/* Exemplos seguindo a convenção */
--cor-texto-primario          /* categoria: cor | propriedade: texto | variante: primario */
--cor-fundo-card-hover        /* + estado: hover */
--tamanho-fonte-titulo-lg     /* + variante de tamanho */
--espaco-padding-btn-sm       /* espaçamento específico de componente */
```

**Princípios de nomenclatura:**

- **Semântico, não descritivo:** `--cor-primaria` é melhor que `--azul` — o nome descreve o *propósito*, não o valor
- **Escalável:** `--espaco-4` (múltiplo de 4) é melhor que `--espaco-medio` — permite adicionar `--espaco-5` sem quebrar a semântica
- **Predizível:** seguir um padrão consistente permite que desenvolvedores adivinhem nomes corretos sem consultar documentação
- **Kebab-case:** usar hífens (`--cor-fundo-card`), nunca underscores ou camelCase

---

## 11.3 — Paleta de cores sistemática

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 11.3.1 — Construindo escalas de cor com HSL

O sistema de cor HSL (*Hue, Saturation, Lightness*) é o mais adequado para construir escalas de cor sistemáticas porque permite criar variações mantendo identidade visual: fixar matiz (*hue*) e saturação enquanto varia a luminosidade produz uma família de cores coerente.

```css
:root {
  /* Escala de azul construída com HSL
     Matiz fixo: 217° | Saturação fixo: 91% | Luminosidade variável */
  --azul-50:  hsl(217, 91%, 97%);
  --azul-100: hsl(217, 91%, 92%);
  --azul-200: hsl(217, 91%, 84%);
  --azul-300: hsl(217, 91%, 74%);
  --azul-400: hsl(217, 91%, 62%);
  --azul-500: hsl(217, 91%, 52%);  /* cor base */
  --azul-600: hsl(217, 91%, 42%);
  --azul-700: hsl(217, 91%, 34%);
  --azul-800: hsl(217, 91%, 26%);
  --azul-900: hsl(217, 91%, 18%);
  --azul-950: hsl(217, 91%, 12%);
}
```

Esta abordagem garante que todas as variações da mesma cor mantenham coerência visual — a escala de azul-50 ao azul-950 é reconhecível como uma família.

**Construindo múltiplas escalas:**

```css
:root {
  /* Escala de cinza neutro */
  --cinza-50:  hsl(220, 14%, 97%);
  --cinza-100: hsl(220, 14%, 94%);
  --cinza-500: hsl(220, 9%,  46%);
  --cinza-900: hsl(220, 26%, 14%);

  /* Escala de verde para feedback de sucesso */
  --verde-50:  hsl(138, 76%, 97%);
  --verde-100: hsl(141, 79%, 91%);
  --verde-500: hsl(142, 71%, 45%);
  --verde-700: hsl(142, 64%, 29%);

  /* Escala de vermelho para feedback de erro */
  --vermelho-50:  hsl(0, 86%, 97%);
  --vermelho-100: hsl(0, 93%, 94%);
  --vermelho-500: hsl(0, 84%, 60%);
  --vermelho-700: hsl(0, 74%, 42%);

  /* Escala de amarelo para avisos */
  --amarelo-50:  hsl(48, 100%, 96%);
  --amarelo-100: hsl(48, 96%,  89%);
  --amarelo-500: hsl(38, 92%,  50%);
  --amarelo-700: hsl(32, 81%,  29%);
}
```

### 11.3.2 — Tokens semânticos de cor

Com a paleta primitiva definida, os tokens semânticos mapeiam propósitos de interface a valores concretos:

```css
:root {
  /* Cores de ação e marca */
  --cor-primaria:           var(--azul-700);
  --cor-primaria-hover:     var(--azul-800);
  --cor-primaria-ativa:     var(--azul-900);
  --cor-primaria-suave:     var(--azul-100);
  --cor-primaria-borda:     var(--azul-300);

  /* Cores de feedback */
  --cor-sucesso:            var(--verde-700);
  --cor-sucesso-fundo:      var(--verde-50);
  --cor-sucesso-borda:      var(--verde-100);
  --cor-sucesso-texto:      var(--verde-700);

  --cor-aviso:              var(--amarelo-700);
  --cor-aviso-fundo:        var(--amarelo-50);
  --cor-aviso-borda:        var(--amarelo-100);

  --cor-erro:               var(--vermelho-700);
  --cor-erro-fundo:         var(--vermelho-50);
  --cor-erro-borda:         var(--vermelho-100);
  --cor-erro-texto:         var(--vermelho-700);

  --cor-informacao:         var(--azul-700);
  --cor-informacao-fundo:   var(--azul-50);
  --cor-informacao-borda:   var(--azul-100);

  /* Cores de superfície */
  --cor-fundo-pagina:       var(--cinza-50);
  --cor-fundo-card:         #FFFFFF;
  --cor-fundo-sutil:        var(--cinza-100);
  --cor-fundo-forte:        var(--cinza-200);

  /* Cores de texto */
  --cor-texto-padrao:       var(--cinza-900);
  --cor-texto-secundario:   var(--cinza-600);
  --cor-texto-sutil:        var(--cinza-400);
  --cor-texto-desabilitado: var(--cinza-300);
  --cor-texto-inverso:      #FFFFFF;
  --cor-texto-link:         var(--azul-700);
  --cor-texto-link-hover:   var(--azul-800);

  /* Cores de borda */
  --cor-borda-sutil:        var(--cinza-100);
  --cor-borda-padrao:       var(--cinza-200);
  --cor-borda-forte:        var(--cinza-400);
  --cor-borda-foco:         var(--azul-500);
}
```

### 11.3.3 — Tema claro e escuro com tokens semânticos

A arquitetura de tokens semânticos é o que torna o tema escuro elegante e manutenível. Com tokens bem definidos, alternar entre temas requer apenas redefinir os tokens semânticos — os componentes não precisam ser alterados:

```css
/* Tema claro: padrão */
:root,
[data-tema="claro"] {
  --cor-fundo-pagina:     var(--cinza-50);
  --cor-fundo-card:       #FFFFFF;
  --cor-fundo-sutil:      var(--cinza-100);
  --cor-texto-padrao:     var(--cinza-900);
  --cor-texto-secundario: var(--cinza-600);
  --cor-borda-padrao:     var(--cinza-200);
  --cor-primaria:         var(--azul-700);
  --cor-primaria-hover:   var(--azul-800);
  --sombra-card: var(--sombra-md);
}

/* Tema escuro: preferência do sistema */
@media (prefers-color-scheme: dark) {
  :root {
    --cor-fundo-pagina:     hsl(220, 26%, 10%);
    --cor-fundo-card:       hsl(220, 22%, 15%);
    --cor-fundo-sutil:      hsl(220, 18%, 18%);
    --cor-texto-padrao:     var(--cinza-100);
    --cor-texto-secundario: var(--cinza-400);
    --cor-borda-padrao:     hsl(220, 15%, 25%);
    --cor-primaria:         var(--azul-400);
    --cor-primaria-hover:   var(--azul-300);
    --sombra-card: 0 4px 6px -1px rgb(0 0 0 / 0.4);
  }
}

/* Tema escuro: classe manual (para toggle via JavaScript) */
[data-tema="escuro"] {
  --cor-fundo-pagina:     hsl(220, 26%, 10%);
  --cor-fundo-card:       hsl(220, 22%, 15%);
  /* ... mesmas redefinições */
}
```

```javascript
// Toggle de tema via JavaScript
const btn = document.querySelector('.btn-tema');
btn.addEventListener('click', () => {
  const atual = document.documentElement.dataset.tema;
  document.documentElement.dataset.tema = atual === 'escuro' ? 'claro' : 'escuro';
});
```

### 11.3.4 — Contraste e acessibilidade na paleta

A construção da paleta deve incorporar verificações de contraste desde o início — não como ajuste posterior. As WCAG 2.1 exigem razões mínimas de contraste de **4,5:1** para texto normal e **3:1** para texto grande (nível AA).

```css
/* Pares de cor com razão de contraste verificada */

/* --cor-texto-padrao sobre --cor-fundo-pagina */
/* cinza-900 (#111827) sobre cinza-50 (#F9FAFB): ~17:1 ✅ AAA */

/* --cor-texto-secundario sobre --cor-fundo-pagina */
/* cinza-600 (#4B5563) sobre cinza-50: ~7:1 ✅ AAA */

/* --cor-texto-inverso sobre --cor-primaria */
/* Branco sobre azul-700 (#1D4ED8): ~5.7:1 ✅ AA */

/* ⚠️ Verificar sempre: */
/* cinza-400 (#9CA3AF) sobre branco: ~2.5:1 ❌ — apenas para texto decorativo */
```

> **Ferramenta:** use o [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) ou o painel de cores do Chrome DevTools para verificar cada par de cor antes de adicioná-lo ao sistema.

---

## 11.4 — Tipografia sistemática

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 11.4.1 — Escala tipográfica: racional e modular

Uma **escala tipográfica** é um conjunto de tamanhos de fonte que seguem uma razão matemática, produzindo uma progressão harmônica e visualmente coerente. A escala mais comum na Web é baseada em uma **razão modular** — cada tamanho é o anterior multiplicado por uma constante.

**Razões modulares comuns:**

| Razão | Nome | Exemplo (base 1rem) |
|---|---|---|
| 1.125 | Major Second | 1, 1.125, 1.266, 1.424... |
| 1.200 | Minor Third | 1, 1.2, 1.44, 1.728... |
| 1.250 | Major Third | 1, 1.25, 1.563, 1.953... |
| 1.333 | Perfect Fourth | 1, 1.333, 1.777, 2.369... |
| 1.500 | Perfect Fifth | 1, 1.5, 2.25, 3.375... |

```css
/* Escala com razão 1.25 (Major Third) — equilibrada para interfaces */
:root {
  --tamanho-xs:   0.64rem;   /* 0.8 × 0.8rem */
  --tamanho-sm:   0.8rem;    /* base × 0.8 */
  --tamanho-base: 1rem;      /* 16px — base da escala */
  --tamanho-md:   1.25rem;   /* base × 1.25 */
  --tamanho-lg:   1.563rem;  /* base × 1.25² */
  --tamanho-xl:   1.953rem;  /* base × 1.25³ */
  --tamanho-2xl:  2.441rem;  /* base × 1.25⁴ */
  --tamanho-3xl:  3.052rem;  /* base × 1.25⁵ */
}
```

> **Ferramenta:** [Modular Scale](https://www.modularscale.com) e [Utopia](https://utopia.fyi/type/calculator/) permitem gerar e visualizar escalas tipográficas modulares interativamente.

### 11.4.2 — Tokens de fonte

```css
:root {
  /* Famílias */
  --fonte-sem-serifa: 'Inter', 'Helvetica Neue', Arial, sans-serif;
  --fonte-serifa:     'Merriweather', Georgia, 'Times New Roman', serif;
  --fonte-codigo:     'Fira Code', 'Cascadia Code', Consolas, monospace;

  /* Tamanhos — escala sistemática */
  --fonte-xs:   clamp(0.64rem,  0.6rem + 0.2vw,  0.72rem);
  --fonte-sm:   clamp(0.8rem,   0.75rem + 0.25vw, 0.875rem);
  --fonte-base: clamp(1rem,     0.95rem + 0.25vw, 1.0625rem);
  --fonte-md:   clamp(1.125rem, 1rem + 0.625vw,   1.375rem);
  --fonte-lg:   clamp(1.25rem,  1rem + 1.25vw,    1.75rem);
  --fonte-xl:   clamp(1.5rem,   1rem + 2.5vw,     2.25rem);
  --fonte-2xl:  clamp(1.875rem, 1rem + 4.375vw,   3rem);
  --fonte-3xl:  clamp(2.25rem,  1rem + 6.25vw,    3.75rem);

  /* Pesos */
  --peso-fino:     100;
  --peso-leve:     300;
  --peso-regular:  400;
  --peso-medio:    500;
  --peso-semibold: 600;
  --peso-bold:     700;
  --peso-extrabold: 800;
  --peso-black:    900;

  /* Alturas de linha */
  --linha-apertada:   1.1;
  --linha-compacta:   1.3;
  --linha-normal:     1.5;
  --linha-relaxada:   1.6;
  --linha-solta:      1.8;

  /* Espaçamento entre letras */
  --tracking-apertado: -0.05em;
  --tracking-normal:    0;
  --tracking-largo:     0.05em;
  --tracking-muito-largo: 0.1em;
}
```

### 11.4.3 — Escala tipográfica fluida com `clamp()`

A integração de `clamp()` nos tokens de fonte (demonstrada acima) cria uma tipografia que escala suavemente entre dispositivos — sem media queries para tamanhos de fonte. Os valores de `clamp()` seguem a lógica:

```
clamp(tamanho-mobile, valor-fluido, tamanho-desktop)
```

O valor fluido é calculado para que a transição entre os extremos seja linear e proporcional ao viewport. A ferramenta [Utopia](https://utopia.fyi) automatiza esses cálculos.

### 11.4.4 — Hierarquia tipográfica aplicada

Com os tokens definidos, a hierarquia tipográfica da aplicação é implementada de forma centralizada:

```css
/* Estilos base usando tokens semânticos */
body {
  font-family: var(--fonte-sem-serifa);
  font-size: var(--fonte-base);
  font-weight: var(--peso-regular);
  line-height: var(--linha-relaxada);
  color: var(--cor-texto-padrao);
}

h1 {
  font-size: var(--fonte-3xl);
  font-weight: var(--peso-bold);
  line-height: var(--linha-apertada);
  letter-spacing: var(--tracking-apertado);
  color: var(--cor-texto-padrao);
}

h2 {
  font-size: var(--fonte-2xl);
  font-weight: var(--peso-bold);
  line-height: var(--linha-compacta);
}

h3 {
  font-size: var(--fonte-xl);
  font-weight: var(--peso-semibold);
  line-height: var(--linha-compacta);
}

h4 {
  font-size: var(--fonte-lg);
  font-weight: var(--peso-semibold);
}

p {
  font-size: var(--fonte-base);
  line-height: var(--linha-relaxada);
  max-width: 70ch; /* limita a largura de leitura: ~70 caracteres */
}

small, .caption {
  font-size: var(--fonte-sm);
  color: var(--cor-texto-secundario);
}

code {
  font-family: var(--fonte-codigo);
  font-size: 0.9em;
  background-color: var(--cor-fundo-sutil);
  padding: 0.15em 0.4em;
  border-radius: var(--raio-sm);
}
```

---

## 11.5 — Espaçamento sistemático

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 11.5.1 — Sistemas de espaçamento: base-4 e base-8

Um sistema de espaçamento consistente é o que diferencia uma interface visualmente coerente de uma coleção de elementos com espaçamentos arbitrários. Os dois sistemas mais adotados na indústria são baseados em múltiplos de **4px** ou **8px**.

**Sistema base-4:** todos os valores de espaçamento são múltiplos de 4px (0.25rem). Oferece granularidade maior — adequado para interfaces densas como dashboards corporativos.

**Sistema base-8:** todos os valores são múltiplos de 8px (0.5rem). Mais restritivo e opinativo — produz interfaces com ritmo visual mais pronunciado.

```css
/* Sistema base-4 (em rem com base 16px) */
:root {
  --espaco-1:  0.25rem;  /*  4px */
  --espaco-2:  0.5rem;   /*  8px */
  --espaco-3:  0.75rem;  /* 12px */
  --espaco-4:  1rem;     /* 16px */
  --espaco-5:  1.25rem;  /* 20px */
  --espaco-6:  1.5rem;   /* 24px */
  --espaco-8:  2rem;     /* 32px */
  --espaco-10: 2.5rem;   /* 40px */
  --espaco-12: 3rem;     /* 48px */
  --espaco-16: 4rem;     /* 64px */
  --espaco-20: 5rem;     /* 80px */
  --espaco-24: 6rem;     /* 96px */
  --espaco-32: 8rem;     /* 128px */
}
```

### 11.5.2 — Tokens de espaçamento e sua aplicação

Com a escala primitiva definida, os tokens semânticos de espaçamento mapeiam intenções de uso:

```css
:root {
  /* Espaçamentos de componente */
  --padding-btn-v:      var(--espaco-2);
  --padding-btn-h:      var(--espaco-4);
  --padding-btn-v-sm:   var(--espaco-1);
  --padding-btn-h-sm:   var(--espaco-3);
  --padding-btn-v-lg:   var(--espaco-3);
  --padding-btn-h-lg:   var(--espaco-6);

  --padding-card:       var(--espaco-6);
  --padding-card-sm:    var(--espaco-4);

  --padding-input-v:    var(--espaco-2);
  --padding-input-h:    var(--espaco-3);

  /* Espaçamentos de layout */
  --gap-componentes:    var(--espaco-4);
  --gap-secoes:         var(--espaco-12);
  --padding-pagina-v:   var(--espaco-8);
  --padding-pagina-h:   var(--espaco-6);

  /* Espaçamentos de texto */
  --margem-paragrafo:   var(--espaco-4);
  --margem-titulo:      var(--espaco-6);
}
```

### 11.5.3 — Espaçamento fluido com `clamp()`

Assim como a tipografia, o espaçamento pode ser fluido — escalando entre valores mínimos e máximos conforme o viewport:

```css
:root {
  /* Espaçamentos fluidos — escalam com o viewport */
  --espaco-fluido-sm:  clamp(var(--espaco-4),  3vw, var(--espaco-6));
  --espaco-fluido-md:  clamp(var(--espaco-6),  5vw, var(--espaco-12));
  --espaco-fluido-lg:  clamp(var(--espaco-8),  8vw, var(--espaco-20));
  --espaco-fluido-xl:  clamp(var(--espaco-12), 10vw, var(--espaco-32));
}

/* Aplicação: seções da página com espaçamento fluido */
.secao {
  padding-top:    var(--espaco-fluido-lg);
  padding-bottom: var(--espaco-fluido-lg);
  padding-left:   var(--espaco-fluido-md);
  padding-right:  var(--espaco-fluido-md);
}
```

---

## 11.6 — Componentização

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 11.6.1 — O que é um componente CSS

No contexto de um Design System baseado em CSS puro, um **componente** é um conjunto de regras CSS que implementam um padrão de interface reutilizável — definido por uma classe base, variantes opcionais e estados interativos. Cada componente consome tokens de design em vez de valores hardcoded, garantindo que mudanças nos tokens se propagam automaticamente.

A estrutura de um componente segue o padrão:
- **Classe base:** `(.btn)` — estilos compartilhados por todas as variantes
- **Classes de variante:** `(.btn--primario, .btn--secundario)` — diferenciações visuais
- **Classes de tamanho:** `(.btn--sm, .btn--lg)` — escalas de dimensão
- **Pseudo-classes de estado:** `(:hover, :focus-visible, :active, :disabled)` — comportamento interativo

### 11.6.2 — Botões: variantes, estados e tokens

O botão é o componente mais fundamental de qualquer sistema — e o mais revelador de quão bem o sistema está estruturado:

```css
/* ─── Componente: Button ─────────────────────────── */

.btn {
  /* Layout */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--espaco-2);

  /* Dimensões */
  padding: var(--padding-btn-v) var(--padding-btn-h);

  /* Tipografia */
  font-family: var(--fonte-sem-serifa);
  font-size: var(--fonte-base);
  font-weight: var(--peso-semibold);
  line-height: 1;
  white-space: nowrap;

  /* Aparência */
  border: 2px solid transparent;
  border-radius: var(--raio-md);
  cursor: pointer;

  /* Interação */
  transition:
    background-color var(--transicao-padrao),
    color var(--transicao-padrao),
    border-color var(--transicao-padrao),
    box-shadow var(--transicao-padrao),
    transform var(--transicao-rapida);

  /* Acessibilidade */
  text-decoration: none;
  user-select: none;
}

/* Foco acessível: visível para navegação por teclado */
.btn:focus-visible {
  outline: 3px solid var(--cor-borda-foco);
  outline-offset: 2px;
}

/* Estado desabilitado */
.btn:disabled,
.btn[aria-disabled="true"] {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

/* ── Variantes ─── */

.btn--primario {
  background-color: var(--cor-primaria);
  color: var(--cor-texto-inverso);
}

.btn--primario:hover:not(:disabled) {
  background-color: var(--cor-primaria-hover);
}

.btn--primario:active:not(:disabled) {
  background-color: var(--cor-primaria-ativa);
  transform: translateY(1px);
}

.btn--secundario {
  background-color: transparent;
  color: var(--cor-primaria);
  border-color: var(--cor-primaria);
}

.btn--secundario:hover:not(:disabled) {
  background-color: var(--cor-primaria-suave);
}

.btn--fantasma {
  background-color: transparent;
  color: var(--cor-texto-padrao);
}

.btn--fantasma:hover:not(:disabled) {
  background-color: var(--cor-fundo-sutil);
}

.btn--perigo {
  background-color: var(--cor-erro);
  color: var(--cor-texto-inverso);
}

.btn--perigo:hover:not(:disabled) {
  background-color: hsl(0, 74%, 37%);
}

/* ── Tamanhos ─── */

.btn--sm {
  padding: var(--padding-btn-v-sm) var(--padding-btn-h-sm);
  font-size: var(--fonte-sm);
  border-radius: var(--raio-sm);
}

.btn--lg {
  padding: var(--padding-btn-v-lg) var(--padding-btn-h-lg);
  font-size: var(--fonte-md);
  border-radius: var(--raio-lg);
}

/* ── Largura total ─── */

.btn--bloco {
  width: 100%;
}
```

**Uso em HTML:**

```html
<!-- Variantes -->
<button class="btn btn--primario" type="button">Salvar</button>
<button class="btn btn--secundario" type="button">Cancelar</button>
<button class="btn btn--fantasma" type="button">Ver mais</button>
<button class="btn btn--perigo" type="button">Excluir</button>

<!-- Tamanhos -->
<button class="btn btn--primario btn--sm" type="button">Pequeno</button>
<button class="btn btn--primario" type="button">Médio (padrão)</button>
<button class="btn btn--primario btn--lg" type="button">Grande</button>

<!-- Desabilitado (acessível) -->
<button class="btn btn--primario" type="button" disabled aria-disabled="true">
  Indisponível
</button>

<!-- Com ícone -->
<button class="btn btn--primario" type="button">
  <svg aria-hidden="true" focusable="false" width="16" height="16">...</svg>
  Enviar
</button>
```

### 11.6.3 — Cards: estrutura, variantes e composição

```css
/* ─── Componente: Card ───────────────────────────── */

.card {
  background-color: var(--cor-fundo-card);
  border: var(--card-borda);
  border-radius: var(--raio-lg);
  box-shadow: var(--sombra-sm);
  overflow: hidden;

  /* Card como flex container vertical */
  display: flex;
  flex-direction: column;
}

/* Regiões do card */
.card__imagem {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

.card__corpo {
  flex: 1;
  padding: var(--padding-card);
  display: flex;
  flex-direction: column;
  gap: var(--espaco-3);
}

.card__titulo {
  font-size: var(--fonte-lg);
  font-weight: var(--peso-semibold);
  line-height: var(--linha-compacta);
  color: var(--cor-texto-padrao);
  margin: 0;
}

.card__descricao {
  font-size: var(--fonte-base);
  color: var(--cor-texto-secundario);
  line-height: var(--linha-relaxada);
  margin: 0;
  flex: 1; /* empurra o rodapé para baixo */
}

.card__rodape {
  padding: var(--espaco-4) var(--padding-card);
  border-top: 1px solid var(--cor-borda-sutil);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--espaco-2);
}

/* ── Variantes ─── */

/* Card interativo: hover e foco */
.card--interativo {
  cursor: pointer;
  transition: box-shadow var(--transicao-padrao), transform var(--transicao-padrao);
  text-decoration: none;
  color: inherit;
}

.card--interativo:hover {
  box-shadow: var(--sombra-lg);
  transform: translateY(-2px);
}

.card--interativo:focus-visible {
  outline: 3px solid var(--cor-borda-foco);
  outline-offset: 2px;
}

/* Card horizontal: imagem ao lado */
.card--horizontal {
  flex-direction: row;
}

.card--horizontal .card__imagem {
  width: 200px;
  aspect-ratio: auto;
  height: 100%;
  flex-shrink: 0;
}

/* Card de destaque */
.card--destaque {
  border-top: 4px solid var(--cor-primaria);
}

/* Card sem borda */
.card--sem-sombra {
  box-shadow: none;
}
```

### 11.6.4 — Inputs e formulários com tokens

```css
/* ─── Componente: Form Field ─────────────────────── */

.campo {
  display: flex;
  flex-direction: column;
  gap: var(--espaco-1);
}

.campo__label {
  font-size: var(--fonte-sm);
  font-weight: var(--peso-medio);
  color: var(--cor-texto-padrao);
}

.campo__label--obrigatorio::after {
  content: " *";
  color: var(--cor-erro);
  aria-hidden: true;
}

.campo__input {
  width: 100%;
  padding: var(--padding-input-v) var(--padding-input-h);
  font-family: var(--fonte-sem-serifa);
  font-size: var(--fonte-base);
  color: var(--cor-texto-padrao);
  background-color: var(--cor-fundo-card);
  border: 1px solid var(--cor-borda-forte);
  border-radius: var(--raio-md);
  transition: border-color var(--transicao-rapida), box-shadow var(--transicao-rapida);
  appearance: none;
}

.campo__input::placeholder {
  color: var(--cor-texto-sutil);
}

.campo__input:hover:not(:disabled) {
  border-color: var(--cor-primaria);
}

.campo__input:focus {
  outline: none;
  border-color: var(--cor-borda-foco);
  box-shadow: 0 0 0 3px hsl(from var(--cor-borda-foco) h s l / 0.2);
}

/* Estado de erro */
.campo--erro .campo__input {
  border-color: var(--cor-erro);
}

.campo--erro .campo__input:focus {
  box-shadow: 0 0 0 3px hsl(from var(--cor-erro) h s l / 0.2);
}

.campo__mensagem-erro {
  font-size: var(--fonte-sm);
  color: var(--cor-erro-texto);
  display: flex;
  align-items: center;
  gap: var(--espaco-1);
}

/* Estado de sucesso */
.campo--sucesso .campo__input {
  border-color: var(--cor-sucesso);
}

.campo__mensagem-sucesso {
  font-size: var(--fonte-sm);
  color: var(--cor-sucesso-texto);
}

/* Dica de ajuda */
.campo__dica {
  font-size: var(--fonte-sm);
  color: var(--cor-texto-secundario);
}

/* Campo desabilitado */
.campo__input:disabled {
  background-color: var(--cor-fundo-sutil);
  color: var(--cor-texto-desabilitado);
  cursor: not-allowed;
  border-color: var(--cor-borda-padrao);
}
```

**Uso em HTML:**

```html
<!-- Campo padrão -->
<div class="campo">
  <label class="campo__label campo__label--obrigatorio" for="nome">
    Nome completo
  </label>
  <input
    class="campo__input"
    type="text"
    id="nome"
    name="nome"
    required
    aria-required="true"
  />
</div>

<!-- Campo com erro -->
<div class="campo campo--erro">
  <label class="campo__label" for="email">E-mail</label>
  <input
    class="campo__input"
    type="email"
    id="email"
    name="email"
    aria-invalid="true"
    aria-describedby="email-erro"
  />
  <p class="campo__mensagem-erro" id="email-erro" role="alert">
    ⚠ Informe um e-mail válido.
  </p>
</div>

<!-- Campo com dica -->
<div class="campo">
  <label class="campo__label" for="senha">Senha</label>
  <input
    class="campo__input"
    type="password"
    id="senha"
    name="senha"
    aria-describedby="senha-dica"
  />
  <p class="campo__dica" id="senha-dica">
    Mínimo de 8 caracteres, incluindo letras e números.
  </p>
</div>
```

### 11.6.5 — Layouts reutilizáveis: container, grid e stack

Além de componentes de interface, um Design System inclui **primitivas de layout** — padrões estruturais reutilizáveis:

```css
/* ─── Primitiva: Container ───────────────────────── */

.container {
  width: 100%;
  max-width: 1200px;
  margin-inline: auto;
  padding-inline: var(--espaco-fluido-md);
}

.container--estreito { max-width: 800px; }
.container--largo    { max-width: 1400px; }
.container--fluido   { max-width: none; }

/* ─── Primitiva: Grid ────────────────────────────── */

.grid {
  display: grid;
  gap: var(--gap-componentes);
}

.grid--2 { grid-template-columns: repeat(2, 1fr); }
.grid--3 { grid-template-columns: repeat(3, 1fr); }
.grid--4 { grid-template-columns: repeat(4, 1fr); }

/* Grid responsivo sem media queries */
.grid--auto {
  grid-template-columns: repeat(auto-fit, minmax(min(280px, 100%), 1fr));
}

@media (max-width: 768px) {
  .grid--2,
  .grid--3,
  .grid--4 {
    grid-template-columns: 1fr;
  }
}

/* ─── Primitiva: Stack ───────────────────────────── */
/* Stack: empilha elementos verticalmente com espaçamento consistente */

.stack {
  display: flex;
  flex-direction: column;
}

.stack--xs  { gap: var(--espaco-1); }
.stack--sm  { gap: var(--espaco-2); }
.stack--md  { gap: var(--espaco-4); }  /* padrão */
.stack--lg  { gap: var(--espaco-8); }
.stack--xl  { gap: var(--espaco-16); }

/* ─── Primitiva: Cluster ─────────────────────────── */
/* Cluster: agrupa itens inline com wrap e espaçamento */

.cluster {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-3);
  align-items: center;
}

/* ─── Primitiva: Sidebar Layout ─────────────────── */
/* Sidebar: dois elementos lado a lado onde um é fixo e o outro cresce */

.com-sidebar {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-8);
}

.com-sidebar > :first-child {
  flex-basis: 300px;  /* largura da sidebar */
  flex-grow: 1;
}

.com-sidebar > :last-child {
  flex-basis: 0;
  flex-grow: 999;    /* cresce muito mais que a sidebar */
  min-width: 50%;    /* não fica menor que 50% */
}
```

---

## 11.7 — Organização e manutenibilidade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 11.7.1 — Estrutura de arquivos para um mini Design System

```
css/
├── tokens/
│   ├── _primitivos.css     /* Escalas brutas: cores, tamanhos, espaços */
│   ├── _semanticos.css     /* Tokens semânticos: cor-primaria, fonte-titulo... */
│   └── _temas.css          /* Tema claro, escuro, high-contrast */
│
├── base/
│   ├── _reset.css          /* Normalização cross-browser */
│   └── _tipografia.css     /* Estilos base de h1-h6, p, a, code... */
│
├── layout/
│   ├── _container.css      /* .container e variantes */
│   ├── _grid.css           /* .grid e variantes */
│   └── _stack.css          /* .stack, .cluster, .com-sidebar */
│
├── components/
│   ├── _button.css         /* .btn e variantes */
│   ├── _card.css           /* .card e variantes */
│   ├── _form.css           /* .campo, .campo__input... */
│   ├── _badge.css          /* .badge */
│   ├── _alert.css          /* .alerta */
│   └── _nav.css            /* .nav, .navbar */
│
├── utilities/
│   └── _utilities.css      /* Classes utilitárias: .sr-only, .truncado... */
│
└── main.css                /* Arquivo de entrada: importa tudo */
```

**`main.css` — arquivo de entrada:**

```css
/* ─── Tokens ─── */
@import url('tokens/_primitivos.css');
@import url('tokens/_semanticos.css');
@import url('tokens/_temas.css');

/* ─── Base ─── */
@import url('base/_reset.css');
@import url('base/_tipografia.css');

/* ─── Layout ─── */
@import url('layout/_container.css');
@import url('layout/_grid.css');
@import url('layout/_stack.css');

/* ─── Componentes ─── */
@import url('components/_button.css');
@import url('components/_card.css');
@import url('components/_form.css');
@import url('components/_badge.css');
@import url('components/_alert.css');
@import url('components/_nav.css');

/* ─── Utilitários ─── */
@import url('utilities/_utilities.css');
```

### 11.7.2 — Camadas CSS com `@layer`

A regra `@layer` (CSS Cascade Layers), suportada em todos os navegadores modernos desde 2022, permite organizar explicitamente as camadas de especificidade do CSS — eliminando conflitos sem recorrer a `!important`:

```css
/* Declaração da ordem das camadas — feita uma vez, no topo do main.css */
@layer reset, tokens, base, layout, componentes, utilitarios;

/* Cada camada tem sua especificidade isolada das demais */
/* A ordem de declaração define a prioridade: utilitarios > componentes > ... */

@layer reset {
  *,
  *::before,
  *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }
}

@layer tokens {
  :root {
    --cor-primaria: var(--azul-700);
    --fonte-base: 1rem;
    /* ... */
  }
}

@layer base {
  body {
    font-family: var(--fonte-sem-serifa);
    color: var(--cor-texto-padrao);
  }

  h1 { font-size: var(--fonte-3xl); }
}

@layer componentes {
  .btn {
    /* especificidade: (0, 1, 0) dentro da camada componentes */
    padding: var(--padding-btn-v) var(--padding-btn-h);
  }

  .btn--primario {
    background-color: var(--cor-primaria);
  }
}

@layer utilitarios {
  /* Utilitários sempre vencem componentes — sem !important */
  .oculto      { display: none; }
  .sr-only     { /* visually hidden */ }
  .truncado    { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .texto-centro { text-align: center; }
}
```

**Por que `@layer` é importante para sistemas:**

Sem `@layer`, a especificidade dos seletores determina qual regra prevalece — e isso frequentemente exige `!important` para que utilitários sobrescrevam componentes. Com `@layer`, a ordem de prioridade é declarada explicitamente: a camada `utilitarios` sempre vence `componentes`, independente da especificidade dos seletores dentro de cada camada.

> **Referência:** [MDN — @layer](https://developer.mozilla.org/en-US/docs/Web/CSS/@layer)

### 11.7.3 — Documentação mínima de componentes

Um Design System sem documentação é apenas código. A documentação mínima de cada componente deve incluir:

**1. Propósito:** o que o componente é e quando deve ser usado.

**2. Variantes:** todas as variações disponíveis com exemplos visuais.

**3. Estados:** como o componente se comporta em hover, foco, ativo, desabilitado e erro.

**4. Tokens utilizados:** quais variáveis CSS o componente consome — facilitando a customização.

**5. Exemplos de uso correto e incorreto:** o que se deve e o que não se deve fazer.

**6. Requisitos de acessibilidade:** atributos ARIA necessários, navegação por teclado esperada.

Para projetos acadêmicos e portfólios, uma documentação em formato HTML estático já é suficiente — cada componente exibido com seus exemplos de código e notas de uso. Ferramentas como **Storybook** ([storybook.js.org](https://storybook.js.org)) automatizam a geração dessa documentação para componentes JavaScript, mas estão fora do escopo desta disciplina.

**Referências:**
- [MDN — CSS Custom Properties](https://developer.mozilla.org/pt-BR/docs/Web/CSS/Using_CSS_custom_properties)
- [W3C — CSS Cascading and Inheritance Level 5](https://www.w3.org/TR/css-cascade-5/)
- [Design Tokens Community Group](https://www.w3.org/community/design-tokens/)
- [Storybook — Component documentation](https://storybook.js.org)
- [Every Layout — Layout primitives](https://every-layout.dev)
- [Open Props — Design tokens open source](https://open-props.style)

---

#### **Atividades — Capítulo 11**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Qual é a diferença entre um token primitivo e um token semântico em um Design System?</p>
  <button data-option="a">Tokens primitivos são definidos em JavaScript; tokens semânticos em CSS.</button>
  <button data-option="b">Tokens primitivos têm nomes descritivos como <code>--azul</code>; tokens semânticos são valores numéricos.</button>
  <button data-option="c">Tokens primitivos são valores brutos sem intenção de uso (<code>--azul-700</code>); tokens semânticos referenciam primitivos e atribuem propósito de interface (<code>--cor-primaria: var(--azul-700)</code>).</button>
  <button data-option="d">Não há diferença funcional — a distinção é apenas organizacional.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Por que a arquitetura de tokens semânticos facilita a implementação de tema escuro?</p>
  <button data-option="a">Porque tokens semânticos são automaticamente invertidos pelo navegador em dark mode.</button>
  <button data-option="b">Porque os componentes consomem tokens semânticos (<code>--cor-fundo-card</code>) em vez de valores diretos — redefinir apenas esses tokens no escopo do tema escuro propaga a mudança a todos os componentes sem alterar nenhum deles individualmente.</button>
  <button data-option="c">Porque tokens semânticos têm especificidade mais alta que valores hardcoded.</button>
  <button data-option="d">Porque a media query <code>prefers-color-scheme</code> só funciona com variáveis CSS.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual é a vantagem do uso de <code>@layer</code> em comparação com a arquitetura CSS tradicional sem camadas?</p>
  <button data-option="a"><code>@layer</code> melhora o desempenho de renderização ao paralelizar o processamento do CSS.</button>
  <button data-option="b"><code>@layer</code> permite usar variáveis CSS em media queries.</button>
  <button data-option="c"><code>@layer</code> elimina a necessidade de especificidade nos seletores.</button>
  <button data-option="d"><code>@layer</code> permite declarar explicitamente a ordem de prioridade entre camadas (reset, base, componentes, utilitários), eliminando conflitos de especificidade sem recorrer a <code>!important</code>.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir um mini Design System com: arquivo de tokens em três camadas (primitivos, semânticos, componente), implementação do componente `.btn` com ao menos três variantes e todos os estados interativos, implementação do componente `.card` com variante horizontal, tema escuro via `prefers-color-scheme`, e organização em `@layer`. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 10 — Design Responsivo](10-responsividade.md)
[:material-arrow-right: Ir ao Capítulo 12 — Framework CSS: Tailwind](12-tailwind.md)
