# Capítulo 17 — Integração Frontend + API

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 17.1 — Arquitetura de uma SPA simples

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Nos capítulos anteriores, cada script JavaScript era um arquivo único responsável por tudo: buscar dados, manipular o DOM, gerenciar estado e lidar com eventos. Para projetos pequenos, isso é suficiente. À medida que a aplicação cresce — múltiplas telas, diversas chamadas de API, estado compartilhado entre componentes —, a ausência de organização transforma o código em um conjunto frágil e difícil de manter.

Este capítulo apresenta os padrões de organização que tornam projetos front-end reais sustentáveis, sem a necessidade de frameworks como React ou Vue — apenas JavaScript moderno com módulos ES6.

### 17.1.1 — O que é uma Single Page Application

Uma **SPA** (*Single Page Application*) é uma aplicação web que carrega um único documento HTML e atualiza dinamicamente seu conteúdo via JavaScript — sem recarregar a página ao navegar entre seções. A navegação é interceptada pelo JavaScript, que renderiza o conteúdo correto com base na URL atual.

```
Aplicação tradicional (MPA):           SPA:
┌──────────────────────┐               ┌──────────────────────┐
│ /index.html          │               │ /index.html          │
│ /produtos.html       │  vs.          │                      │
│ /produto-detalhe.html│               │ JavaScript controla  │
│ /carrinho.html       │               │ o que é exibido      │
│ /sobre.html          │               │ com base na URL      │
└──────────────────────┘               └──────────────────────┘
  Cada navegação =                       Navegação = JS
  novo request ao servidor               atualiza o DOM
```

**Vantagens de uma SPA:**
- Navegação mais rápida (sem recarregar a página inteira)
- Experiência mais fluida para o usuário
- Reutilização de componentes entre telas
- Estado da aplicação preservado entre navegações

**Limitações que devem ser conhecidas:**
- SEO mais complexo (conteúdo renderizado via JS)
- Carregamento inicial mais lento
- Gestão de histórico do navegador requer atenção

### 17.1.2 — Separação de responsabilidades

O princípio de **separação de responsabilidades** (*separation of concerns*) divide o código em camadas com funções bem definidas:

```
┌─────────────────────────────────────────────────┐
│                   UI Layer                       │
│  Renderização de HTML, manipulação de DOM,       │
│  event listeners, estados visuais               │
│  Arquivos: pages/, components/                  │
└─────────────────────┬───────────────────────────┘
                      │ chama
┌─────────────────────▼───────────────────────────┐
│                 State Layer                      │
│  Estado global da aplicação, notificação        │
│  de mudanças para a UI                          │
│  Arquivo: store.js                              │
└─────────────────────┬───────────────────────────┘
                      │ chama
┌─────────────────────▼───────────────────────────┐
│               Service Layer                      │
│  Comunicação com APIs, cache, transformação     │
│  de dados, tratamento de erros de rede          │
│  Arquivos: services/                            │
└─────────────────────────────────────────────────┘
```

**Regra fundamental:** a camada de UI **nunca** faz `fetch()` diretamente. Ela chama funções da camada de serviços. A camada de serviços **nunca** manipula o DOM. Essa separação permite testar cada camada isoladamente e trocar implementações sem cascata de mudanças.

### 17.1.3 — Módulos ES6: `import` e `export`

Os módulos ES6 permitem dividir o código em arquivos com escopos isolados, exportando apenas o que deve ser público:

```javascript
// ── services/api.js ──────────────────────────────────────

// Export nomeado: exporta uma função específica
export async function buscarDados(url, opcoes = {}) {
  const resposta = await fetch(url, opcoes);
  if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
  return resposta.json();
}

export function construirUrl(base, params = {}) {
  const url = new URL(base);
  Object.entries(params).forEach(([k, v]) => {
    if (v !== null && v !== undefined) url.searchParams.set(k, v);
  });
  return url.toString();
}

// Export padrão: um único export principal por arquivo
export default class ApiClient {
  constructor(baseUrl, opcoesPadrao = {}) {
    this.baseUrl = baseUrl;
    this.opcoesPadrao = opcoesPadrao;
  }

  async get(endpoint, params = {}) {
    const url = construirUrl(`${this.baseUrl}${endpoint}`, params);
    return buscarDados(url, this.opcoesPadrao);
  }

  async post(endpoint, dados) {
    return buscarDados(`${this.baseUrl}${endpoint}`, {
      ...this.opcoesPadrao,
      method: 'POST',
      headers: { 'Content-Type': 'application/json',
                 ...this.opcoesPadrao.headers },
      body: JSON.stringify(dados)
    });
  }
}
```

```javascript
// ── app.js — importando ──────────────────────────────────

// Import nomeado
import { buscarDados, construirUrl } from './services/api.js';

// Import padrão
import ApiClient from './services/api.js';

// Import misto
import ApiClient, { buscarDados } from './services/api.js';

// Import com alias
import { buscarDados as fetchData } from './services/api.js';

// Import de namespace
import * as Api from './services/api.js';
// Api.buscarDados(...), Api.construirUrl(...)

// Import dinâmico (lazy loading — carrega quando necessário)
const { renderizarGrafico } = await import('./components/grafico.js');
```

> **Importante:** módulos ES6 só funcionam com o protocolo HTTP/HTTPS — não funcionam com `file://`. Para desenvolvimento local, é necessário um servidor local simples. A extensão **Live Server** do VS Code resolve isso com um clique.

```html
<!-- Declarar o script de entrada como módulo -->
<script type="module" src="js/app.js"></script>
```

### 17.1.4 — Organização de arquivos para projetos com API

```
projeto/
├── index.html
├── css/
│   ├── variables.css
│   ├── base.css
│   ├── components.css
│   └── pages.css
└── js/
    ├── app.js              ← entrada: inicializa router e estado global
    ├── router.js           ← roteamento baseado em hash
    ├── store.js            ← estado global simplificado
    ├── services/
    │   ├── api.js          ← cliente HTTP genérico
    │   ├── produtos.js     ← serviços específicos de produtos
    │   └── usuarios.js     ← serviços específicos de usuários
    ├── components/
    │   ├── card.js         ← componente de card reutilizável
    │   ├── modal.js        ← componente modal
    │   └── paginacao.js    ← componente de paginação
    └── pages/
        ├── listagem.js     ← página de listagem
        ├── detalhe.js      ← página de detalhe
        └── formulario.js   ← página de formulário
```

---

## 17.2 — Renderização dinâmica de dados

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 17.2.1 — Do JSON ao HTML: padrões de renderização

O processo de converter dados JSON em HTML é o núcleo do desenvolvimento frontend com APIs. Existem três abordagens principais, cada uma com trade-offs:

```javascript
// Abordagem 1: innerHTML com template literal
// Rápida e legível, mas requer cuidado com XSS
function renderizarCard(produto) {
  return `
    <article class="card" data-id="${produto.id}">
      <img src="${produto.imagem}" alt="${escapar(produto.nome)}" loading="lazy" />
      <div class="card__corpo">
        <h2 class="card__titulo">${escapar(produto.nome)}</h2>
        <p class="card__preco">R$ ${produto.preco.toFixed(2)}</p>
      </div>
    </article>
  `;
}

// Abordagem 2: createElement (sem risco de XSS, mais verboso)
function criarCardSeguro(produto) {
  const article = document.createElement('article');
  article.className = 'card';
  article.dataset.id = produto.id;

  const img = document.createElement('img');
  img.src = produto.imagem;
  img.alt = produto.nome; // textContent é safe por padrão
  img.loading = 'lazy';

  const titulo = document.createElement('h2');
  titulo.className = 'card__titulo';
  titulo.textContent = produto.nome; // textContent nunca interpreta HTML

  article.appendChild(img);
  article.appendChild(titulo);
  return article;
}

// Abordagem 3: <template> HTML (melhor performance, reutilizável)
// HTML: <template id="card-template">...</template>
function criarCardComTemplate(produto) {
  const template = document.getElementById('card-template');
  const clone = template.content.cloneNode(true);

  clone.querySelector('.card__titulo').textContent = produto.nome;
  clone.querySelector('.card__preco').textContent =
    `R$ ${produto.preco.toFixed(2)}`;
  clone.querySelector('img').src = produto.imagem;
  clone.querySelector('img').alt = produto.nome;
  clone.querySelector('.card').dataset.id = produto.id;

  return clone;
}

// Função auxiliar de escape para uso seguro com innerHTML
function escapar(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}
```

### 17.2.2 — Renderização de listas com `map()` e Fragment

```javascript
// Renderização eficiente de listas usando DocumentFragment
function renderizarLista(container, itens, renderizarItem) {
  container.innerHTML = '';
  const fragment = document.createDocumentFragment();
  itens.forEach(item => fragment.appendChild(renderizarItem(item)));
  container.appendChild(fragment);
}

// Renderização com innerHTML (para HTML complexo)
function renderizarListaHTML(container, itens, renderizarItem) {
  container.innerHTML = itens.map(renderizarItem).join('');
}

// Exemplo de uso
const produtos = await ProdutosService.listar();
const lista = document.querySelector('#lista-produtos');
renderizarListaHTML(lista, produtos, renderizarCard);
```

### 17.2.3 — Atualização parcial do DOM

Rerenderizar a lista inteira a cada mudança é ineficiente e destrói o estado visual (scroll position, foco, animações em andamento). A atualização parcial preserva o que não mudou:

```javascript
// Atualizar apenas um item específico na lista
function atualizarItemNaLista(id, novosDados) {
  const itemEl = document.querySelector(`[data-id="${id}"]`);
  if (!itemEl) return;

  // Atualizar apenas os campos que mudaram
  const tituloEl = itemEl.querySelector('.card__titulo');
  if (tituloEl && novosDados.nome) {
    tituloEl.textContent = novosDados.nome;
  }

  const precoEl = itemEl.querySelector('.card__preco');
  if (precoEl && novosDados.preco !== undefined) {
    precoEl.textContent = `R$ ${novosDados.preco.toFixed(2)}`;
  }
}

// Remover item sem re-renderizar a lista
function removerItemDaLista(id) {
  const itemEl = document.querySelector(`[data-id="${id}"]`);
  if (!itemEl) return;

  // Animação de saída antes de remover
  itemEl.classList.add('saindo');
  itemEl.addEventListener('animationend', () => itemEl.remove(), { once: true });
}

// Adicionar item sem re-renderizar a lista
function adicionarItemNaLista(container, novoItem, renderizarItem) {
  const novoEl = renderizarItem(novoItem);
  novoEl.classList.add('entrando');
  container.prepend(novoEl); // adiciona no início
}
```

### 17.2.4 — Exercício prático: listagem com filtro e ordenação

```javascript
// Estado local da listagem
const estadoListagem = {
  todos: [],        // dados originais da API
  filtrados: [],    // dados após filtros
  filtros: {
    busca: '',
    categoria: '',
    precoMax: Infinity,
  },
  ordenacao: {
    campo: 'nome',
    direcao: 'asc',
  },
  pagina: 1,
  porPagina: 12,
};

// Aplicar filtros e ordenação
function aplicarFiltrosOrdenacao() {
  let resultado = [...estadoListagem.todos];

  // Filtros
  const { busca, categoria, precoMax } = estadoListagem.filtros;

  if (busca) {
    const termo = busca.toLowerCase();
    resultado = resultado.filter(p =>
      p.nome.toLowerCase().includes(termo) ||
      p.descricao?.toLowerCase().includes(termo)
    );
  }

  if (categoria) {
    resultado = resultado.filter(p => p.categoria === categoria);
  }

  if (precoMax < Infinity) {
    resultado = resultado.filter(p => p.preco <= precoMax);
  }

  // Ordenação
  const { campo, direcao } = estadoListagem.ordenacao;
  resultado.sort((a, b) => {
    let valA = a[campo];
    let valB = b[campo];

    if (typeof valA === 'string') valA = valA.toLowerCase();
    if (typeof valB === 'string') valB = valB.toLowerCase();

    const comparacao = valA < valB ? -1 : valA > valB ? 1 : 0;
    return direcao === 'asc' ? comparacao : -comparacao;
  });

  estadoListagem.filtrados = resultado;
  estadoListagem.pagina = 1; // voltar à primeira página ao filtrar
  renderizarPaginaAtual();
  atualizarContador();
}

// Renderizar apenas a página atual
function renderizarPaginaAtual() {
  const { filtrados, pagina, porPagina } = estadoListagem;
  const inicio = (pagina - 1) * porPagina;
  const fim = inicio + porPagina;
  const itensPagina = filtrados.slice(inicio, fim);

  const container = document.querySelector('#lista-produtos');
  const ui = new EstadoUI('#lista-produtos');

  if (!itensPagina.length) {
    ui.vazio('Nenhum produto encontrado para os filtros aplicados.');
    return;
  }

  renderizarListaHTML(container, itensPagina, renderizarCard);
  renderizarPaginacao(filtrados.length);
}

function atualizarContador() {
  const el = document.querySelector('#contador-resultados');
  if (el) {
    el.textContent = `${estadoListagem.filtrados.length} produto(s) encontrado(s)`;
  }
}

// Event listeners para filtros
document.querySelector('#busca-produto')?.addEventListener('input',
  debounce((e) => {
    estadoListagem.filtros.busca = e.target.value;
    aplicarFiltrosOrdenacao();
  }, 300)
);

document.querySelector('#filtro-categoria')?.addEventListener('change', (e) => {
  estadoListagem.filtros.categoria = e.target.value;
  aplicarFiltrosOrdenacao();
});

document.querySelector('#ordenar-por')?.addEventListener('change', (e) => {
  const [campo, direcao] = e.target.value.split(':');
  estadoListagem.ordenacao = { campo, direcao };
  aplicarFiltrosOrdenacao();
});

// Carregamento inicial
async function inicializarListagem() {
  const ui = new EstadoUI('#lista-produtos');
  ui.carregando('Carregando produtos...');

  try {
    estadoListagem.todos = await ProdutosService.listar();
    estadoListagem.filtrados = [...estadoListagem.todos];
    renderizarPaginaAtual();
    await popularFiltros();
  } catch (erro) {
    ui.erro('Erro ao carregar produtos.', inicializarListagem);
  }
}
```

---

## 17.3 — Busca dinâmica com API

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 17.3.1 — Debounce: evitando requisições excessivas

Sem debounce, cada tecla digitada em um campo de busca dispara uma requisição. Em uma digitação de 10 caracteres, isso gera 10 requisições — 9 das quais são desnecessárias:

```javascript
// Implementação de debounce
function debounce(fn, espera) {
  let timeout;
  return function(...args) {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn.apply(this, args), espera);
  };
}

// Implementação de throttle (para scroll, resize)
function throttle(fn, limite) {
  let emEspera = false;
  return function(...args) {
    if (emEspera) return;
    fn.apply(this, args);
    emEspera = true;
    setTimeout(() => { emEspera = false; }, limite);
  };
}

// Busca com debounce de 300ms
const buscarComDebounce = debounce(async (termo) => {
  if (!termo.trim()) {
    limparResultados();
    return;
  }

  await executarBusca(termo);
}, 300);

document.querySelector('#campo-busca').addEventListener('input', (e) => {
  buscarComDebounce(e.target.value);
});
```

### 17.3.2 — Cancelamento de requisições com `AbortController`

O debounce evita requisições desnecessárias, mas não resolve o problema de **race condition**: se o usuário digitar "re", depois "reac" rapidamente, e a resposta de "re" chegar depois da de "reac", o resultado errado será exibido.

```javascript
// Solução: cancelar a requisição anterior ao iniciar uma nova
let controladorAtual = null;

async function executarBusca(termo) {
  // Cancelar requisição anterior se ainda estiver em andamento
  if (controladorAtual) {
    controladorAtual.abort();
  }

  controladorAtual = new AbortController();
  const { signal } = controladorAtual;

  const ui = new EstadoUI('#resultados-busca');
  ui.carregando(`Buscando "${termo}"...`);

  try {
    const url = construirUrl('https://api.github.com/search/repositories', {
      q: termo,
      sort: 'stars',
      per_page: 10
    });

    const resposta = await fetch(url, { signal });
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);

    const dados = await resposta.json();
    controladorAtual = null; // limpa após sucesso

    if (!dados.items.length) {
      ui.vazio(`Nenhum resultado para "${termo}".`);
      return;
    }

    ui.sucesso(renderizarResultadosBusca(dados.items, dados.total_count));

  } catch (erro) {
    // AbortError é esperado — não é um erro real
    if (erro.name === 'AbortError') return;

    ui.erro('Erro ao buscar. Tente novamente.');
    console.error('Erro na busca:', erro);
  }
}
```

### 17.3.3 — Cache simples no cliente

```javascript
// Cache em memória usando Map
class CacheAPI {
  #cache = new Map();
  #ttl;   // tempo de vida em ms

  constructor(ttlMs = 5 * 60 * 1000) { // 5 minutos padrão
    this.#ttl = ttlMs;
  }

  set(chave, valor) {
    this.#cache.set(chave, {
      valor,
      expira: Date.now() + this.#ttl
    });
  }

  get(chave) {
    const item = this.#cache.get(chave);
    if (!item) return null;
    if (Date.now() > item.expira) {
      this.#cache.delete(chave);
      return null;
    }
    return item.valor;
  }

  has(chave) { return this.get(chave) !== null; }
  clear()    { this.#cache.clear(); }
  delete(chave) { this.#cache.delete(chave); }
}

// Wrapper fetch com cache
const cache = new CacheAPI(2 * 60 * 1000); // 2 minutos

async function buscarComCache(url) {
  // Retornar do cache se disponível
  if (cache.has(url)) {
    return cache.get(url);
  }

  const dados = await buscarDados(url);
  cache.set(url, dados);
  return dados;
}
```

### 17.3.4 — Exercício prático: busca de repositórios no GitHub

```html
<div class="busca-github">
  <form class="busca-form" id="form-github" novalidate>
    <div class="busca-campo">
      <label for="busca-repo" class="sr-only">Buscar repositórios</label>
      <input
        type="search"
        id="busca-repo"
        placeholder="Buscar repositórios no GitHub..."
        autocomplete="off"
        aria-label="Buscar repositórios no GitHub"
      />
    </div>

    <div class="busca-filtros">
      <select id="linguagem-filtro" aria-label="Filtrar por linguagem">
        <option value="">Todas as linguagens</option>
        <option value="javascript">JavaScript</option>
        <option value="typescript">TypeScript</option>
        <option value="python">Python</option>
        <option value="java">Java</option>
      </select>

      <select id="ordenar-github" aria-label="Ordenar por">
        <option value="stars">Mais estrelas</option>
        <option value="forks">Mais forks</option>
        <option value="updated">Atualizado recentemente</option>
      </select>
    </div>
  </form>

  <p id="total-resultados" aria-live="polite" class="sr-only"></p>
  <div id="resultados-github"></div>
</div>
```

```javascript
// Serviço GitHub
class GitHubService {
  static BASE = 'https://api.github.com';
  static #cache = new CacheAPI(5 * 60 * 1000);

  static async buscarRepositorios(params) {
    const { termo, linguagem, ordenar = 'stars', pagina = 1 } = params;

    let query = termo;
    if (linguagem) query += ` language:${linguagem}`;

    const url = construirUrl(`${this.BASE}/search/repositories`, {
      q: query,
      sort: ordenar,
      order: 'desc',
      per_page: 12,
      page: pagina,
    });

    if (this.#cache.has(url)) return this.#cache.get(url);

    const resposta = await fetch(url, {
      headers: { 'Accept': 'application/vnd.github.v3+json' }
    });

    if (resposta.status === 403) {
      throw new Error('Limite de requisições excedido. Aguarde um momento.');
    }

    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);

    const dados = await resposta.json();
    this.#cache.set(url, dados);
    return dados;
  }

  static async buscarUsuario(login) {
    const url = `${this.BASE}/users/${login}`;
    if (this.#cache.has(url)) return this.#cache.get(url);
    const dados = await buscarDados(url);
    this.#cache.set(url, dados);
    return dados;
  }
}

// Renderização
function renderizarRepositorio(repo) {
  const linguagemHtml = repo.language
    ? `<span class="repo__linguagem">${escapar(repo.language)}</span>`
    : '';

  return `
    <article class="repo-card" data-id="${repo.id}">
      <div class="repo-card__cabecalho">
        <img
          src="${repo.owner.avatar_url}"
          alt="${escapar(repo.owner.login)}"
          class="repo-card__avatar"
          loading="lazy"
        />
        <div>
          <h3 class="repo-card__titulo">
            <a href="${repo.html_url}" target="_blank" rel="noopener noreferrer"
               class="repo-card__link">
              ${escapar(repo.full_name)}
            </a>
          </h3>
          ${linguagemHtml}
        </div>
      </div>

      ${repo.description ? `
        <p class="repo-card__descricao">
          ${escapar(repo.description)}
        </p>
      ` : ''}

      <div class="repo-card__stats">
        <span title="Estrelas">⭐ ${formatarNumero(repo.stargazers_count)}</span>
        <span title="Forks">🍴 ${formatarNumero(repo.forks_count)}</span>
        <span title="Issues abertas">🐛 ${formatarNumero(repo.open_issues_count)}</span>
        <span title="Última atualização">
          📅 ${formatarData(repo.updated_at)}
        </span>
      </div>
    </article>
  `;
}

// Controlador da busca
let abortController = null;
const cacheBusca = new CacheAPI(2 * 60 * 1000);

const buscarComDebounce = debounce(async () => {
  const termo = document.getElementById('busca-repo').value.trim();
  const linguagem = document.getElementById('linguagem-filtro').value;
  const ordenar = document.getElementById('ordenar-github').value;

  if (!termo) {
    document.getElementById('resultados-github').innerHTML = '';
    return;
  }

  if (abortController) abortController.abort();
  abortController = new AbortController();

  const ui = new EstadoUI('#resultados-github');
  ui.carregando('Buscando repositórios...');

  try {
    const dados = await GitHubService.buscarRepositorios({
      termo, linguagem, ordenar
    });

    document.getElementById('total-resultados').textContent =
      `${dados.total_count.toLocaleString('pt-BR')} repositórios encontrados`;

    if (!dados.items.length) {
      ui.vazio('Nenhum repositório encontrado.');
      return;
    }

    const html = `
      <p class="resultados-info">
        ${dados.total_count.toLocaleString('pt-BR')} resultados
        ${linguagem ? `em ${linguagem}` : ''}
      </p>
      <div class="repos-grid">
        ${dados.items.map(renderizarRepositorio).join('')}
      </div>
    `;

    ui.sucesso(html);
    abortController = null;

  } catch (erro) {
    if (erro.name === 'AbortError') return;
    ui.erro(erro.message || 'Erro ao buscar repositórios.', buscarComDebounce);
  }
}, 400);

// Inicializar
['busca-repo', 'linguagem-filtro', 'ordenar-github'].forEach(id => {
  document.getElementById(id)?.addEventListener('input', buscarComDebounce);
  document.getElementById(id)?.addEventListener('change', buscarComDebounce);
});

// Utilitários
function formatarNumero(n) {
  if (n >= 1000) return (n / 1000).toFixed(1) + 'k';
  return n.toString();
}

function formatarData(iso) {
  return new Date(iso).toLocaleDateString('pt-BR', {
    day: '2-digit', month: 'short', year: 'numeric'
  });
}
```

---

## 17.4 — Aplicação completa: listagem, detalhe e busca

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 17.4.1 — Roteamento simples via hash

O roteamento baseado em hash (`#`) utiliza a parte da URL após `#` para determinar qual "página" exibir — sem recarregar o documento:

```javascript
// router.js
class Router {
  #rotas = new Map();
  #rotaAtual = null;
  #rotaNotFound = null;

  // Registrar rota
  on(caminho, handler) {
    this.#rotas.set(caminho, handler);
    return this;
  }

  notFound(handler) {
    this.#rotaNotFound = handler;
    return this;
  }

  // Inicializar: ouvir mudanças de hash e rota inicial
  inicializar() {
    window.addEventListener('hashchange', () => this.#navegar());
    this.#navegar(); // processar rota inicial
    return this;
  }

  #navegar() {
    const hash = window.location.hash.slice(1) || '/'; // remove o #
    const [caminho, ...query] = hash.split('?');

    // Buscar rota exata
    if (this.#rotas.has(caminho)) {
      const params = Object.fromEntries(
        new URLSearchParams(query.join('?'))
      );
      this.#rotas.get(caminho)(params);
      this.#rotaAtual = caminho;
      return;
    }

    // Buscar rota com parâmetros (ex.: /produtos/:id)
    for (const [padrao, handler] of this.#rotas) {
      const match = this.#matchRota(padrao, caminho);
      if (match) {
        handler(match);
        this.#rotaAtual = caminho;
        return;
      }
    }

    // Rota não encontrada
    this.#rotaNotFound?.();
  }

  #matchRota(padrao, caminho) {
    const partesP = padrao.split('/');
    const partesC = caminho.split('/');
    if (partesP.length !== partesC.length) return null;

    const params = {};
    for (let i = 0; i < partesP.length; i++) {
      if (partesP[i].startsWith(':')) {
        params[partesP[i].slice(1)] = decodeURIComponent(partesC[i]);
      } else if (partesP[i] !== partesC[i]) {
        return null;
      }
    }
    return params;
  }

  // Navegar programaticamente
  static ir(caminho) {
    window.location.hash = caminho;
  }
}

// app.js — configurando o router
import Router from './router.js';
import { renderizarListagem } from './pages/listagem.js';
import { renderizarDetalhe } from './pages/detalhe.js';

const router = new Router();

router
  .on('/',             () => renderizarListagem())
  .on('/produtos',     () => renderizarListagem())
  .on('/produtos/:id', ({ id }) => renderizarDetalhe(id))
  .on('/sobre',        () => renderizarSobre())
  .notFound(          () => renderizarNotFound())
  .inicializar();
```

### 17.4.2 — Tela de listagem com paginação

```javascript
// pages/listagem.js
import ProdutosService from '../services/produtos.js';
import { renderizarCard } from '../components/card.js';
import Router from '../router.js';

export async function renderizarListagem(params = {}) {
  const app = document.getElementById('app');
  const pagina = parseInt(params.pagina) || 1;
  const busca  = params.busca || '';

  app.innerHTML = `
    <section class="listagem" aria-labelledby="titulo-listagem">
      <header class="listagem__cabecalho">
        <h1 id="titulo-listagem">Produtos</h1>
        <form class="listagem__busca" id="form-busca">
          <input type="search" name="busca" value="${escapar(busca)}"
                 placeholder="Buscar produtos..." aria-label="Buscar" />
          <button type="submit" class="btn btn--primario">Buscar</button>
        </form>
      </header>

      <div id="conteudo-listagem" aria-live="polite" aria-busy="true">
        <div class="skeleton-grid">
          ${Array(12).fill('<div class="skeleton skeleton--card"></div>').join('')}
        </div>
      </div>
    </section>
  `;

  // Form de busca
  document.getElementById('form-busca').addEventListener('submit', (e) => {
    e.preventDefault();
    const termo = e.target.busca.value.trim();
    Router.ir(`/produtos?busca=${encodeURIComponent(termo)}&pagina=1`);
  });

  try {
    const resultado = await ProdutosService.listar({ busca, pagina });
    const conteudo = document.getElementById('conteudo-listagem');
    conteudo.setAttribute('aria-busy', 'false');

    if (!resultado.dados.length) {
      conteudo.innerHTML = `
        <div class="estado estado--vazio">
          <p>Nenhum produto encontrado${busca ? ` para "${escapar(busca)}"` : ''}.</p>
          ${busca ? `<a href="#/produtos" class="btn btn--secundario">Ver todos</a>` : ''}
        </div>
      `;
      return;
    }

    conteudo.innerHTML = `
      <p class="listagem__total">${resultado.total} produto(s)</p>
      <div class="grade-produtos" id="grade-produtos">
        ${resultado.dados.map(renderizarCard).join('')}
      </div>
      ${renderizarPaginacao(resultado.total, resultado.porPagina, pagina, busca)}
    `;

    // Delegação de eventos nos cards
    document.getElementById('grade-produtos').addEventListener('click', (e) => {
      const card = e.target.closest('[data-id]');
      if (card) Router.ir(`/produtos/${card.dataset.id}`);
    });

  } catch (erro) {
    document.getElementById('conteudo-listagem').innerHTML = `
      <div class="estado estado--erro" role="alert">
        <p>Erro ao carregar produtos. Tente novamente.</p>
        <button type="button" class="btn btn--secundario"
                onclick="renderizarListagem(${JSON.stringify({ busca, pagina })})">
          Tentar novamente
        </button>
      </div>
    `;
  }
}

function renderizarPaginacao(total, porPagina, paginaAtual, busca = '') {
  const totalPaginas = Math.ceil(total / porPagina);
  if (totalPaginas <= 1) return '';

  const parametroBusca = busca ? `busca=${encodeURIComponent(busca)}&` : '';

  const botoes = Array.from({ length: totalPaginas }, (_, i) => {
    const p = i + 1;
    const ativo = p === paginaAtual;
    return `
      <li>
        <a
          href="#/produtos?${parametroBusca}pagina=${p}"
          class="paginacao__botao ${ativo ? 'paginacao__botao--ativo' : ''}"
          aria-label="Página ${p}"
          ${ativo ? 'aria-current="page"' : ''}
        >${p}</a>
      </li>
    `;
  }).join('');

  return `
    <nav class="paginacao" aria-label="Paginação">
      <ul class="paginacao__lista">
        ${paginaAtual > 1 ? `
          <li>
            <a href="#/produtos?${parametroBusca}pagina=${paginaAtual - 1}"
               class="paginacao__botao" aria-label="Página anterior">
              ← Anterior
            </a>
          </li>
        ` : ''}
        ${botoes}
        ${paginaAtual < totalPaginas ? `
          <li>
            <a href="#/produtos?${parametroBusca}pagina=${paginaAtual + 1}"
               class="paginacao__botao" aria-label="Próxima página">
              Próxima →
            </a>
          </li>
        ` : ''}
      </ul>
    </nav>
  `;
}
```

### 17.4.3 — Tela de detalhe com parâmetros de rota

```javascript
// pages/detalhe.js
import ProdutosService from '../services/produtos.js';
import Router from '../router.js';

export async function renderizarDetalhe(id) {
  const app = document.getElementById('app');

  // Esqueleto imediato
  app.innerHTML = `
    <section class="detalhe" aria-labelledby="titulo-detalhe">
      <a href="#/produtos" class="voltar-link">← Voltar</a>
      <div id="conteudo-detalhe" aria-live="polite" aria-busy="true">
        <div class="skeleton-detalhe">
          <div class="skeleton skeleton--imagem"></div>
          <div class="skeleton-info">
            <div class="skeleton skeleton--titulo"></div>
            <div class="skeleton skeleton--texto"></div>
            <div class="skeleton skeleton--texto skeleton--curto"></div>
          </div>
        </div>
      </div>
    </section>
  `;

  try {
    const produto = await ProdutosService.buscarPorId(id);
    const conteudo = document.getElementById('conteudo-detalhe');
    conteudo.setAttribute('aria-busy', 'false');

    conteudo.innerHTML = `
      <article class="produto-detalhe">
        <div class="produto-detalhe__galeria">
          <img
            src="${escapar(produto.imagem)}"
            alt="${escapar(produto.nome)}"
            class="produto-detalhe__imagem"
          />
        </div>

        <div class="produto-detalhe__info">
          <span class="produto-detalhe__categoria">
            ${escapar(produto.categoria)}
          </span>
          <h1 class="produto-detalhe__titulo" id="titulo-detalhe">
            ${escapar(produto.nome)}
          </h1>
          <p class="produto-detalhe__preco">
            R$ ${produto.preco.toFixed(2)}
          </p>
          <div class="produto-detalhe__avaliacao" aria-label="Avaliação">
            ${renderizarEstrelas(produto.avaliacao)}
            <span>(${produto.totalAvaliacoes} avaliações)</span>
          </div>
          <p class="produto-detalhe__descricao">
            ${escapar(produto.descricao)}
          </p>
          <div class="produto-detalhe__acoes">
            <div class="quantidade">
              <button type="button" class="btn-quantidade" id="btn-menos"
                      aria-label="Diminuir quantidade">−</button>
              <input type="number" id="quantidade" value="1" min="1"
                     max="${produto.estoque}" aria-label="Quantidade" />
              <button type="button" class="btn-quantidade" id="btn-mais"
                      aria-label="Aumentar quantidade">+</button>
            </div>
            <button type="button" class="btn btn--primario btn--bloco"
                    id="btn-adicionar">
              Adicionar ao carrinho
            </button>
          </div>
          <p class="produto-detalhe__estoque">
            ${produto.estoque > 0
              ? `${produto.estoque} unidades disponíveis`
              : '<strong>Esgotado</strong>'}
          </p>
        </div>
      </article>
    `;

    inicializarControlesQuantidade(produto.estoque);
    document.getElementById('btn-adicionar').addEventListener('click', () => {
      const qtd = parseInt(document.getElementById('quantidade').value);
      adicionarAoCarrinho(produto, qtd);
    });

  } catch (erro) {
    document.getElementById('conteudo-detalhe').innerHTML = `
      <div class="estado estado--erro" role="alert">
        <p>${erro.status === 404 ? 'Produto não encontrado.' : 'Erro ao carregar produto.'}</p>
        <a href="#/produtos" class="btn btn--secundario">Ver todos os produtos</a>
      </div>
    `;
  }
}

function renderizarEstrelas(nota) {
  return Array.from({ length: 5 }, (_, i) => {
    if (i < Math.floor(nota)) return '★';
    if (i < nota) return '⯨'; // meia estrela
    return '☆';
  }).join('');
}

function inicializarControlesQuantidade(max) {
  const input = document.getElementById('quantidade');
  document.getElementById('btn-menos').addEventListener('click', () => {
    input.value = Math.max(1, parseInt(input.value) - 1);
  });
  document.getElementById('btn-mais').addEventListener('click', () => {
    input.value = Math.min(max, parseInt(input.value) + 1);
  });
}
```

### 17.4.4 — Estado global simples sem framework

```javascript
// store.js — estado global reativo sem framework
class Store {
  #estado;
  #ouvintes = new Map();

  constructor(estadoInicial) {
    this.#estado = estadoInicial;
  }

  // Ler estado (imutável externamente)
  get(chave) {
    return structuredClone(this.#estado[chave]);
  }

  getAll() {
    return structuredClone(this.#estado);
  }

  // Atualizar estado
  set(chave, valor) {
    const anterior = this.#estado[chave];
    this.#estado[chave] = valor;

    // Notificar ouvintes
    this.#notificar(chave, valor, anterior);
    this.#notificar('*', this.#estado, this.#estado);
  }

  // Atualização parcial de objeto
  merge(chave, parcial) {
    const atual = this.#estado[chave];
    if (typeof atual !== 'object') throw new Error(`${chave} não é objeto`);
    this.set(chave, { ...atual, ...parcial });
  }

  // Inscrever em mudanças
  subscribe(chave, callback) {
    if (!this.#ouvintes.has(chave)) {
      this.#ouvintes.set(chave, new Set());
    }
    this.#ouvintes.get(chave).add(callback);

    // Retorna função de cancelamento
    return () => this.#ouvintes.get(chave)?.delete(callback);
  }

  #notificar(chave, novoValor, valorAnterior) {
    this.#ouvintes.get(chave)?.forEach(cb => cb(novoValor, valorAnterior));
  }
}

// Estado global da aplicação
export const store = new Store({
  usuario: null,
  carrinho: { itens: [], total: 0 },
  tema: localStorage.getItem('tema') || 'claro',
  notificacoes: [],
});

// Persistir tema no localStorage
store.subscribe('tema', (novoTema) => {
  localStorage.setItem('tema', novoTema);
  document.documentElement.dataset.tema = novoTema;
});

// Atualizar badge do carrinho ao mudar
store.subscribe('carrinho', (carrinho) => {
  const badge = document.getElementById('badge-carrinho');
  if (badge) {
    const total = carrinho.itens.reduce((s, i) => s + i.quantidade, 0);
    badge.textContent = total;
    badge.hidden = total === 0;
  }
});

// Uso
store.set('tema', 'escuro');
store.merge('carrinho', {
  itens: [...store.get('carrinho').itens, { id: 1, nome: 'Produto', quantidade: 1 }]
});
```

### 17.4.5 — Exercício prático: catálogo de filmes com OMDb API

```javascript
// Documentação: https://www.omdbapi.com
// Requer chave de API gratuita (1000 req/dia)

class OMDbService {
  static #apiKey = 'SUA_CHAVE_AQUI';
  static BASE = 'https://www.omdbapi.com';
  static #cache = new CacheAPI(10 * 60 * 1000); // 10 min

  static async buscar(params) {
    const url = construirUrl(this.BASE, {
      apikey: this.#apiKey,
      ...params
    });

    if (this.#cache.has(url)) return this.#cache.get(url);

    const dados = await buscarDados(url);

    if (dados.Response === 'False') {
      throw new Error(dados.Error || 'Erro na API');
    }

    this.#cache.set(url, dados);
    return dados;
  }

  static async pesquisar(titulo, tipo = '', pagina = 1) {
    return this.buscar({
      s: titulo,
      type: tipo || undefined,
      page: pagina
    });
  }

  static async detalhe(imdbId) {
    return this.buscar({ i: imdbId, plot: 'full' });
  }
}

// Página de catálogo de filmes
export async function renderizarCatalogo(params = {}) {
  const app = document.getElementById('app');
  const busca = params.busca || 'Matrix';
  const tipo  = params.tipo || '';
  const pagina = parseInt(params.pagina) || 1;

  app.innerHTML = `
    <main class="catalogo" aria-labelledby="titulo-catalogo">
      <header class="catalogo__cabecalho">
        <h1 id="titulo-catalogo">🎬 Catálogo de Filmes</h1>
        <form id="form-busca-filmes">
          <input type="search" id="busca-filmes" value="${escapar(busca)}"
                 placeholder="Buscar filmes, séries..." />
          <select id="tipo-filtro">
            <option value="">Todos</option>
            <option value="movie" ${tipo === 'movie' ? 'selected' : ''}>Filmes</option>
            <option value="series" ${tipo === 'series' ? 'selected' : ''}>Séries</option>
          </select>
          <button type="submit" class="btn btn--primario">Buscar</button>
        </form>
      </header>

      <div id="resultados-filmes" aria-live="polite" aria-busy="true">
        ${gerarSkeletons(6, 'skeleton--card')}
      </div>
    </main>
  `;

  document.getElementById('form-busca-filmes').addEventListener('submit', (e) => {
    e.preventDefault();
    const t = document.getElementById('busca-filmes').value.trim();
    const tp = document.getElementById('tipo-filtro').value;
    Router.ir(`/?busca=${encodeURIComponent(t)}&tipo=${tp}&pagina=1`);
  });

  const ui = new EstadoUI('#resultados-filmes');

  try {
    const resultado = await OMDbService.pesquisar(busca, tipo, pagina);
    const filmes = resultado.Search;
    const total  = parseInt(resultado.totalResults);

    ui.sucesso(`
      <p class="catalogo__total">${total.toLocaleString('pt-BR')} resultado(s)</p>
      <div class="filmes-grade">
        ${filmes.map(renderizarCardFilme).join('')}
      </div>
      ${renderizarPaginacao(total, 10, pagina, `busca=${encodeURIComponent(busca)}&tipo=${tipo}`)}
    `);

    // Click nos cards → detalhe
    document.querySelector('.filmes-grade')?.addEventListener('click', (e) => {
      const card = e.target.closest('[data-imdb]');
      if (card) Router.ir(`/filme/${card.dataset.imdb}`);
    });

  } catch (erro) {
    ui.erro(erro.message || 'Erro ao buscar filmes.');
  }
}

function renderizarCardFilme(filme) {
  const poster = filme.Poster !== 'N/A'
    ? filme.Poster
    : 'https://via.placeholder.com/300x445?text=Sem+imagem';

  return `
    <article class="filme-card" data-imdb="${filme.imdbID}" tabindex="0"
             role="button" aria-label="${escapar(filme.Title)} (${filme.Year})">
      <img src="${poster}" alt="Poster: ${escapar(filme.Title)}" loading="lazy" />
      <div class="filme-card__info">
        <h3 class="filme-card__titulo">${escapar(filme.Title)}</h3>
        <span class="filme-card__ano">${filme.Year}</span>
        <span class="filme-card__tipo">${traduzirTipo(filme.Type)}</span>
      </div>
    </article>
  `;
}

function traduzirTipo(tipo) {
  return { movie: 'Filme', series: 'Série', episode: 'Episódio' }[tipo] || tipo;
}

function gerarSkeletons(n, classe) {
  return `<div class="grade-skeleton">${
    Array(n).fill(`<div class="skeleton ${classe}"></div>`).join('')
  }</div>`;
}
```

---

## 17.5 — Boas práticas e próximos passos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 17.5.1 — Separando camada de serviços da camada de UI

```javascript
// services/produtos.js — camada de serviços isolada
import { buscarDados, construirUrl } from './api.js';

const BASE = 'https://fakestoreapi.com';

export default class ProdutosService {
  static async listar(params = {}) {
    const url = construirUrl(`${BASE}/products`, params);
    const dados = await buscarDados(url);

    // Transformação: adapta o formato da API ao formato interno da app
    return {
      dados: dados.map(normalizarProduto),
      total: dados.length,
      porPagina: params.limit || dados.length
    };
  }

  static async buscarPorId(id) {
    const dados = await buscarDados(`${BASE}/products/${id}`);
    return normalizarProduto(dados);
  }

  static async listarCategorias() {
    return buscarDados(`${BASE}/products/categories`);
  }
}

// Normalização: garante que os dados têm a forma que a UI espera
// independentemente de mudanças na API
function normalizarProduto(p) {
  return {
    id:         p.id,
    nome:       p.title,         // 'title' na API → 'nome' na app
    descricao:  p.description,
    preco:      p.price,
    imagem:     p.image,
    categoria:  p.category,
    avaliacao:  p.rating?.rate ?? 0,
    totalAvaliacoes: p.rating?.count ?? 0,
    estoque:    Math.floor(Math.random() * 50) + 1 // simulado
  };
}
```

### 17.5.2 — Variáveis de ambiente e segurança de chaves de API

```javascript
// ⚠️ NUNCA expor chaves de API sensíveis no frontend
// Todo código JavaScript enviado ao browser é público e legível

// Chaves de APIs PÚBLICAS (leitura apenas, sem permissões perigosas)
// podem ser expostas no frontend com precaução:
const CONFIG = {
  OMDB_KEY:    'abc123',        // apenas leitura, sem risco financeiro
  MAPS_KEY:    'xyz789',        // restringir por domínio no painel da API
  WEATHER_KEY: 'def456',
};

// Chaves com permissões de escrita ou acesso a dados sensíveis
// NUNCA devem estar no frontend — usar proxy no backend:
// Frontend → Seu Backend → API externa (com chave segura)

// Para projetos acadêmicos: usar variáveis em arquivo de configuração
// que não é commitado no git
// config.js (no .gitignore):
export const API_KEY = 'SUA_CHAVE_AQUI';

// config.example.js (versionado):
export const API_KEY = 'SUBSTITUA_PELA_SUA_CHAVE';

// .gitignore:
// config.js
// .env
```

### 17.5.3 — O que vem depois: frameworks modernos

Com os conceitos deste capítulo dominados — módulos, serviços, roteamento, estado, renderização dinâmica —, a transição para frameworks modernos é natural. Eles resolvem os mesmos problemas com mais elegância e produtividade:

| Conceito (Vanilla JS) | React | Vue | Angular |
|---|---|---|---|
| Template literals | JSX | Template syntax | Template syntax |
| `createElement` manual | Componentes | Componentes | Componentes |
| `store.js` customizado | useState / Redux | Pinia / Vuex | NgRx / Services |
| `Router` customizado | React Router | Vue Router | Angular Router |
| `ProdutosService` | hooks customizados | Composables | Services |
| `EventEmitter` customizado | Context API | emit/props | EventEmitter |

O código escrito neste capítulo **não é descartado** ao aprender um framework — ele expõe os fundamentos que os frameworks abstraem. Desenvolvedores que aprendem React sem entender o DOM e o ciclo de renderização manual têm dificuldade em depurar problemas reais. A jornada deste curso foi deliberada.

**Referências:**
- [MDN — JavaScript Modules](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Guide/Modules)
- [MDN — History API](https://developer.mozilla.org/pt-BR/docs/Web/API/History_API)
- [OMDb API](https://www.omdbapi.com)
- [Fake Store API](https://fakestoreapi.com)

---

#### **Atividades — Capítulo 17**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Por que é importante separar a camada de serviços da camada de UI?</p>
  <button data-option="a">Para reduzir o número de arquivos no projeto.</button>
  <button data-option="b">Porque o navegador exige essa separação para módulos ES6.</button>
  <button data-option="c">Para que mudanças na API (endpoints, formato de dados) sejam tratadas apenas na camada de serviços, sem impactar o código de UI — e vice-versa. Isso torna o código mais testável, manutenível e resistente a mudanças.</button>
  <button data-option="d">Para melhorar o desempenho de renderização do DOM.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> O que é uma race condition em buscas dinâmicas e como o <code>AbortController</code> resolve esse problema?</p>
  <button data-option="a">Race condition é quando duas requisições retornam ao mesmo tempo. AbortController pausa o loop de eventos para processar uma por vez.</button>
  <button data-option="b">Race condition ocorre quando uma requisição mais lenta chega depois de uma mais recente, sobrescrevendo o resultado correto. AbortController cancela a requisição anterior ao iniciar uma nova, garantindo que apenas o resultado mais recente seja processado.</button>
  <button data-option="c">Race condition é um bug de CSS que ocorre quando dois elementos competem pelo mesmo espaço. AbortController resolve o conflito de layout.</button>
  <button data-option="d">Race condition é quando o usuário clica duas vezes. AbortController previne duplo clique.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Qual é a vantagem de normalizar os dados da API em uma camada de serviços antes de passá-los para a UI?</p>
  <button data-option="a">A normalização comprime os dados e reduz o uso de memória.</button>
  <button data-option="b">A normalização converte JSON para objetos JavaScript mais rapidamente.</button>
  <button data-option="c">A normalização garante que os dados sejam válidos antes de serem exibidos.</button>
  <button data-option="d">A normalização adapta o formato da API (que pode mudar) ao formato interno esperado pela UI. Se a API mudar o nome de um campo, apenas a função de normalização precisa ser atualizada — o código de UI permanece intocado.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir um catálogo de filmes com a OMDb API (ou JSONPlaceholder como alternativa) que implemente: roteamento por hash com telas de listagem e detalhe, busca dinâmica com debounce e AbortController, paginação funcional, todos os estados de UI (carregando, sucesso, erro, vazio) e camada de serviços separada da UI. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 16 — Consumo de APIs](16-apis.md)
[:material-arrow-right: Ir ao Capítulo 18 — Projeto Final](18-projeto-final.md)
