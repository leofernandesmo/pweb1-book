# Capítulo 18 — Projeto Final

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 18.1 — Especificação e planejamento

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O Projeto Final é a síntese de tudo que foi estudado ao longo do ano letivo. Ele não é um exercício isolado — é a demonstração de que o estudante é capaz de **integrar** HTML semântico, CSS moderno, JavaScript e consumo de APIs em uma aplicação front-end coesa, funcional e acessível.

O projeto é desenvolvido em três sprints ao longo das semanas 37 a 40, com checkpoints de revisão ao final de cada sprint. Esta estrutura simula o desenvolvimento iterativo usado em equipes de software reais.

### 18.1.1 — Escopo do projeto: o que deve ser entregue

A aplicação final deve ser uma **SPA (Single Page Application)** que consome pelo menos uma API pública e oferece ao usuário as seguintes funcionalidades:

**Funcionalidades obrigatórias:**

| # | Funcionalidade | Conceitos envolvidos |
|---|---|---|
| 1 | Listagem de dados da API com filtro e busca | Fetch, renderização dinâmica, debounce |
| 2 | Tela de detalhe de um item | Roteamento por hash, parâmetros de URL |
| 3 | Formulário com validação JavaScript completa | Validação de múltiplos tipos de campos |
| 4 | Navegação entre telas sem recarregar a página | Hash routing |
| 5 | Estados de UI: carregando, sucesso, erro, vazio | Gestão de estados assíncronos |
| 6 | Design responsivo (mobile-first) | Flexbox, Grid, media queries |
| 7 | Acessibilidade mínima | ARIA, navegação por teclado, contraste |
| 8 | Persistência local de pelo menos um dado | localStorage |

**Funcionalidades opcionais (bônus):**

- Tema claro/escuro com toggle e persistência
- Paginação na listagem
- Busca com AbortController (sem race condition)
- Animações e transições com CSS
- Componentes reutilizáveis com `@apply` do Tailwind ou CSS customizado
- Deploy no GitHub Pages

### 18.1.2 — Requisitos técnicos

**HTML:**
- Marcação semântica com os elementos corretos (`<main>`, `<nav>`, `<article>`, `<section>`, `<header>`, `<footer>`)
- Meta tag `viewport` e `charset`
- Atributos `alt` em todas as imagens
- `<title>` descritivo
- Formulários com `<label>` associados a todos os campos

**CSS:**
- Sistema de variáveis CSS com tokens de design (cores, tipografia, espaçamento)
- Layout responsivo mobile-first com pelo menos dois breakpoints
- Reset com `box-sizing: border-box`
- Sem uso de `!important` indiscriminado
- Organização em seções comentadas

**JavaScript:**
- Código organizado em módulos ES6 (`import`/`export`)
- Camada de serviços separada da camada de UI
- Tratamento de erros em todas as operações assíncronas
- Sem uso de `var`; uso consciente de `const` e `let`
- Sem manipulação de DOM dentro de serviços
- Nenhuma chave de API sensível exposta no código versionado

**Acessibilidade:**
- Score ≥ 80 no Lighthouse
- Navegação completa por teclado
- Contraste mínimo 4,5:1 para texto normal
- Atributos ARIA nos componentes interativos (modal, accordion, abas)

### 18.1.3 — Escolha da API pública

A escolha da API define o domínio da aplicação. Critérios a considerar:

```
✅ APIs recomendadas para o projeto:

API             Domínio         Auth    Docs
─────────────────────────────────────────────────
OMDb            Filmes/séries   Key*    omdbapi.com
Open Library    Livros          Não     openlibrary.org/developers
PokéAPI         Pokémon         Não     pokeapi.co
Rick and Morty  Série animada   Não     rickandmortyapi.com
GitHub          Repositórios    Não**   docs.github.com/rest
OpenWeather     Clima           Key*    openweathermap.org/api
TheMealDB       Receitas        Não     themealdb.com/api.php
NewsAPI         Notícias        Key*    newsapi.org
IBGE + ViaCEP   Dados BR        Não     (combinação)

* Key gratuita com cadastro simples
** Sem autenticação para leitura básica (limite de req/h)
```

> **Imagem sugerida:** capturas de tela das documentações das APIs recomendadas, mostrando o endpoint de listagem e um exemplo de resposta JSON — para que os alunos possam comparar o formato dos dados antes de escolher.
>
> *(imagem será adicionada posteriormente)*

### 18.1.4 — Prototipação: wireframes

Antes de escrever uma linha de código, o projeto deve ser prototipado. Wireframes evitam retrabalho e forçam decisões de layout antes que elas sejam caras de mudar.

**Telas mínimas a prototipar:**

```
┌─────────────────────────────┐   ┌─────────────────────────────┐
│  Tela 1: Listagem           │   │  Tela 2: Detalhe            │
│                             │   │                             │
│  [Header/Nav]               │   │  [← Voltar]                 │
│                             │   │                             │
│  [Busca] [Filtros]          │   │  [Imagem grande]            │
│                             │   │  [Título]                   │
│  [Card] [Card] [Card]       │   │  [Descrição]                │
│  [Card] [Card] [Card]       │   │  [Detalhes]                 │
│                             │   │  [Ação]                     │
│  [Paginação]                │   │                             │
│                             │   │                             │
│  [Footer]                   │   │  [Footer]                   │
└─────────────────────────────┘   └─────────────────────────────┘

┌─────────────────────────────┐
│  Tela 3: Formulário         │
│                             │
│  [Campo 1]                  │
│  [Campo 2]                  │
│  [Campo 3 — select]         │
│  [Checkbox]                 │
│  [Botão Enviar]             │
│                             │
└─────────────────────────────┘
```

Ferramentas gratuitas para wireframes: papel e caneta, [Excalidraw](https://excalidraw.com), [Figma](https://figma.com) (plano gratuito), [draw.io](https://draw.io).

### 18.1.5 — Estrutura de arquivos e setup inicial

```
projeto-final/
├── index.html
├── README.md
├── .gitignore
├── config.example.js     ← modelo de configuração (sem chaves reais)
│
├── css/
│   ├── tokens.css        ← variáveis CSS (cores, tipografia, espaçamento)
│   ├── reset.css         ← reset + base
│   ├── components.css    ← componentes reutilizáveis
│   ├── pages.css         ← estilos específicos de páginas
│   └── utilities.css     ← classes utilitárias
│
└── js/
    ├── app.js            ← entrada + inicialização do router
    ├── router.js         ← roteamento por hash
    ├── store.js          ← estado global (opcional)
    ├── utils.js          ← funções utilitárias (debounce, formatadores, etc.)
    │
    ├── services/
    │   ├── api.js        ← cliente HTTP genérico
    │   └── [dominio].js  ← serviço específico (filmes.js, livros.js...)
    │
    ├── components/
    │   ├── modal.js
    │   ├── paginacao.js
    │   └── notificacao.js
    │
    └── pages/
        ├── listagem.js
        ├── detalhe.js
        └── formulario.js
```

**Setup inicial — `index.html`:**

```html
<!DOCTYPE html>
<html lang="pt-BR" data-tema="claro">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Descrição da sua aplicação" />
  <title>Nome do Projeto — Programação Web 1</title>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
        rel="stylesheet" />

  <link rel="stylesheet" href="css/tokens.css" />
  <link rel="stylesheet" href="css/reset.css" />
  <link rel="stylesheet" href="css/components.css" />
  <link rel="stylesheet" href="css/pages.css" />
  <link rel="stylesheet" href="css/utilities.css" />

  <script type="module" src="js/app.js" defer></script>
</head>
<body>

  <!-- Navegação principal -->
  <header class="site-header" role="banner">
    <nav class="navbar" aria-label="Navegação principal">
      <a href="#/" class="navbar__logo">
        <span>🎬 Nome do Projeto</span>
      </a>
      <ul class="navbar__links" role="list">
        <li><a href="#/" class="navbar__link">Início</a></li>
        <li><a href="#/favoritos" class="navbar__link">Favoritos</a></li>
        <li><a href="#/sobre" class="navbar__link">Sobre</a></li>
      </ul>
      <button type="button" id="btn-tema" class="btn-icone"
              aria-label="Alternar tema">🌙</button>
    </nav>
  </header>

  <!-- Conteúdo principal — atualizado pelo router -->
  <main id="app" tabindex="-1">
    <!-- Conteúdo dinâmico renderizado aqui -->
  </main>

  <footer class="site-footer" role="contentinfo">
    <p>Projeto Final — Programação Web 1 — IFAL © 2026</p>
  </footer>

</body>
</html>
```

---

## 18.2 — Sprint 1: estrutura HTML e dados

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

**Objetivo do Sprint 1:** ter a aplicação funcionando com dados reais da API, sem preocupação com CSS detalhado.

**Entregável:** página com listagem de dados da API renderizados no DOM, navegação entre listagem e detalhe funcionando via hash routing.

### 18.2.1 — Checklist Sprint 1

```
HTML:
□ index.html com estrutura semântica completa
□ Meta tags: charset, viewport, description, title
□ <header> com <nav> acessível
□ <main id="app"> como container do conteúdo dinâmico
□ <footer> com informações do projeto
□ Links de navegação apontando para rotas hash (#/, #/detalhe/:id)

JavaScript — Serviços:
□ services/api.js com função buscarDados() e construirUrl()
□ services/[dominio].js com funções listar() e buscarPorId()
□ Normalização dos dados da API para o formato interno
□ Tratamento de erros com classificação (rede vs HTTP)

JavaScript — Roteamento:
□ router.js implementado com on(), notFound() e inicializar()
□ Rotas configuradas em app.js: /, /[recurso], /[recurso]/:id
□ Navegação funcional entre listagem e detalhe

JavaScript — Páginas:
□ pages/listagem.js: renderiza lista de itens da API
□ pages/detalhe.js: renderiza detalhe de um item pelo ID
□ Estados de UI: carregando e erro implementados
□ Estado vazio tratado
```

### 18.2.2 — Template de serviço (ponto de partida)

```javascript
// services/filmes.js — adapte para sua API escolhida
import { buscarDados, construirUrl } from './api.js';

const BASE_URL = 'https://www.omdbapi.com';
const API_KEY  = 'SUA_CHAVE'; // mover para config.js em produção

export default class FilmesService {
  static async listar({ busca = 'Matrix', tipo = '', pagina = 1 } = {}) {
    const url = construirUrl(BASE_URL, {
      apikey: API_KEY,
      s:    busca || 'Matrix',
      type: tipo || undefined,
      page: pagina,
    });

    const dados = await buscarDados(url);

    if (dados.Response === 'False') {
      if (dados.Error === 'Movie not found!') return { dados: [], total: 0 };
      throw new Error(dados.Error);
    }

    return {
      dados:     dados.Search.map(normalizarFilme),
      total:     parseInt(dados.totalResults),
      porPagina: 10,
      pagina,
    };
  }

  static async buscarPorId(imdbId) {
    const url = construirUrl(BASE_URL, {
      apikey: API_KEY,
      i:    imdbId,
      plot: 'full',
    });

    const dados = await buscarDados(url);
    if (dados.Response === 'False') throw Object.assign(
      new Error(dados.Error), { status: 404 }
    );

    return normalizarFilmeDetalhe(dados);
  }
}

// Normalização — listagem
function normalizarFilme(f) {
  return {
    id:     f.imdbID,
    titulo: f.Title,
    ano:    f.Year,
    tipo:   f.Type,
    poster: f.Poster !== 'N/A' ? f.Poster : null,
  };
}

// Normalização — detalhe (mais campos)
function normalizarFilmeDetalhe(f) {
  return {
    ...normalizarFilme(f),
    diretor:    f.Director,
    elenco:     f.Actors,
    genero:     f.Genre,
    sinopse:    f.Plot,
    avaliacao:  parseFloat(f.imdbRating) || 0,
    duracao:    f.Runtime,
    idioma:     f.Language,
    premiacao:  f.Awards,
  };
}
```

### 18.2.3 — Checkpoint Sprint 1: revisão de código

Ao final do Sprint 1, o professor realizará uma revisão de código verificando:

- A API está sendo consumida corretamente?
- Os dados estão sendo normalizados antes de chegar na UI?
- O tratamento de erros está presente em todas as funções assíncronas?
- A navegação entre telas funciona?
- O código está organizado em módulos separados?

---

## 18.3 — Sprint 2: CSS e responsividade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

**Objetivo do Sprint 2:** aplicar o Design System e tornar a aplicação visualmente refinada e responsiva em todos os dispositivos.

**Entregável:** aplicação com visual completo, responsiva em mobile (375px), tablet (768px) e desktop (1024px+).

### 18.3.1 — Checklist Sprint 2

```
CSS — Tokens e base:
□ tokens.css: variáveis de cor (primária, secundária, feedback, superfície, texto)
□ tokens.css: escala tipográfica com clamp() nos títulos
□ tokens.css: escala de espaçamento (--espaco-1 a --espaco-16)
□ tokens.css: tokens de borda, sombra e transição
□ reset.css: box-sizing border-box universal
□ reset.css: reset de margens e paddings
□ reset.css: imagens responsivas (max-width: 100%)

CSS — Componentes:
□ Navbar: logo à esquerda, links à direita, responsiva (hamburguer em mobile)
□ Cards: imagem, corpo, rodapé; hover state; layout responsivo
□ Botões: pelo menos duas variantes com estados hover, focus-visible, disabled
□ Formulário: campos com labels, estados de erro e sucesso
□ Estados de UI: carregando (skeleton), erro, vazio
□ Modal (se implementado): overlay, caixa, animação de entrada

CSS — Layout responsivo:
□ Layout de listagem: 1 coluna mobile → 2 colunas tablet → 3+ desktop
□ Layout de detalhe: empilhado mobile → lado a lado desktop
□ Navbar: empilhada mobile → linha desktop
□ Imagens com object-fit: cover em containers de dimensão fixa
□ Pelo menos dois breakpoints com @media (min-width: ...)

CSS — Tema escuro (opcional):
□ @media (prefers-color-scheme: dark) com redefinição dos tokens semânticos
□ Toggle manual com [data-tema="escuro"] e persistência em localStorage
```

### 18.3.2 — Template de tokens (ponto de partida)

```css
/* css/tokens.css */

/* ── Primitivos ─────────────────────────────────── */
:root {
  /* Escala de azul */
  --azul-50:  #eff6ff;
  --azul-100: #dbeafe;
  --azul-500: #3b82f6;
  --azul-700: #1d4ed8;
  --azul-900: #1e3a8a;

  /* Escala de cinza */
  --cinza-50:  #f9fafb;
  --cinza-100: #f3f4f6;
  --cinza-200: #e5e7eb;
  --cinza-500: #6b7280;
  --cinza-700: #374151;
  --cinza-900: #111827;

  /* Feedback */
  --verde-600: #16a34a;
  --verde-50:  #f0fdf4;
  --vermelho-600: #dc2626;
  --vermelho-50:  #fef2f2;
  --amarelo-600: #d97706;
  --amarelo-50:  #fffbeb;
}

/* ── Semânticos — Tema Claro ────────────────────── */
:root,
[data-tema="claro"] {
  --cor-primaria:        var(--azul-700);
  --cor-primaria-hover:  var(--azul-900);
  --cor-primaria-suave:  var(--azul-50);

  --cor-fundo:           var(--cinza-50);
  --cor-fundo-card:      #ffffff;
  --cor-fundo-sutil:     var(--cinza-100);

  --cor-texto:           var(--cinza-900);
  --cor-texto-2:         var(--cinza-500);
  --cor-texto-inverso:   #ffffff;

  --cor-borda:           var(--cinza-200);
  --cor-borda-foco:      var(--azul-500);

  --cor-sucesso:         var(--verde-600);
  --cor-sucesso-fundo:   var(--verde-50);
  --cor-erro:            var(--vermelho-600);
  --cor-erro-fundo:      var(--vermelho-50);
  --cor-aviso:           var(--amarelo-600);
  --cor-aviso-fundo:     var(--amarelo-50);

  --sombra-sm: 0 1px 3px 0 rgb(0 0 0 / 0.1);
  --sombra-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  --sombra-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
}

/* ── Semânticos — Tema Escuro ───────────────────── */
@media (prefers-color-scheme: dark) {
  :root:not([data-tema="claro"]) {
    --cor-primaria:       var(--azul-500);
    --cor-primaria-hover: var(--azul-100);
    --cor-primaria-suave: #1e3a8a33;

    --cor-fundo:          #0f172a;
    --cor-fundo-card:     #1e293b;
    --cor-fundo-sutil:    #1e293b;

    --cor-texto:          #f1f5f9;
    --cor-texto-2:        #94a3b8;
    --cor-texto-inverso:  #0f172a;

    --cor-borda:          #334155;
    --cor-borda-foco:     var(--azul-500);

    --sombra-sm: 0 1px 3px 0 rgb(0 0 0 / 0.4);
    --sombra-md: 0 4px 6px -1px rgb(0 0 0 / 0.5);
    --sombra-lg: 0 10px 15px -3px rgb(0 0 0 / 0.6);
  }
}

[data-tema="escuro"] {
  --cor-primaria:       var(--azul-500);
  /* ... mesmo que o @media acima ... */
}

/* ── Tipografia ─────────────────────────────────── */
:root {
  --fonte-sans: 'Inter', system-ui, sans-serif;
  --fonte-mono: 'Fira Code', Consolas, monospace;

  --texto-xs:   clamp(0.75rem,  0.7rem  + 0.25vw, 0.8rem);
  --texto-sm:   clamp(0.875rem, 0.82rem + 0.25vw, 0.95rem);
  --texto-base: clamp(1rem,     0.95rem + 0.25vw, 1.0625rem);
  --texto-lg:   clamp(1.125rem, 1rem    + 0.5vw,  1.25rem);
  --texto-xl:   clamp(1.25rem,  1rem    + 1vw,    1.5rem);
  --texto-2xl:  clamp(1.5rem,   1rem    + 2vw,    2rem);
  --texto-3xl:  clamp(1.875rem, 1rem    + 3vw,    2.5rem);
}

/* ── Espaçamento ────────────────────────────────── */
:root {
  --espaco-1:  0.25rem;
  --espaco-2:  0.5rem;
  --espaco-3:  0.75rem;
  --espaco-4:  1rem;
  --espaco-6:  1.5rem;
  --espaco-8:  2rem;
  --espaco-12: 3rem;
  --espaco-16: 4rem;
}

/* ── Bordas e raios ─────────────────────────────── */
:root {
  --raio-sm:     4px;
  --raio-md:     8px;
  --raio-lg:     12px;
  --raio-xl:     16px;
  --raio-full:   9999px;
  --transicao:   200ms ease;
}
```

### 18.3.3 — Checkpoint Sprint 2: revisão de código

Ao final do Sprint 2, verificar:

- Os tokens CSS estão sendo usados de forma consistente (sem valores hardcoded em `components.css`)?
- O layout é responsivo? Testar em 375px, 768px, 1024px e 1440px.
- As imagens não transbordam seus containers?
- Os estados de foco são visíveis em todos os elementos interativos?
- O contraste mínimo de 4,5:1 está sendo respeitado? (Verificar com DevTools)

---

## 18.4 — Sprint 3: JavaScript e integração completa

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

**Objetivo do Sprint 3:** completar toda a interatividade, validação, acessibilidade e persistência de dados.

**Entregável:** aplicação completa e funcional, pronta para deploy e apresentação.

### 18.4.1 — Checklist Sprint 3

```
JavaScript — Interatividade:
□ Busca dinâmica com debounce (≥ 300ms)
□ Filtros que atualizam a listagem em tempo real
□ Paginação funcional (via URL hash ou estado)
□ AbortController na busca (sem race condition)
□ Formulário com validação de todos os campos obrigatórios
□ Modal de confirmação (se aplicável) com gestão de foco
□ Toggle de tema (claro/escuro) com persistência em localStorage
□ Pelo menos um item persistido em localStorage (favoritos, histórico, etc.)

JavaScript — Qualidade:
□ Todos os fetchs têm tratamento de erro com try/catch
□ Nenhum console.error ignorado sem feedback ao usuário
□ Sem referências a variáveis inexistentes (verificar DevTools → Console)
□ Código organizado em módulos ES6
□ Nenhuma lógica de negócio em event listeners (delegar para funções nomeadas)

Acessibilidade:
□ Lighthouse Accessibility ≥ 80
□ WAVE sem erros críticos (vermelho)
□ Todas as imagens têm alt descritivo ou alt="" (decorativas)
□ Todos os botões e links têm textos descritivos ou aria-label
□ Foco visível em todos os elementos interativos
□ Formulário com labels associados a todos os campos
□ Estados de loading anunciados com aria-live ou role="status"
□ Modal com gestão de foco (se implementado)
□ Navegação completa por Tab sem armadilhas de foco
```

### 18.4.2 — Implementando favoritos com localStorage

```javascript
// Funcionalidade de favoritos — persistência local
class Favoritos {
  static #CHAVE = 'app-favoritos';

  static listar() {
    return JSON.parse(localStorage.getItem(this.#CHAVE) || '[]');
  }

  static adicionar(item) {
    const lista = this.listar();
    if (!lista.find(f => f.id === item.id)) {
      lista.unshift({ ...item, adicionadoEm: new Date().toISOString() });
      localStorage.setItem(this.#CHAVE, JSON.stringify(lista));
      this.#notificar();
    }
  }

  static remover(id) {
    const lista = this.listar().filter(f => f.id !== id);
    localStorage.setItem(this.#CHAVE, JSON.stringify(lista));
    this.#notificar();
  }

  static ehFavorito(id) {
    return this.listar().some(f => f.id === id);
  }

  static toggle(item) {
    this.ehFavorito(item.id) ? this.remover(item.id) : this.adicionar(item);
    return this.ehFavorito(item.id);
  }

  static #notificar() {
    window.dispatchEvent(new CustomEvent('favoritos-atualizados', {
      detail: { total: this.listar().length }
    }));
  }
}

// Botão de favoritar em cards e detalhe
function criarBotaoFavorito(item) {
  const btn = document.createElement('button');
  btn.type = 'button';
  btn.className = 'btn-favorito';
  const isFav = Favoritos.ehFavorito(item.id);

  btn.innerHTML = isFav ? '❤️' : '🤍';
  btn.setAttribute('aria-label',
    isFav ? `Remover ${item.titulo} dos favoritos`
           : `Adicionar ${item.titulo} aos favoritos`
  );
  btn.setAttribute('aria-pressed', isFav ? 'true' : 'false');

  btn.addEventListener('click', (e) => {
    e.stopPropagation(); // evita navegar para o detalhe ao clicar
    const novoEstado = Favoritos.toggle(item);
    btn.innerHTML = novoEstado ? '❤️' : '🤍';
    btn.setAttribute('aria-pressed', novoEstado ? 'true' : 'false');
    btn.setAttribute('aria-label',
      novoEstado ? `Remover ${item.titulo} dos favoritos`
                 : `Adicionar ${item.titulo} aos favoritos`
    );
  });

  return btn;
}

// Atualizar badge de favoritos na navbar
window.addEventListener('favoritos-atualizados', (e) => {
  const badge = document.querySelector('#badge-favoritos');
  if (badge) {
    badge.textContent = e.detail.total || '';
    badge.hidden = e.detail.total === 0;
  }
});
```

### 18.4.3 — Toggle de tema com persistência

```javascript
// js/app.js — inicializar tema ao carregar
function inicializarTema() {
  const temaSalvo = localStorage.getItem('tema');
  const prefereEscuro = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const temaInicial = temaSalvo || (prefereEscuro ? 'escuro' : 'claro');

  document.documentElement.dataset.tema = temaInicial;
  atualizarBotaoTema(temaInicial);
}

function atualizarBotaoTema(tema) {
  const btn = document.getElementById('btn-tema');
  if (!btn) return;
  btn.textContent = tema === 'escuro' ? '☀️' : '🌙';
  btn.setAttribute('aria-label',
    tema === 'escuro' ? 'Mudar para tema claro' : 'Mudar para tema escuro'
  );
  btn.setAttribute('aria-pressed', tema === 'escuro' ? 'true' : 'false');
}

function alternarTema() {
  const temaAtual = document.documentElement.dataset.tema;
  const novoTema  = temaAtual === 'escuro' ? 'claro' : 'escuro';
  document.documentElement.dataset.tema = novoTema;
  localStorage.setItem('tema', novoTema);
  atualizarBotaoTema(novoTema);
}

// Inicializar na carga
inicializarTema();
document.getElementById('btn-tema')?.addEventListener('click', alternarTema);
```

### 18.4.4 — Revisão final de acessibilidade

```javascript
// Checklist de acessibilidade para executar antes da entrega

// 1. Executar no console do DevTools para encontrar imagens sem alt
const imgsSemAlt = document.querySelectorAll('img:not([alt])');
console.log(`Imagens sem alt: ${imgsSemAlt.length}`, imgsSemAlt);

// 2. Verificar botões sem texto acessível
const botoesVazios = [...document.querySelectorAll('button')]
  .filter(b => !b.textContent.trim() && !b.getAttribute('aria-label'));
console.log(`Botões sem texto acessível: ${botoesVazios.length}`, botoesVazios);

// 3. Verificar campos sem label
const camposSemLabel = [...document.querySelectorAll('input, select, textarea')]
  .filter(campo => {
    const id = campo.id;
    if (!id) return true;
    return !document.querySelector(`label[for="${id}"]`) &&
           !campo.getAttribute('aria-label') &&
           !campo.getAttribute('aria-labelledby');
  });
console.log(`Campos sem label: ${camposSemLabel.length}`, camposSemLabel);
```

### 18.4.5 — Checkpoint Sprint 3: revisão de código

Ao final do Sprint 3, verificar:

- O formulário valida todos os tipos de campos implementados?
- A busca tem debounce e AbortController?
- Os favoritos persistem entre recarregamentos da página?
- O Lighthouse Accessibility está ≥ 80?
- O console do DevTools está limpo de erros?
- O código funciona sem conexão com a API (erro tratado graciosamente)?

---

## 18.5 — Entrega e apresentação

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 18.5.1 — Checklist de entrega

```
Repositório Git:
□ Repositório público no GitHub com nome descritivo
□ README.md com: descrição do projeto, API usada,
  instruções de configuração, screenshots e link do deploy
□ .gitignore incluindo config.js, node_modules, .env
□ Pelo menos 10 commits com mensagens descritivas
□ Último commit não quebra a aplicação

Código:
□ Nenhum console.log de debug no código final
□ Nenhuma chave de API exposta no código versionado
□ Código formatado consistentemente (recomendado: Prettier)
□ Todos os arquivos com encoding UTF-8

Funcionalidades:
□ Todas as funcionalidades obrigatórias implementadas e testadas
□ A aplicação funciona nos navegadores Chrome, Firefox e Edge
□ A aplicação funciona em viewport de 375px (iPhone SE)
□ Nenhum erro JavaScript no console em uso normal

Acessibilidade:
□ Lighthouse Accessibility ≥ 80 (print da pontuação no README)
□ WAVE sem erros críticos (vermelho)
□ Navegação por teclado funcional na listagem e detalhe
```

### 18.5.2 — Deploy no GitHub Pages

O GitHub Pages permite publicar a aplicação gratuitamente diretamente do repositório:

**Passo 1 — Preparar para deploy:**
```bash
# Verificar que não há caminhos absolutos no código
# Substituir '/api/' por caminhos relativos se necessário
# Verificar que os imports de módulos usam extensão .js explícita
```

**Passo 2 — Configurar GitHub Pages:**
1. Acesse o repositório no GitHub
2. Vá em **Settings → Pages**
3. Em **Source**, selecione **Deploy from a branch**
4. Selecione a branch `main` e a pasta `/ (root)`
5. Clique em **Save**

**Passo 3 — Verificar o deploy:**
- Aguarde 2–5 minutos
- Acesse `https://seuusuario.github.io/nome-do-repositorio`
- Verifique se a aplicação carrega corretamente
- Teste a navegação entre telas

**Problema comum:** módulos ES6 (`type="module"`) funcionam com `http://` ou `https://`, mas não com `file://`. No GitHub Pages isso não é um problema — o servidor serve os arquivos via HTTPS.

**Outro problema comum:** se o repositório não estiver na raiz do GitHub Pages (ex.: `usuario.github.io/projeto/`), os caminhos de `import` precisam ser relativos:

```javascript
// ✅ Correto — caminho relativo
import Router from './router.js';

// ❌ Pode quebrar no deploy
import Router from '/js/router.js';
```

### 18.5.3 — Critérios de avaliação detalhados

| Critério | Peso | Descrição |
|---|---|---|
| **HTML semântico** | 10% | Uso correto dos elementos semânticos, formulário com labels, atributos de acessibilidade |
| **CSS e responsividade** | 20% | Tokens CSS, design coerente, responsivo em 3 viewports, tema escuro |
| **JavaScript e qualidade** | 25% | Módulos, tratamento de erros, código limpo, sem var |
| **Consumo de API** | 20% | Fetch correto, normalização, estados de UI completos, debounce |
| **Funcionalidades** | 15% | Listagem, detalhe, formulário, roteamento, favoritos/localStorage |
| **Acessibilidade** | 10% | Lighthouse ≥ 80, navegação por teclado, ARIA |

**Bônus (até +2 pontos):**
- Deploy no GitHub Pages funcionando: +0,5
- Tema escuro implementado corretamente: +0,5
- AbortController na busca: +0,5
- Componentes reutilizáveis bem documentados: +0,5

### 18.5.4 — Roteiro de apresentação

A apresentação tem duração de **5 minutos** e deve cobrir:

```
[0:00 – 0:30] Introdução
  → Nome, qual API foi escolhida e por quê
  → Qual o "problema" que a aplicação resolve para o usuário

[0:30 – 2:30] Demonstração ao vivo
  → Mostrar a listagem com dados reais da API
  → Executar uma busca ou filtro
  → Navegar para o detalhe de um item
  → Demonstrar o formulário com validação (incluir um erro propositalmente)
  → Mostrar os favoritos sendo adicionados e persistindo

[2:30 – 3:30] Aspectos técnicos
  → Mostrar a estrutura de arquivos no VS Code
  → Mostrar um trecho de código que você considera bem resolvido
  → Mostrar o score do Lighthouse

[3:30 – 4:30] Desafios e aprendizados
  → Qual foi a parte mais difícil de implementar?
  → O que você faria diferente com mais tempo?

[4:30 – 5:00] Perguntas
```

### 18.5.5 — Retrospectiva: o que aprendemos no ano letivo

Ao longo de 40 semanas e 18 capítulos, percorremos uma jornada completa pelo desenvolvimento front-end moderno:

**1º Bimestre — A fundação:**
Partimos dos fundamentos da Web — como um navegador interpreta HTML, o papel do HTTP, o conceito de DOM — e construímos páginas estruturadas com HTML semântico, acessível e bem formado. Aprendemos que a qualidade do HTML determina a qualidade de tudo que vem depois: CSS, JavaScript e acessibilidade dependem de uma marcação bem estruturada.

**2º Bimestre — A apresentação:**
Com CSS moderno, Flexbox, Grid e design responsivo, aprendemos a criar interfaces que funcionam em qualquer dispositivo. O Design System nos ensinou que consistência visual não é um acidente — é resultado de decisões sistemáticas sobre cores, tipografia e espaçamento. O Tailwind CSS mostrou como um framework pode acelerar o desenvolvimento sem sacrificar o controle.

**3º Bimestre — O comportamento:**
JavaScript trouxe vida às páginas. Aprendemos a linguagem em profundidade — closures, promises, async/await — e aplicamos esses conceitos na manipulação do DOM, no tratamento de eventos e na construção de componentes interativos. Os jogos mostraram que os mesmos conceitos de lógica, estado e renderização se aplicam em contextos bem diferentes.

**4º Bimestre — A integração:**
APIs tornaram as aplicações dinâmicas e conectadas ao mundo real. Módulos ES6 organizaram o código em camadas. Roteamento, estado global e persistência com localStorage deram à SPA a sensação de uma aplicação completa. O Projeto Final sintetizou tudo isso em algo que pode ser mostrado, usado e evoluído.

**O que aprendemos que transcende as tecnologias:**
- Separação de responsabilidades é um investimento que se paga a cada mudança futura
- Acessibilidade não é opcional — ela é parte da qualidade do software
- Código legível é mais valioso do que código "inteligente"
- Todo comportamento visual inesperado tem uma explicação técnica precisa
- A melhor forma de aprender é construir

A jornada do front-end não termina aqui. Frameworks como React, Vue e Angular, TypeScript, testes automatizados, performance e segurança web são capítulos futuros. Mas todos eles serão mais fáceis de compreender porque você entende o que acontece por baixo.

---

**Referências finais e recursos para continuar:**
- [MDN Web Docs](https://developer.mozilla.org/pt-BR/) — referência técnica definitiva
- [web.dev](https://web.dev) — boas práticas de performance e acessibilidade (Google)
- [javascript.info](https://javascript.info) — JavaScript em profundidade
- [CSS Tricks](https://css-tricks.com) — técnicas avançadas de CSS
- [A11y Project](https://www.a11yproject.com) — acessibilidade web
- [GitHub Student Developer Pack](https://education.github.com/pack) — ferramentas gratuitas para estudantes

---

#### **Atividades — Capítulo 18**

Não há quiz neste capítulo — o projeto final **é** a atividade avaliativa.

- **Entrega principal:** repositório GitHub com o projeto completo, README com screenshots e link do deploy no GitHub Pages. *(data definida pelo professor)*

- **Apresentação:** demonstração ao vivo de 5 minutos seguindo o roteiro da seção 18.5.4. *(data definida pelo professor)*

---

[:material-arrow-left: Voltar ao Capítulo 17 — Integração Frontend + API](17-frontend-api.md)

---

> *Programação Web 1 — IFAL — Bacharelado em Sistemas de Informação*
> *Material didático desenvolvido para o ano letivo 2026*
