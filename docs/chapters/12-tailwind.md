# Capítulo 12 — Framework CSS: Tailwind CSS

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 12.1 — O que é um framework CSS e por que usar

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Um **framework CSS** é um conjunto pré-construído de abstrações, convenções e ferramentas que acelera o desenvolvimento de interfaces ao fornecer soluções padronizadas para problemas recorrentes de estilização e layout. Em vez de escrever CSS do zero para cada projeto, o desenvolvedor parte de uma base consolidada — reduzindo o tempo de configuração inicial, promovendo consistência visual e beneficiando-se de decisões de design já validadas pela comunidade.

A adoção de frameworks CSS tornou-se praticamente universal no desenvolvimento front-end moderno. Compreender como e por que eles funcionam — incluindo suas limitações — é uma competência fundamental para qualquer desenvolvedor web.

### 12.1.1 — O problema que frameworks resolvem

O desenvolvimento de CSS em projetos de médio e grande porte enfrenta um conjunto de problemas recorrentes que frameworks foram criados para mitigar:

**Inconsistência visual:** sem um sistema de referência compartilhado, diferentes desenvolvedores de uma mesma equipe produzem estilos inconsistentes — margens diferentes para espaçamentos similares, botões com variações sutis de cor, tipografia sem hierarquia coerente.

**Retrabalho de decisões:** cada projeto recria soluções para os mesmos problemas — sistema de grid, componentes de botão, formulários, navegação responsiva. Frameworks encapsulam essas soluções, permitindo que a equipe foque no que é específico do produto.

**Escalabilidade do CSS:** CSS cresce sem estrutura inerente. Em projetos longos, a folha de estilos frequentemente acumula regras redundantes, conflitos de especificidade e seletores frágeis. Frameworks impõem convenções que limitam esse crescimento desordenado.

**Curva de entrada para equipes:** novos membros integram-se mais rapidamente quando o projeto usa um framework conhecido — as convenções são documentadas externamente, não precisam ser aprendidas a partir do código legado.

### 12.1.2 — Categorias de frameworks: utility-first vs component-based

Os frameworks CSS modernos se dividem em duas filosofias fundamentais:

**Frameworks baseados em componentes (*component-based*):** fornecem componentes de interface prontos — botões, cards, modais, navbars, grids — que o desenvolvedor instancia adicionando classes predefinidas ao HTML. O Bootstrap é o exemplo mais conhecido. O desenvolvedor consome componentes sem necessariamente escrever CSS.

**Frameworks utility-first:** fornecem classes de baixo nível (*utilities*) que mapeiam diretamente para propriedades CSS individuais. O desenvolvedor constrói a interface compondo essas classes no HTML, sem componentes prontos. O Tailwind CSS é o principal representante desta categoria.

```html
<!-- Component-based (Bootstrap): componente pronto -->
<button class="btn btn-primary btn-lg">Salvar</button>

<!-- Utility-first (Tailwind): composto de utilities -->
<button class="bg-blue-700 text-white font-semibold px-6 py-3
               rounded-lg hover:bg-blue-800 transition-colors">
  Salvar
</button>
```

A distinção não é apenas sintática — ela reflete abordagens diferentes de controle, flexibilidade e manutenção, exploradas em profundidade na seção 12.2.

### 12.1.3 — Tailwind CSS no contexto do mercado

O **Tailwind CSS** foi criado por **Adam Wathan** e lançado em 2017. Em um período relativamente curto, tornou-se o framework CSS mais amplamente adotado no desenvolvimento front-end moderno — superando o Bootstrap em downloads npm pela primeira vez em 2022 e mantendo crescimento consistente desde então.

Segundo a pesquisa **State of CSS 2024**, o Tailwind possui taxa de satisfação superior a 80% entre desenvolvedores que o utilizam — uma das mais altas da categoria. É o framework padrão em ecossistemas como Next.js, Nuxt.js e Laravel, e é utilizado por empresas como GitHub, Shopify, OpenAI e Vercel.

A versão atual é o **Tailwind CSS v4** (2025), que introduziu um novo motor de build baseado em Rust (*Oxide*), configuração via CSS em vez de JavaScript e melhorias significativas de desempenho. Este capítulo cobre os conceitos fundamentais que são estáveis entre versões, com exemplos baseados nas convenções do Tailwind v3/v4.

> **Referência:** [Tailwind CSS — Documentação oficial](https://tailwindcss.com/docs)

### 12.1.4 — Tailwind vs Bootstrap: diferenças filosóficas e práticas

A comparação entre Tailwind e Bootstrap é inevitável — ambos dominam o mercado de frameworks CSS, mas representam filosofias opostas. Compreender as diferenças ajuda a escolher a ferramenta adequada para cada contexto.

| Critério | Tailwind CSS | Bootstrap |
|---|---|---|
| **Filosofia** | Utility-first | Component-based |
| **Componentes prontos** | Nenhum (apenas utilities) | Extenso (botões, modais, navbars...) |
| **Customização** | Alta — tudo é configurável | Média — requer sobrescrever variáveis Sass |
| **Tamanho do CSS** | Mínimo — apenas classes usadas (PurgeCSS) | Maior — importa componentes não usados |
| **Curva de aprendizado** | Maior — requer conhecer as utilities | Menor — basta adicionar classes de componentes |
| **Velocidade inicial** | Lenta — constrói do zero | Rápida — componentes prontos |
| **Flexibilidade visual** | Muito alta | Limitada pelo design do Bootstrap |
| **Aparência padrão** | Nenhuma | "Cara de Bootstrap" reconhecível |
| **Versão atual** | v4 (2025) | v5.3 (2024) |

**Quando escolher Tailwind:** projetos onde a identidade visual é importante e não se quer a aparência genérica do Bootstrap; equipes com desenvolvedores front-end experientes; produtos que evoluem rapidamente e precisam de flexibilidade.

**Quando escolher Bootstrap:** prototipação rápida onde a aparência visual não é crítica; sistemas internos e ferramentas administrativas onde velocidade de desenvolvimento supera customização; equipes com pouca experiência em CSS que se beneficiam de componentes prontos.

> **Posição deste material:** este capítulo cobre o Tailwind CSS conforme o plano de ensino. Caso o projeto ou estágio exija Bootstrap, a documentação oficial ([getbootstrap.com](https://getbootstrap.com)) é autoexplicativa após dominar os fundamentos de CSS dos capítulos anteriores.

---

## 12.2 — Filosofia utility-first

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 12.2.1 — O que são classes utilitárias

Uma **classe utilitária** (*utility class*) é uma classe CSS com propósito único — ela aplica exatamente uma propriedade CSS com um valor específico. Em vez de criar abstrações semânticas, classes utilitárias são funcionais e diretas:

```css
/* Classes utilitárias — cada uma faz uma coisa */
.flex        { display: flex; }
.items-center { align-items: center; }
.gap-4       { gap: 1rem; }
.text-lg     { font-size: 1.125rem; }
.font-bold   { font-weight: 700; }
.text-white  { color: #ffffff; }
.bg-blue-700 { background-color: #1d4ed8; }
.rounded-lg  { border-radius: 0.5rem; }
.px-6        { padding-left: 1.5rem; padding-right: 1.5rem; }
.py-3        { padding-top: 0.75rem; padding-bottom: 0.75rem; }
```

A premissa do utility-first é que interfaces são compostas adicionando essas classes diretamente ao HTML — sem criar classes semânticas intermediárias para a maioria dos casos:

```html
<!-- CSS semântico: classe com nome descritivo, CSS separado -->
<nav class="navbar">...</nav>

<!-- Utility-first: propriedades expressas diretamente no HTML -->
<nav class="flex items-center justify-between px-6 py-4 bg-slate-900">...</nav>
```

### 12.2.2 — Utility-first vs CSS semântico: a tensão e o equilíbrio

A abordagem utility-first gera uma tensão filosófica com a separação clássica entre HTML (estrutura) e CSS (apresentação) — um dos princípios fundamentais apresentados no Capítulo 7. Ao colocar informações visuais diretamente no HTML via classes, o utility-first viola aparentemente essa separação.

Adam Wathan argumenta, em seu ensaio *CSS Utility Classes and "Separation of Concerns"*, que a separação relevante não é entre HTML e CSS, mas entre **componentes de interface** reutilizáveis. Em uma aplicação moderna baseada em componentes, o HTML de um botão não é "um documento separado do CSS" — é parte de um componente coeso. A questão não é onde as classes estão, mas se o componente é reutilizável.

**Críticas legítimas ao utility-first:**

- **HTML verboso:** classes longas reduzem a legibilidade do markup, especialmente para desenvolvedores acostumados ao CSS semântico
- **Dificuldade de manutenção em componentes repetidos:** sem extração de componentes, a mesma lista de classes precisa ser duplicada em cada instância
- **Curva de aprendizado:** exige memorizar ou consultar frequentemente a nomenclatura das utilities

**Vantagens práticas:**

- **Sem conflitos de nomenclatura:** não há necessidade de inventar nomes de classes para cada elemento
- **CSS nunca cresce:** o arquivo CSS final contém apenas as utilities utilizadas — não importa quantas páginas o projeto tem
- **Iteração visual rápida:** mudanças visuais são feitas diretamente no HTML sem alternar entre arquivos
- **Consistência por convenção:** todos os valores de espaçamento, cor e tipografia vêm da escala do Tailwind — não de valores arbitrários

### 12.2.3 — Comparação: CSS tradicional vs Tailwind para o mesmo componente

```html
<!-- CSS Tradicional -->
<article class="card">
  <img class="card__imagem" src="foto.jpg" alt="Descrição" />
  <div class="card__corpo">
    <h2 class="card__titulo">Título do Card</h2>
    <p class="card__descricao">Descrição do conteúdo...</p>
  </div>
  <footer class="card__rodape">
    <a class="btn btn--primario" href="#">Saiba mais</a>
  </footer>
</article>
```

```css
/* CSS separado: ~30 linhas */
.card {
  background: white;
  border-radius: 0.5rem;
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
.card__imagem { width: 100%; height: 200px; object-fit: cover; }
.card__corpo  { flex: 1; padding: 1.5rem; }
.card__titulo { font-size: 1.25rem; font-weight: 600; margin-bottom: 0.5rem; }
/* ... */
```

```html
<!-- Tailwind: tudo no HTML, ~0 linhas de CSS personalizado -->
<article class="bg-white rounded-lg shadow-md overflow-hidden flex flex-col">
  <img class="w-full h-48 object-cover" src="foto.jpg" alt="Descrição" />
  <div class="flex-1 p-6">
    <h2 class="text-xl font-semibold mb-2">Título do Card</h2>
    <p class="text-slate-600 leading-relaxed">Descrição do conteúdo...</p>
  </div>
  <footer class="px-6 pb-6">
    <a class="inline-flex items-center px-4 py-2 bg-blue-700 text-white
              font-semibold rounded-lg hover:bg-blue-800 transition-colors"
       href="#">
      Saiba mais
    </a>
  </footer>
</article>
```

### 12.2.4 — Quando utility-first faz sentido e quando não faz

**Faz sentido quando:**
- O projeto é construído com componentes (React, Vue, templates reutilizáveis)
- A equipe valoriza iteração visual rápida
- A identidade visual é importante e diferenciada
- O projeto precisa de CSS mínimo em produção

**Não faz sentido quando:**
- O projeto é um documento HTML estático simples sem componentes
- A equipe tem resistência à verbosidade no HTML
- Há necessidade de componentes visuais prontos rapidamente (Bootstrap é mais eficiente)
- O projeto usa um CMS que gera HTML e não permite controle das classes

---

## 12.3 — Instalação e configuração

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 12.3.1 — Usando Tailwind via CDN (para prototipação)

A forma mais rápida de experimentar o Tailwind é via CDN — sem instalação, ideal para protótipos e atividades iniciais:

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tailwind via CDN</title>
  <!-- Tailwind CSS via CDN — apenas para prototipação -->
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 text-slate-900 p-8">
  <h1 class="text-4xl font-bold text-blue-700 mb-4">Olá, Tailwind!</h1>
  <p class="text-lg text-slate-600">
    Esta página usa Tailwind CSS via CDN.
  </p>
</body>
</html>
```

> **⚠️ Limitação do CDN:** a versão CDN do Tailwind carrega o framework inteiro no browser e processa as classes em tempo de execução — produzindo um arquivo CSS grande e sem otimização. É adequada apenas para prototipação e aprendizado. **Nunca use a CDN em produção** — utilize a instalação via npm com o processo de build para obter apenas as classes efetivamente usadas.

### 12.3.2 — Instalação via npm e CLI

Para projetos reais, o Tailwind é instalado como dependência de desenvolvimento e processado por uma ferramenta de build:

**Passo 1 — Inicializar o projeto e instalar o Tailwind:**

```bash
# Inicializar package.json (se ainda não existir)
npm init -y

# Instalar Tailwind CSS e suas dependências
npm install -D tailwindcss postcss autoprefixer

# Gerar os arquivos de configuração
npx tailwindcss init -p
```

**Passo 2 — Configurar o `tailwind.config.js`:**

```javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  // content: informa ao Tailwind quais arquivos escanear
  // para detectar as classes utilizadas
  content: [
    "./src/**/*.{html,js}",
    "./*.html",
  ],
  theme: {
    extend: {
      // personalizações do tema (seção 12.8)
    },
  },
  plugins: [],
}
```

**Passo 3 — Criar o arquivo CSS de entrada:**

```css
/* src/input.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Passo 4 — Executar o processo de build:**

```bash
# Build único
npx tailwindcss -i ./src/input.css -o ./dist/output.css

# Build em modo watch (recompila ao salvar)
npx tailwindcss -i ./src/input.css -o ./dist/output.css --watch
```

**Passo 5 — Vincular o CSS gerado ao HTML:**

```html
<head>
  <link rel="stylesheet" href="./dist/output.css" />
</head>
```

**Scripts no `package.json` para facilitar:**

```json
{
  "scripts": {
    "dev": "tailwindcss -i ./src/input.css -o ./dist/output.css --watch",
    "build": "tailwindcss -i ./src/input.css -o ./dist/output.css --minify"
  }
}
```

Com esses scripts, `npm run dev` inicia o modo de desenvolvimento e `npm run build` gera o CSS minificado para produção.

### 12.3.3 — O arquivo `tailwind.config.js`

O arquivo de configuração é o coração da customização do Tailwind. Sua estrutura principal:

```javascript
// tailwind.config.js
module.exports = {
  // Arquivos a escanear para detecção de classes
  content: ["./src/**/*.{html,js,ts,jsx,tsx}"],

  // darkMode: 'media' (sistema) ou 'class' (manual via classe .dark)
  darkMode: 'media',

  theme: {
    // theme.XXX: SUBSTITUI os valores padrão
    screens: {
      'sm': '640px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
    },

    // theme.extend.XXX: ADICIONA aos valores padrão
    extend: {
      colors: {
        'primaria': {
          50:  '#eff6ff',
          500: '#3b82f6',
          700: '#1d4ed8',
          900: '#1e3a8a',
        },
      },
      fontFamily: {
        'sem-serifa': ['Inter', 'system-ui', 'sans-serif'],
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
      },
    },
  },

  plugins: [],
}
```

### 12.3.4 — Integração com o processo de build

Em projetos mais complexos, o Tailwind se integra com ferramentas de build como **Vite**, **Webpack** ou **Parcel**. A integração com Vite — o bundler mais popular atualmente — é a mais simples:

```bash
# Criar projeto Vite
npm create vite@latest meu-projeto -- --template vanilla

cd meu-projeto
npm install

# Adicionar Tailwind
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

```javascript
// tailwind.config.js para Vite
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts}"],
  theme: { extend: {} },
  plugins: [],
}
```

```css
/* src/style.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

Com essa configuração, `npm run dev` inicia o servidor de desenvolvimento com hot reload e recompilação automática do Tailwind.

---

## 12.4 — Classes utilitárias essenciais

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O Tailwind possui centenas de classes utilitárias. Esta seção cobre as mais utilizadas — organizadas por categoria — com a correspondência direta ao CSS que cada uma gera.

> **Imagem sugerida:** captura da extensão **Tailwind CSS IntelliSense** no VS Code mostrando o autocomplete de classes com preview do CSS gerado — demonstrando como a ferramenta facilita o aprendizado das utilities.
>
> *(imagem será adicionada posteriormente)*

> **Dica de produtividade:** instale a extensão **Tailwind CSS IntelliSense** no VS Code. Ela fornece autocomplete, preview do CSS gerado ao passar o mouse sobre uma classe e detecção de erros. É indispensável para trabalhar com Tailwind de forma eficiente.

### 12.4.1 — Layout: display, position, overflow

```html
<!-- Display -->
<div class="block">...</div>          <!-- display: block -->
<span class="inline-block">...</span> <!-- display: inline-block -->
<div class="flex">...</div>           <!-- display: flex -->
<div class="inline-flex">...</div>    <!-- display: inline-flex -->
<div class="grid">...</div>           <!-- display: grid -->
<div class="hidden">...</div>         <!-- display: none -->

<!-- Position -->
<div class="relative">...</div>  <!-- position: relative -->
<div class="absolute">...</div>  <!-- position: absolute -->
<div class="fixed">...</div>     <!-- position: fixed -->
<div class="sticky">...</div>    <!-- position: sticky -->

<!-- Coordenadas de posicionamento -->
<div class="absolute top-0 right-0">...</div>   <!-- top: 0; right: 0 -->
<div class="absolute inset-0">...</div>         <!-- top/right/bottom/left: 0 -->
<div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
  <!-- centralização com transform -->
</div>

<!-- Z-index -->
<div class="z-10">...</div>   <!-- z-index: 10 -->
<div class="z-50">...</div>   <!-- z-index: 50 -->
<div class="z-[1000]">...</div> <!-- valor arbitrário: z-index: 1000 -->

<!-- Overflow -->
<div class="overflow-hidden">...</div>    <!-- overflow: hidden -->
<div class="overflow-auto">...</div>      <!-- overflow: auto -->
<div class="overflow-x-auto">...</div>    <!-- overflow-x: auto -->
```

### 12.4.2 — Flexbox e Grid com Tailwind

```html
<!-- ── Flexbox ── -->
<div class="flex flex-row gap-4 items-center justify-between">
  <!-- display: flex; flex-direction: row; gap: 1rem;
       align-items: center; justify-content: space-between -->
</div>

<!-- flex-direction -->
<div class="flex flex-col">...</div>         <!-- column -->
<div class="flex flex-row-reverse">...</div> <!-- row-reverse -->

<!-- flex-wrap -->
<div class="flex flex-wrap gap-4">...</div>  <!-- flex-wrap: wrap -->

<!-- justify-content -->
<div class="flex justify-start">...</div>
<div class="flex justify-center">...</div>
<div class="flex justify-end">...</div>
<div class="flex justify-between">...</div>
<div class="flex justify-around">...</div>
<div class="flex justify-evenly">...</div>

<!-- align-items -->
<div class="flex items-start">...</div>
<div class="flex items-center">...</div>
<div class="flex items-end">...</div>
<div class="flex items-stretch">...</div>
<div class="flex items-baseline">...</div>

<!-- flex items -->
<div class="flex-1">...</div>       <!-- flex: 1 1 0% -->
<div class="flex-auto">...</div>    <!-- flex: 1 1 auto -->
<div class="flex-none">...</div>    <!-- flex: none -->
<div class="shrink-0">...</div>     <!-- flex-shrink: 0 -->
<div class="grow">...</div>         <!-- flex-grow: 1 -->

<!-- align-self -->
<div class="self-center">...</div>
<div class="self-start">...</div>

<!-- ── Grid ── -->
<div class="grid grid-cols-3 gap-6">
  <!-- display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem -->
</div>

<!-- Colunas -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4">...</div>

<!-- Grid responsivo sem media queries -->
<div class="grid grid-cols-[repeat(auto-fit,minmax(280px,1fr))] gap-4">...</div>

<!-- Posicionamento de itens -->
<div class="col-span-2">...</div>    <!-- grid-column: span 2 -->
<div class="col-span-full">...</div> <!-- grid-column: 1 / -1 -->
<div class="row-span-2">...</div>    <!-- grid-row: span 2 -->
```

### 12.4.3 — Espaçamento: padding, margin, gap

O Tailwind usa uma escala numérica onde cada unidade equivale a `0.25rem` (4px com base 16px):

```html
<!-- Padding -->
<div class="p-4">...</div>    <!-- padding: 1rem (4 × 0.25rem) -->
<div class="px-6">...</div>   <!-- padding-left/right: 1.5rem -->
<div class="py-3">...</div>   <!-- padding-top/bottom: 0.75rem -->
<div class="pt-2 pb-4">...</div> <!-- top: 0.5rem; bottom: 1rem -->
<div class="ps-4">...</div>   <!-- padding-inline-start: 1rem (RTL-aware) -->

<!-- Margin -->
<div class="m-4">...</div>    <!-- margin: 1rem -->
<div class="mx-auto">...</div> <!-- margin-left/right: auto (centraliza) -->
<div class="mt-8 mb-4">...</div>
<div class="-mt-2">...</div>  <!-- margin-top: -0.5rem (negativo) -->

<!-- Gap (em flex e grid) -->
<div class="flex gap-4">...</div>     <!-- gap: 1rem -->
<div class="grid gap-x-6 gap-y-4">...</div> <!-- column-gap: 1.5rem; row-gap: 1rem -->

<!-- Referência da escala de espaçamento -->
<!-- 0=0, 0.5=0.125rem, 1=0.25rem, 2=0.5rem, 3=0.75rem, 4=1rem,
     5=1.25rem, 6=1.5rem, 7=1.75rem, 8=2rem, 10=2.5rem, 12=3rem,
     16=4rem, 20=5rem, 24=6rem, 32=8rem, 40=10rem, 48=12rem, 64=16rem -->
```

### 12.4.4 — Dimensionamento: width, height, max/min

```html
<!-- Width -->
<div class="w-full">...</div>    <!-- width: 100% -->
<div class="w-1/2">...</div>     <!-- width: 50% -->
<div class="w-1/3">...</div>     <!-- width: 33.333% -->
<div class="w-64">...</div>      <!-- width: 16rem -->
<div class="w-screen">...</div>  <!-- width: 100vw -->
<div class="w-fit">...</div>     <!-- width: fit-content -->
<div class="w-auto">...</div>    <!-- width: auto -->

<!-- Height -->
<div class="h-full">...</div>    <!-- height: 100% -->
<div class="h-screen">...</div>  <!-- height: 100vh -->
<div class="h-48">...</div>      <!-- height: 12rem -->
<div class="h-fit">...</div>     <!-- height: fit-content -->
<div class="min-h-screen">...</div> <!-- min-height: 100vh -->

<!-- Max/Min width -->
<div class="max-w-sm">...</div>   <!-- max-width: 24rem -->
<div class="max-w-md">...</div>   <!-- max-width: 28rem -->
<div class="max-w-lg">...</div>   <!-- max-width: 32rem -->
<div class="max-w-xl">...</div>   <!-- max-width: 36rem -->
<div class="max-w-2xl">...</div>  <!-- max-width: 42rem -->
<div class="max-w-4xl">...</div>  <!-- max-width: 56rem -->
<div class="max-w-6xl">...</div>  <!-- max-width: 72rem -->
<div class="max-w-7xl">...</div>  <!-- max-width: 80rem -->
<div class="max-w-full">...</div> <!-- max-width: 100% -->
<div class="max-w-none">...</div> <!-- max-width: none -->

<!-- Aspect ratio -->
<div class="aspect-video">...</div>  <!-- aspect-ratio: 16 / 9 -->
<div class="aspect-square">...</div> <!-- aspect-ratio: 1 / 1 -->
```

### 12.4.5 — Tipografia

```html
<!-- font-size -->
<p class="text-xs">...</p>    <!-- 0.75rem -->
<p class="text-sm">...</p>    <!-- 0.875rem -->
<p class="text-base">...</p>  <!-- 1rem -->
<p class="text-lg">...</p>    <!-- 1.125rem -->
<p class="text-xl">...</p>    <!-- 1.25rem -->
<p class="text-2xl">...</p>   <!-- 1.5rem -->
<p class="text-3xl">...</p>   <!-- 1.875rem -->
<p class="text-4xl">...</p>   <!-- 2.25rem -->
<p class="text-5xl">...</p>   <!-- 3rem -->
<p class="text-6xl">...</p>   <!-- 3.75rem -->

<!-- font-weight -->
<p class="font-thin">...</p>       <!-- 100 -->
<p class="font-light">...</p>      <!-- 300 -->
<p class="font-normal">...</p>     <!-- 400 -->
<p class="font-medium">...</p>     <!-- 500 -->
<p class="font-semibold">...</p>   <!-- 600 -->
<p class="font-bold">...</p>       <!-- 700 -->
<p class="font-extrabold">...</p>  <!-- 800 -->
<p class="font-black">...</p>      <!-- 900 -->

<!-- line-height -->
<p class="leading-none">...</p>    <!-- 1 -->
<p class="leading-tight">...</p>   <!-- 1.25 -->
<p class="leading-snug">...</p>    <!-- 1.375 -->
<p class="leading-normal">...</p>  <!-- 1.5 -->
<p class="leading-relaxed">...</p> <!-- 1.625 -->
<p class="leading-loose">...</p>   <!-- 2 -->

<!-- text-align -->
<p class="text-left">...</p>
<p class="text-center">...</p>
<p class="text-right">...</p>
<p class="text-justify">...</p>

<!-- letter-spacing -->
<p class="tracking-tight">...</p>   <!-- -0.05em -->
<p class="tracking-normal">...</p>  <!-- 0 -->
<p class="tracking-wide">...</p>    <!-- 0.025em -->
<p class="tracking-wider">...</p>   <!-- 0.05em -->
<p class="tracking-widest">...</p>  <!-- 0.1em -->

<!-- text-decoration -->
<a class="underline">...</a>
<a class="no-underline">...</a>
<p class="line-through">...</p>

<!-- text-transform -->
<p class="uppercase">...</p>
<p class="lowercase">...</p>
<p class="capitalize">...</p>

<!-- Truncamento *)
<p class="truncate">Texto longo que será truncado...</p>
<!-- overflow: hidden; text-overflow: ellipsis; white-space: nowrap -->
```

### 12.4.6 — Cores: text, background, border

O Tailwind inclui uma paleta de cores extensa com escalas de 50 a 950 para cada tom. A nomenclatura segue o padrão `{propriedade}-{cor}-{escala}`:

```html
<!-- text color -->
<p class="text-slate-900">...</p>   <!-- cor escura para texto -->
<p class="text-slate-600">...</p>   <!-- cinza médio secundário -->
<p class="text-blue-700">...</p>    <!-- azul para links/destaques -->
<p class="text-white">...</p>       <!-- branco -->

<!-- background color -->
<div class="bg-white">...</div>
<div class="bg-slate-50">...</div>   <!-- fundo levemente cinza -->
<div class="bg-slate-900">...</div>  <!-- fundo escuro -->
<div class="bg-blue-700">...</div>   <!-- fundo azul (primário) -->
<div class="bg-blue-50">...</div>    <!-- azul muito claro (destaque sutil) -->

<!-- border color -->
<div class="border border-slate-200">...</div>  <!-- borda cinza clara -->
<div class="border border-blue-500">...</div>   <!-- borda azul -->

<!-- Cores com opacidade -->
<div class="bg-blue-700/80">...</div>      <!-- bg com 80% de opacidade -->
<p class="text-slate-900/70">...</p>       <!-- texto com 70% de opacidade -->
<div class="border border-black/10">...</div>  <!-- borda preta 10% opacidade -->
```

**Paleta de cores do Tailwind (tons principais):**

| Cor | Uso típico |
|---|---|
| `slate` | Texto, fundos neutros, bordas |
| `gray` | Alternativa neutra ao slate |
| `zinc` | Neutro com tom levemente quente |
| `red` | Erros, perigo, alertas críticos |
| `orange` | Avisos, destaques |
| `yellow` | Avisos suaves |
| `green` | Sucesso, confirmação |
| `blue` | Ação primária, links, informação |
| `indigo` | Alternativa ao azul |
| `purple` | Destaques visuais |
| `pink` | Uso decorativo |

### 12.4.7 — Bordas: border, border-radius, outline

```html
<!-- border -->
<div class="border">...</div>           <!-- border: 1px solid -->
<div class="border-2">...</div>         <!-- border-width: 2px -->
<div class="border-4">...</div>         <!-- border-width: 4px -->
<div class="border-t">...</div>         <!-- border-top apenas -->
<div class="border-b border-slate-200">...</div> <!-- bottom com cor -->
<div class="border-0">...</div>         <!-- remove borda -->

<!-- border-radius -->
<div class="rounded-none">...</div>    <!-- 0 -->
<div class="rounded-sm">...</div>      <!-- 0.125rem -->
<div class="rounded">...</div>         <!-- 0.25rem -->
<div class="rounded-md">...</div>      <!-- 0.375rem -->
<div class="rounded-lg">...</div>      <!-- 0.5rem -->
<div class="rounded-xl">...</div>      <!-- 0.75rem -->
<div class="rounded-2xl">...</div>     <!-- 1rem -->
<div class="rounded-full">...</div>    <!-- 9999px — círculo/pílula -->

<!-- outline (foco) -->
<button class="focus-visible:outline focus-visible:outline-2
               focus-visible:outline-offset-2 focus-visible:outline-blue-600">
  Botão acessível
</button>

<!-- ring (foco — alternativa com box-shadow) *)
<input class="focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
              focus:outline-none" />
```

### 12.4.8 — Sombras e opacidade

```html
<!-- box-shadow -->
<div class="shadow-sm">...</div>   <!-- sombra sutil *)
<div class="shadow">...</div>      <!-- sombra padrão *)
<div class="shadow-md">...</div>   <!-- sombra média *)
<div class="shadow-lg">...</div>   <!-- sombra grande *)
<div class="shadow-xl">...</div>   <!-- sombra extra grande *)
<div class="shadow-2xl">...</div>  <!-- sombra máxima *)
<div class="shadow-none">...</div> <!-- remove sombra *)

<!-- opacity *)
<div class="opacity-0">...</div>    <!-- opacity: 0 (invisível) *)
<div class="opacity-50">...</div>   <!-- opacity: 0.5 *)
<div class="opacity-75">...</div>   <!-- opacity: 0.75 *)
<div class="opacity-100">...</div>  <!-- opacity: 1 (opaco) *)
```

### 12.4.9 — Transições e animações básicas

```html
<!-- transition *)
<button class="transition-colors duration-200">...</button>
<!-- transition: color, background-color, border-color... 200ms *)

<div class="transition-all duration-300 ease-in-out">...</div>
<!-- transition: all 300ms ease-in-out *)

<div class="transition-transform duration-150">...</div>

<!-- duration -->
<div class="duration-75">...</div>   <!-- 75ms *)
<div class="duration-100">...</div>  <!-- 100ms *)
<div class="duration-150">...</div>  <!-- 150ms *)
<div class="duration-200">...</div>  <!-- 200ms *)
<div class="duration-300">...</div>  <!-- 300ms *)
<div class="duration-500">...</div>  <!-- 500ms *)
<div class="duration-700">...</div>  <!-- 700ms *)

<!-- easing *)
<div class="ease-linear">...</div>
<div class="ease-in">...</div>
<div class="ease-out">...</div>
<div class="ease-in-out">...</div>

<!-- transform *)
<div class="hover:scale-105">...</div>         <!-- scale(1.05) *)
<div class="hover:-translate-y-1">...</div>    <!-- translateY(-0.25rem) *)
<div class="hover:rotate-3">...</div>          <!-- rotate(3deg) *)

<!-- animate (animações predefinidas) *)
<div class="animate-spin">...</div>    <!-- rotação contínua *)
<div class="animate-ping">...</div>    <!-- pulso expansivo *)
<div class="animate-pulse">...</div>   <!-- pulso de opacidade *)
<div class="animate-bounce">...</div>  <!-- salto *)
```

---

## 12.5 — Responsividade com Tailwind

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 12.5.1 — O sistema de breakpoints do Tailwind

O Tailwind implementa um sistema de breakpoints baseado em `min-width` — mobile-first por padrão:

| Prefixo | Breakpoint | CSS gerado |
|---|---|---|
| *(nenhum)* | < 640px | estilos base (mobile) |
| `sm:` | ≥ 640px | `@media (min-width: 640px)` |
| `md:` | ≥ 768px | `@media (min-width: 768px)` |
| `lg:` | ≥ 1024px | `@media (min-width: 1024px)` |
| `xl:` | ≥ 1280px | `@media (min-width: 1280px)` |
| `2xl:` | ≥ 1536px | `@media (min-width: 1536px)` |

### 12.5.2 — Prefixos responsivos

Qualquer utility pode ser prefixada com um breakpoint para condicionar sua aplicação:

```html
<!-- Sem prefixo: aplica em todos os tamanhos (mobile-first) -->
<!-- Com prefixo: aplica apenas a partir daquele breakpoint -->

<div class="text-base md:text-lg lg:text-xl">
  Texto que cresce com o viewport
</div>

<div class="flex flex-col md:flex-row gap-4 md:gap-6">
  Empilhado em mobile, lado a lado a partir de md
</div>

<div class="hidden md:block">
  Oculto em mobile, visível a partir de md
</div>

<div class="block md:hidden">
  Visível apenas em mobile
</div>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
  Grade que aumenta colunas progressivamente
</div>
```

### 12.5.3 — Mobile-first por padrão

O sistema de breakpoints do Tailwind reforça a abordagem mobile-first apresentada no Capítulo 10: os estilos sem prefixo são os estilos base (mobile), e os prefixos adicionam sobrescrições progressivas para viewports maiores:

```html
<!-- Mobile-first com Tailwind -->
<nav class="
  flex flex-col gap-2 p-4
  md:flex-row md:items-center md:justify-between md:px-8 md:py-4
  lg:px-12
">
  <!-- Mobile: coluna, padding pequeno -->
  <!-- md: linha, centralizado, padding médio -->
  <!-- lg: padding maior -->
</nav>
```

### 12.5.4 — Exemplos práticos de layout responsivo

**Hero section responsiva:**

```html
<section class="
  flex flex-col gap-8 px-4 py-12
  md:flex-row md:items-center md:gap-12 md:px-8 md:py-20
  lg:px-16 lg:py-28 lg:gap-16
  max-w-7xl mx-auto
">
  <div class="flex-1 space-y-6">
    <h1 class="text-3xl font-bold leading-tight md:text-4xl lg:text-5xl">
      Título principal da seção
    </h1>
    <p class="text-lg text-slate-600 leading-relaxed max-w-prose">
      Descrição da seção...
    </p>
    <div class="flex flex-col sm:flex-row gap-3">
      <a href="#" class="px-6 py-3 bg-blue-700 text-white font-semibold
                         rounded-lg text-center hover:bg-blue-800 transition-colors">
        Ação primária
      </a>
      <a href="#" class="px-6 py-3 border-2 border-blue-700 text-blue-700
                         font-semibold rounded-lg text-center
                         hover:bg-blue-50 transition-colors">
        Ação secundária
      </a>
    </div>
  </div>
  <div class="flex-1">
    <img src="hero.jpg" alt="Imagem hero"
         class="w-full rounded-2xl shadow-xl" />
  </div>
</section>
```

---

## 12.6 — Estados e variantes

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 12.6.1 — Pseudo-classes: `hover:`, `focus:`, `active:`, `disabled:`

```html
<!-- hover -->
<button class="bg-blue-700 hover:bg-blue-800 text-white px-4 py-2 rounded-lg
               transition-colors duration-200">
  Botão com hover
</button>

<!-- focus e focus-visible -->
<input class="border border-slate-300 rounded-md px-3 py-2
              focus:outline-none focus:border-blue-500
              focus:ring-2 focus:ring-blue-500/20" />

<button class="focus-visible:outline focus-visible:outline-2
               focus-visible:outline-offset-2 focus-visible:outline-blue-600">
  Foco visível apenas via teclado
</button>

<!-- active -->
<button class="active:scale-95 active:bg-blue-900 transition-transform">
  Pressionar reduz levemente
</button>

<!-- disabled -->
<button class="disabled:opacity-50 disabled:cursor-not-allowed
               disabled:pointer-events-none" disabled>
  Desabilitado
</button>

<!-- group: aplica estilos a filhos quando o pai recebe hover *)
<div class="group flex items-center gap-3 p-4 rounded-lg
            hover:bg-slate-100 cursor-pointer">
  <div class="w-10 h-10 rounded-full bg-blue-100 group-hover:bg-blue-200
              transition-colors">
  </div>
  <p class="font-medium group-hover:text-blue-700 transition-colors">
    Texto que muda quando o card recebe hover
  </p>
</div>
```

### 12.6.2 — Pseudo-elementos: `before:`, `after:`, `placeholder:`

```html
<!-- placeholder -->
<input class="placeholder:text-slate-400 placeholder:italic
              border rounded-md px-3 py-2"
       placeholder="Digite aqui..." />

<!-- before e after *)
<div class="relative before:absolute before:inset-0
            before:bg-black/40 before:rounded-lg">
  <img src="foto.jpg" alt="Com overlay" class="rounded-lg" />
</div>

<!-- first: e last: — primeiro e último filho *)
<ul>
  <li class="py-3 border-b border-slate-100 first:pt-0 last:border-0">
    Item da lista
  </li>
</ul>

<!-- odd: e even: — alternância de linhas *)
<tr class="odd:bg-white even:bg-slate-50">
  <td class="px-4 py-3">...</td>
</tr>
```

### 12.6.3 — Estados de formulário

```html
<!-- required, invalid, valid *)
<input class="border rounded-md px-3 py-2
              required:border-slate-300
              invalid:border-red-500 invalid:ring-2 invalid:ring-red-500/20
              valid:border-green-500"
       type="email" required />

<!-- checked (checkbox/radio) *)
<input class="accent-blue-700 w-4 h-4 cursor-pointer"
       type="checkbox" />

<!-- peer: aplica estilo a irmão com base no estado do elemento *)
<div class="flex flex-col gap-1">
  <input class="peer border rounded-md px-3 py-2
                focus:outline-none focus:border-blue-500"
         type="email" required />
  <p class="hidden peer-invalid:block text-sm text-red-600">
    E-mail inválido
  </p>
</div>
```

### 12.6.4 — Dark mode: `dark:`

```html
<!-- dark: aplica estilos quando o tema escuro está ativo *)
<div class="bg-white dark:bg-slate-900
            text-slate-900 dark:text-slate-100
            border border-slate-200 dark:border-slate-700
            p-6 rounded-xl">
  <h2 class="text-xl font-bold text-slate-900 dark:text-white">
    Título adaptativo
  </h2>
  <p class="text-slate-600 dark:text-slate-400 mt-2">
    Conteúdo que se adapta ao tema do sistema.
  </p>
</div>
```

Por padrão, o modo escuro do Tailwind usa `prefers-color-scheme: dark`. Para controle manual via classe `.dark` no `<html>`, configure `darkMode: 'class'` no `tailwind.config.js`.

### 12.6.5 — Combinando variantes

Variantes podem ser combinadas livremente — a ordem de escrita segue a lógica `{breakpoint}:{estado}:{utility}`:

```html
<!-- Responsivo + estado *)
<button class="
  bg-blue-700 text-white
  hover:bg-blue-800
  md:text-lg md:px-8 md:py-4
  md:hover:bg-blue-900
  dark:bg-blue-600 dark:hover:bg-blue-500
  disabled:opacity-50 disabled:cursor-not-allowed
  transition-all duration-200
  focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-300
">
  Botão com múltiplas variantes
</button>
```

---

## 12.7 — Componentes com Tailwind

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 12.7.1 — Construindo um botão com variantes

```html
<!-- Botão primário *)
<button class="inline-flex items-center justify-center gap-2
               px-4 py-2 rounded-lg font-semibold text-sm
               bg-blue-700 text-white
               hover:bg-blue-800 active:bg-blue-900
               focus-visible:outline focus-visible:outline-2
               focus-visible:outline-offset-2 focus-visible:outline-blue-600
               disabled:opacity-50 disabled:cursor-not-allowed
               transition-colors duration-200"
        type="button">
  Salvar
</button>

<!-- Botão secundário (outline) *)
<button class="inline-flex items-center justify-center gap-2
               px-4 py-2 rounded-lg font-semibold text-sm
               border-2 border-blue-700 text-blue-700 bg-transparent
               hover:bg-blue-50 active:bg-blue-100
               focus-visible:outline focus-visible:outline-2
               focus-visible:outline-offset-2 focus-visible:outline-blue-600
               disabled:opacity-50 disabled:cursor-not-allowed
               transition-colors duration-200"
        type="button">
  Cancelar
</button>

<!-- Botão de perigo *)
<button class="inline-flex items-center justify-center gap-2
               px-4 py-2 rounded-lg font-semibold text-sm
               bg-red-600 text-white
               hover:bg-red-700 active:bg-red-800
               focus-visible:outline focus-visible:outline-2
               focus-visible:outline-offset-2 focus-visible:outline-red-600
               disabled:opacity-50 disabled:cursor-not-allowed
               transition-colors duration-200"
        type="button">
  Excluir
</button>
```

### 12.7.2 — Card responsivo

```html
<article class="bg-white rounded-xl shadow-md overflow-hidden
                flex flex-col
                hover:shadow-lg hover:-translate-y-1 transition-all duration-300
                focus-within:outline focus-within:outline-2
                focus-within:outline-blue-500">
  <img src="imagem.jpg" alt="Descrição"
       class="w-full h-48 object-cover" />

  <div class="flex-1 p-6 flex flex-col gap-3">
    <div class="flex items-center gap-2">
      <span class="text-xs font-semibold text-blue-700 bg-blue-50
                   px-2.5 py-0.5 rounded-full uppercase tracking-wide">
        Categoria
      </span>
    </div>

    <h2 class="text-xl font-semibold text-slate-900 leading-snug">
      Título do card
    </h2>

    <p class="text-slate-600 leading-relaxed text-sm flex-1">
      Descrição do conteúdo do card que pode ser mais ou menos longa.
    </p>
  </div>

  <div class="px-6 pb-6 flex items-center justify-between">
    <span class="text-xs text-slate-400">15 mar. 2026</span>
    <a href="#"
       class="text-sm font-semibold text-blue-700 hover:text-blue-800
              hover:underline focus-visible:outline focus-visible:outline-2
              focus-visible:outline-offset-2 focus-visible:outline-blue-600
              rounded">
      Leia mais →
    </a>
  </div>
</article>
```

### 12.7.3 — Navbar responsiva

```html
<header class="bg-slate-900 text-white shadow-lg sticky top-0 z-50">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between h-16">

      <!-- Logo *)
      <a href="/" class="flex items-center gap-2 font-bold text-lg
                         hover:text-blue-400 transition-colors">
        <img src="logo.svg" alt="IFAL" class="h-8 w-auto" />
        <span>PWEB1</span>
      </a>

      <!-- Links desktop: ocultos em mobile *)
      <nav class="hidden md:flex items-center gap-1"
           aria-label="Navegação principal">
        <a href="/"
           class="px-3 py-2 rounded-md text-sm font-medium
                  text-white hover:bg-slate-700 transition-colors
                  aria-[current=page]:bg-slate-700"
           aria-current="page">
          Início
        </a>
        <a href="/capitulos"
           class="px-3 py-2 rounded-md text-sm font-medium
                  text-slate-300 hover:text-white hover:bg-slate-700
                  transition-colors">
          Capítulos
        </a>
        <a href="/atividades"
           class="px-3 py-2 rounded-md text-sm font-medium
                  text-slate-300 hover:text-white hover:bg-slate-700
                  transition-colors">
          Atividades
        </a>
      </nav>

      <!-- Botão menu mobile *)
      <button class="md:hidden p-2 rounded-md text-slate-400
                     hover:text-white hover:bg-slate-700 transition-colors
                     focus-visible:outline focus-visible:outline-2
                     focus-visible:outline-white"
              aria-controls="menu-mobile"
              aria-expanded="false"
              aria-label="Abrir menu"
              type="button">
        <svg class="w-6 h-6" fill="none" stroke="currentColor"
             viewBox="0 0 24 24" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round"
                stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

    </div>
  </div>

  <!-- Menu mobile (toggle via JS) *)
  <div class="md:hidden hidden" id="menu-mobile">
    <nav class="px-2 pt-2 pb-3 space-y-1 border-t border-slate-700"
         aria-label="Menu mobile">
      <a href="/"
         class="block px-3 py-2 rounded-md text-base font-medium
                bg-slate-700 text-white">
        Início
      </a>
      <a href="/capitulos"
         class="block px-3 py-2 rounded-md text-base font-medium
                text-slate-300 hover:text-white hover:bg-slate-700
                transition-colors">
        Capítulos
      </a>
    </nav>
  </div>
</header>
```

### 12.7.4 — Formulário de contato estilizado

```html
<form class="max-w-lg mx-auto bg-white rounded-2xl shadow-lg p-8 space-y-6"
      action="/contato" method="post">

  <div class="space-y-1">
    <label class="block text-sm font-medium text-slate-700" for="nome">
      Nome completo <span class="text-red-500" aria-hidden="true">*</span>
    </label>
    <input class="w-full px-3 py-2 border border-slate-300 rounded-lg
                  text-slate-900 placeholder:text-slate-400
                  focus:outline-none focus:border-blue-500
                  focus:ring-2 focus:ring-blue-500/20
                  transition-shadow duration-200"
           type="text" id="nome" name="nome" required
           placeholder="Maria Silva" />
  </div>

  <div class="space-y-1">
    <label class="block text-sm font-medium text-slate-700" for="email">
      E-mail <span class="text-red-500" aria-hidden="true">*</span>
    </label>
    <input class="w-full px-3 py-2 border border-slate-300 rounded-lg
                  text-slate-900 placeholder:text-slate-400
                  focus:outline-none focus:border-blue-500
                  focus:ring-2 focus:ring-blue-500/20
                  transition-shadow duration-200"
           type="email" id="email" name="email" required
           placeholder="maria@exemplo.com" />
  </div>

  <div class="space-y-1">
    <label class="block text-sm font-medium text-slate-700" for="mensagem">
      Mensagem <span class="text-red-500" aria-hidden="true">*</span>
    </label>
    <textarea class="w-full px-3 py-2 border border-slate-300 rounded-lg
                     text-slate-900 placeholder:text-slate-400
                     focus:outline-none focus:border-blue-500
                     focus:ring-2 focus:ring-blue-500/20
                     transition-shadow duration-200 resize-y min-h-[120px]"
              id="mensagem" name="mensagem" rows="5" required
              placeholder="Sua mensagem..."></textarea>
  </div>

  <button class="w-full px-6 py-3 bg-blue-700 text-white font-semibold
                 rounded-lg hover:bg-blue-800 active:bg-blue-900
                 focus-visible:outline focus-visible:outline-2
                 focus-visible:outline-offset-2 focus-visible:outline-blue-600
                 disabled:opacity-50 disabled:cursor-not-allowed
                 transition-colors duration-200"
          type="submit">
    Enviar mensagem
  </button>

</form>
```

### 12.7.5 — A diretiva `@apply`: extraindo componentes reutilizáveis

Quando um mesmo conjunto de classes é repetido em muitos lugares, a diretiva `@apply` permite extrair essas classes para uma classe CSS reutilizável — mantendo os benefícios do utility-first sem duplicação:

```css
/* src/input.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer components {
  /* Componente btn extraído com @apply *)
  .btn {
    @apply inline-flex items-center justify-center gap-2
           px-4 py-2 rounded-lg font-semibold text-sm
           transition-colors duration-200 cursor-pointer
           focus-visible:outline focus-visible:outline-2
           focus-visible:outline-offset-2
           disabled:opacity-50 disabled:cursor-not-allowed;
  }

  .btn-primario {
    @apply bg-blue-700 text-white
           hover:bg-blue-800 active:bg-blue-900
           focus-visible:outline-blue-600;
  }

  .btn-secundario {
    @apply border-2 border-blue-700 text-blue-700 bg-transparent
           hover:bg-blue-50 active:bg-blue-100
           focus-visible:outline-blue-600;
  }

  .btn-perigo {
    @apply bg-red-600 text-white
           hover:bg-red-700 active:bg-red-800
           focus-visible:outline-red-600;
  }

  /* Componente campo extraído *)
  .campo {
    @apply flex flex-col gap-1;
  }

  .campo-label {
    @apply block text-sm font-medium text-slate-700;
  }

  .campo-input {
    @apply w-full px-3 py-2 border border-slate-300 rounded-lg
           text-slate-900 placeholder:text-slate-400
           focus:outline-none focus:border-blue-500
           focus:ring-2 focus:ring-blue-500/20
           transition-shadow duration-200;
  }
}
```

**Uso em HTML após extração:**

```html
<!-- Antes: classes repetidas em cada botão *)
<button class="inline-flex items-center px-4 py-2 rounded-lg font-semibold
               text-sm bg-blue-700 text-white hover:bg-blue-800 ...">
  Salvar
</button>

<!-- Depois: classes extraídas e reutilizáveis *)
<button class="btn btn-primario" type="button">Salvar</button>
<button class="btn btn-secundario" type="button">Cancelar</button>
<button class="btn btn-perigo" type="button">Excluir</button>
```

> **Quando usar `@apply`:** reserve `@apply` para componentes genuinamente reutilizados em múltiplos lugares — botões, campos de formulário, badges. Para elementos únicos, mantenha as classes diretamente no HTML. O uso excessivo de `@apply` reconstrói o CSS semântico que o utility-first foi criado para evitar.

---

## 12.8 — Customização do Tailwind

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 12.8.1 — Estendendo o tema: cores, fontes e espaçamentos personalizados

`theme.extend` adiciona valores ao tema padrão sem substituí-lo:

```javascript
// tailwind.config.js
module.exports = {
  content: ['./src/**/*.{html,js}'],
  theme: {
    extend: {
      // Cores customizadas — adicionadas à paleta existente
      colors: {
        'ifal': {
          50:  '#eff6ff',
          100: '#dbeafe',
          500: '#3b82f6',
          700: '#1d4ed8',
          900: '#1e3a8a',
        },
        'destaque': '#E8632A',
      },

      // Fontes customizadas
      fontFamily: {
        'sans': ['Inter', 'system-ui', 'sans-serif'],
        'serif': ['Merriweather', 'Georgia', 'serif'],
        'mono':  ['Fira Code', 'Consolas', 'monospace'],
      },

      // Espaçamentos adicionais à escala existente
      spacing: {
        '18': '4.5rem',
        '22': '5.5rem',
        '88': '22rem',
        '112': '28rem',
        '128': '32rem',
      },

      // Border radius customizado
      borderRadius: {
        '4xl': '2rem',
        '5xl': '2.5rem',
      },

      // Breakpoints adicionais
      screens: {
        'xs': '475px',
        '3xl': '1920px',
      },

      // max-width customizado
      maxWidth: {
        '8xl': '88rem',
        '9xl': '96rem',
      },
    },
  },
}
```

### 12.8.2 — Sobrescrevendo valores padrão

`theme.XXX` (sem `extend`) substitui completamente os valores padrão daquela categoria:

```javascript
module.exports = {
  theme: {
    // SUBSTITUI todos os breakpoints — use com cuidado
    screens: {
      'mobile': '375px',
      'tablet': '768px',
      'desktop': '1024px',
      'wide': '1440px',
    },

    // SUBSTITUI todas as cores — o projeto não terá blue, red, etc.
    // Use extend para ADICIONAR; use theme para SUBSTITUIR
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      white: '#ffffff',
      black: '#000000',
      primaria: { /* escala completa */ },
    },

    extend: {
      // Adições aqui não afetam as substituições acima
    },
  },
}
```

### 12.8.3 — Criando utilitários customizados com `@layer`

Para propriedades CSS não cobertas pelo Tailwind, `@layer utilities` adiciona utilities customizadas que se comportam como as nativas — incluindo suporte a variantes responsivas e de estado:

```css
@layer utilities {
  /* Utility customizada: scrollbar oculta *)
  .scrollbar-oculto {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }

  .scrollbar-oculto::-webkit-scrollbar {
    display: none;
  }

  /* Texto com gradiente *)
  .texto-gradiente {
    background-image: linear-gradient(135deg, #1d4ed8, #E8632A);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  /* Fundo com padrão *)
  .bg-grade {
    background-image:
      linear-gradient(rgba(0,0,0,0.05) 1px, transparent 1px),
      linear-gradient(90deg, rgba(0,0,0,0.05) 1px, transparent 1px);
    background-size: 20px 20px;
  }
}
```

### 12.8.4 — Relação entre tokens do Design System e o tema Tailwind

O Capítulo 11 construiu um Design System baseado em variáveis CSS com hierarquia de tokens. O Tailwind pode ser configurado para consumir esses tokens — mantendo consistência entre o sistema de design e o framework:

```javascript
// tailwind.config.js — consumindo tokens CSS como variáveis
module.exports = {
  theme: {
    extend: {
      colors: {
        // Referencia as variáveis CSS dos tokens semânticos
        'primaria':   'var(--cor-primaria)',
        'secundaria': 'var(--cor-secundaria)',
        'destaque':   'var(--cor-destaque)',
        'fundo':      'var(--cor-fundo-pagina)',
        'texto':      'var(--cor-texto-padrao)',
        'texto-2':    'var(--cor-texto-secundario)',
        'borda':      'var(--cor-borda-padrao)',
        'sucesso':    'var(--cor-sucesso)',
        'erro':       'var(--cor-erro)',
        'aviso':      'var(--cor-aviso)',
      },

      fontFamily: {
        'sem-serifa': 'var(--fonte-sem-serifa)',
        'serifa':     'var(--fonte-serifa)',
        'codigo':     'var(--fonte-codigo)',
      },

      borderRadius: {
        'sm':   'var(--raio-sm)',
        'md':   'var(--raio-md)',
        'lg':   'var(--raio-lg)',
        'xl':   'var(--raio-xl)',
        'full': 'var(--raio-circulo)',
      },
    },
  },
}
```

```html
<!-- Usando tokens do Design System via Tailwind *)
<button class="bg-primaria text-white font-semibold px-4 py-2
               rounded-md hover:bg-blue-800 transition-colors">
  Usa var(--cor-primaria)
</button>

<!-- Tema escuro funciona automaticamente porque --cor-primaria
     é redefinida na media query prefers-color-scheme: dark *)
```

Esta integração fecha o arco entre os Capítulos 11 e 12: o Design System define os tokens e as decisões de design; o Tailwind consome esses tokens como classes utilitárias. Mudanças nos tokens se propagam tanto para o CSS customizado quanto para o Tailwind — mantendo consistência em todo o projeto.

**Referências:**
- [Tailwind CSS — Documentação oficial](https://tailwindcss.com/docs)
- [Tailwind CSS — Customizing the theme](https://tailwindcss.com/docs/theme)
- [Tailwind CSS — Using CSS variables](https://tailwindcss.com/docs/customizing-colors#using-css-variables)
- [Adam Wathan — CSS Utility Classes and "Separation of Concerns"](https://adamwathan.me/css-utility-classes-and-separation-of-concerns/)
- [State of CSS 2024](https://2024.stateofcss.com)

---

#### **Atividades — Capítulo 12**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Qual é a diferença fundamental entre um framework utility-first como Tailwind e um framework component-based como Bootstrap?</p>
  <button data-option="a">Tailwind é mais rápido de aprender; Bootstrap é mais poderoso.</button>
  <button data-option="b">Bootstrap só funciona com jQuery; Tailwind funciona com qualquer tecnologia.</button>
  <button data-option="c">Bootstrap fornece componentes visuais prontos; Tailwind fornece classes de baixo nível que mapeiam para propriedades CSS individuais — o desenvolvedor compõe a interface combinando essas classes.</button>
  <button data-option="d">Tailwind gera CSS maior que Bootstrap porque inclui todas as propriedades possíveis.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Um elemento tem as classes <code>text-base md:text-lg lg:text-2xl</code>. Em um viewport de 900px, qual tamanho de fonte é aplicado?</p>
  <button data-option="a"><code>text-base</code> (1rem) — o prefixo <code>md:</code> aplica apenas em mobile.</button>
  <button data-option="b"><code>text-lg</code> (1.125rem) — 900px está acima de md (768px) mas abaixo de lg (1024px).</button>
  <button data-option="c"><code>text-2xl</code> (1.5rem) — o maior valor sempre prevalece.</button>
  <button data-option="d">Nenhum — classes com prefixo de breakpoint anulam as classes sem prefixo.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Quando é apropriado usar a diretiva <code>@apply</code> no Tailwind?</p>
  <button data-option="a">Em todos os componentes — <code>@apply</code> é a forma recomendada de usar Tailwind em projetos profissionais.</button>
  <button data-option="b">Nunca — <code>@apply</code> é uma funcionalidade legada que será removida em versões futuras.</button>
  <button data-option="c">Apenas em arquivos JavaScript, não em CSS.</button>
  <button data-option="d">Para componentes genuinamente reutilizados em múltiplos lugares (botões, campos de formulário) — evitar para elementos únicos, onde as classes diretamente no HTML são mais adequadas.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Reestilizar a landing page do 2º Bimestre usando Tailwind CSS: instalar via npm, configurar o tema com as cores e fontes do Design System do Capítulo 11, implementar a navbar responsiva com menu mobile, a seção de cards com hover states e o formulário de contato — tudo sem CSS customizado, usando apenas Tailwind. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 11 — Variáveis CSS e Design System](11-design-system.md)
[:material-arrow-right: Ir ao Capítulo 13 — JavaScript Essencial](13-javascript-essencial.md)
