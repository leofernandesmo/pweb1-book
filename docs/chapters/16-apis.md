# Capítulo 16 — Consumo de APIs

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 16.1 — O que é uma API REST

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Uma **API** (*Application Programming Interface* — Interface de Programação de Aplicações) é um contrato que define como dois sistemas de software podem se comunicar. No contexto web, uma API é tipicamente um serviço acessível via HTTP que recebe requisições, processa dados e retorna respostas estruturadas — geralmente em formato JSON.

A analogia mais precisa é a de um garçom em um restaurante: o cliente (frontend) não vai até a cozinha (banco de dados) diretamente. Ele comunica seu pedido ao garçom (API), que o transmite à cozinha, aguarda o preparo e traz o resultado ao cliente. O cliente não precisa saber como a cozinha funciona — apenas como se comunicar com o garçom.

### 16.1.1 — Conceito de API e o modelo cliente-servidor revisitado

O modelo cliente-servidor, introduzido no Capítulo 1, ganha uma nova dimensão quando consideramos APIs:

```
FRONTEND (cliente)          API (servidor)           BANCO DE DADOS
┌──────────────────┐        ┌──────────────┐         ┌─────────────┐
│ HTML + CSS + JS  │  HTTP  │ Node.js      │   SQL   │ PostgreSQL  │
│                  │ ──────▶│ Python       │ ───────▶│ MongoDB     │
│ Faz requisições  │◀────── │ PHP          │◀─────── │ MySQL       │
│ Exibe dados      │  JSON  │ Java         │   JSON  │             │
└──────────────────┘        └──────────────┘         └─────────────┘
```

O frontend **nunca acessa o banco de dados diretamente** — ele sempre passa pela API. Isso garante segurança (credenciais do banco ficam no servidor), controle (a API valida e autoriza cada operação) e independência (o frontend não precisa saber qual banco de dados é usado).

### 16.1.2 — REST: princípios e convenções

**REST** (*Representational State Transfer*) é um estilo arquitetural para APIs web definido por Roy Fielding em sua dissertação de doutorado em 2000. Não é um protocolo ou padrão formal — é um conjunto de princípios que, quando seguidos, produzem APIs previsíveis, escaláveis e fáceis de consumir.

Os princípios REST mais relevantes para o frontend:

**Interface uniforme:** recursos são identificados por URLs. A mesma URL com métodos HTTP diferentes realiza operações distintas sobre o mesmo recurso.

**Stateless (sem estado):** cada requisição contém todas as informações necessárias para ser processada. O servidor não mantém estado entre requisições — autenticação, contexto e dados de sessão são enviados em cada requisição.

**Recursos e representações:** tudo é um recurso (usuário, produto, pedido) identificado por uma URL. A representação do recurso (o dado retornado) pode variar conforme o `Accept` header — JSON, XML, HTML.

### 16.1.3 — Métodos HTTP: GET, POST, PUT, PATCH, DELETE

Os métodos HTTP expressam a **intenção** da operação sobre um recurso:

| Método | Operação | Idempotente | Corpo |
|---|---|---|---|
| `GET` | Ler/listar | ✅ Sim | ❌ Não |
| `POST` | Criar | ❌ Não | ✅ Sim |
| `PUT` | Substituir (completo) | ✅ Sim | ✅ Sim |
| `PATCH` | Atualizar (parcial) | ✅ Sim* | ✅ Sim |
| `DELETE` | Remover | ✅ Sim | Opcional |

**Idempotente** significa que repetir a operação múltiplas vezes produz o mesmo resultado que executá-la uma única vez. `GET /produtos/1` retorna sempre o mesmo produto; `DELETE /produtos/1` aplicado duas vezes tem o mesmo efeito que uma vez (o produto já foi removido). `POST /produtos` cria um novo produto a cada chamada — não é idempotente.

**Convenções de URL em APIs REST:**

```
GET    /produtos          → lista todos os produtos
GET    /produtos/42       → retorna o produto com ID 42
POST   /produtos          → cria um novo produto
PUT    /produtos/42       → substitui completamente o produto 42
PATCH  /produtos/42       → atualiza campos específicos do produto 42
DELETE /produtos/42       → remove o produto 42

GET    /usuarios/7/pedidos      → pedidos do usuário 7
GET    /usuarios/7/pedidos/3    → pedido 3 do usuário 7
POST   /usuarios/7/pedidos      → cria pedido para o usuário 7

GET    /produtos?categoria=eletronicos&preco_max=500
       → filtra por query string
```

### 16.1.4 — Códigos de status HTTP

O código de status na resposta HTTP comunica o resultado da operação:

| Faixa | Categoria | Exemplos mais comuns |
|---|---|---|
| **2xx** | Sucesso | `200 OK`, `201 Created`, `204 No Content` |
| **3xx** | Redirecionamento | `301 Moved Permanently`, `304 Not Modified` |
| **4xx** | Erro do cliente | `400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found`, `422 Unprocessable Entity` |
| **5xx** | Erro do servidor | `500 Internal Server Error`, `503 Service Unavailable` |

**Os mais relevantes para o frontend:**

```javascript
// 200 OK — requisição bem-sucedida com corpo de resposta
// 201 Created — recurso criado com sucesso (resposta a POST)
// 204 No Content — sucesso sem corpo (resposta comum a DELETE)
// 400 Bad Request — dados enviados são inválidos
// 401 Unauthorized — autenticação necessária ou inválida
// 403 Forbidden — autenticado mas sem permissão
// 404 Not Found — recurso não existe
// 422 Unprocessable Entity — dados válidos sintaticamente mas inválidos semanticamente
// 429 Too Many Requests — limite de requisições excedido
// 500 Internal Server Error — erro inesperado no servidor
```

### 16.1.5 — Endpoints, recursos e parâmetros de URL

Uma URL de API é composta por partes com semânticas distintas:

```
https://api.exemplo.com/v1/produtos/42?campos=nome,preco&formato=resumido

│─────────────────────│ │─────────│ │─│ │──────────────────────────────│
    Base URL              Recurso   ID        Query parameters
    (host + versão)       (coleção) (item)    (filtros e opções)
```

**Path parameters** identificam recursos específicos:
```
/usuarios/{id}         → /usuarios/42
/produtos/{id}/avaliacoes/{avId} → /produtos/15/avaliacoes/3
```

**Query parameters** filtram, ordenam e paginam:
```
/produtos?categoria=livros          → filtro
/produtos?ordem=preco&direcao=asc   → ordenação
/produtos?pagina=2&limite=20        → paginação
/produtos?busca=javascript          → busca textual
/produtos?categoria=livros&preco_max=100&pagina=1&limite=10 → combinado
```

---

## 16.2 — JSON: estrutura e manipulação

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 16.2.1 — O que é JSON e por que é o formato padrão de APIs

**JSON** (*JavaScript Object Notation*) é um formato de texto para serialização de dados estruturados. Criado por Douglas Crockford nos anos 2000 a partir da sintaxe de objetos do JavaScript, tornou-se o formato padrão para troca de dados em APIs web por três razões principais: é legível por humanos, é facilmente parseável por máquinas, e é nativo ao JavaScript (sem necessidade de bibliotecas externas).

```json
{
  "id": 42,
  "nome": "Maria Silva",
  "email": "maria@exemplo.com",
  "ativo": true,
  "saldo": 1250.75,
  "tags": ["estudante", "frontend"],
  "endereco": {
    "rua": "Av. Lourival Melo Mota",
    "numero": "s/n",
    "cidade": "Maceió",
    "estado": "AL",
    "cep": "57072-970"
  },
  "ultimoAcesso": "2026-03-15T14:30:00Z",
  "preferencias": null
}
```

**Tipos de dados válidos em JSON:**

| Tipo JSON | Exemplo | Equivalente JS |
|---|---|---|
| string | `"texto"` | `string` |
| number | `42`, `3.14` | `number` |
| boolean | `true`, `false` | `boolean` |
| null | `null` | `null` |
| array | `[1, 2, 3]` | `Array` |
| object | `{"chave": "valor"}` | `Object` |

**O que JSON NÃO suporta:** `undefined`, funções, `Date` (datas são strings), `Symbol`, `BigInt`, referências circulares.

### 16.2.2 — `JSON.parse()` e `JSON.stringify()`

```javascript
// JSON.parse() — converte string JSON em objeto JavaScript
const jsonString = '{"nome":"Ana","idade":22,"ativo":true}';
const objeto = JSON.parse(jsonString);

console.log(objeto.nome);  // → "Ana"
console.log(objeto.idade); // → 22
console.log(typeof objeto.idade); // → "number"

// JSON.stringify() — converte objeto JavaScript em string JSON
const usuario = {
  nome: 'Bruno',
  idade: 25,
  hobbies: ['leitura', 'programação'],
  senha: undefined, // undefined é omitido
  saldo: 1500.50
};

const json = JSON.stringify(usuario);
// → '{"nome":"Bruno","idade":25,"hobbies":["leitura","programação"],"saldo":1500.5}'

// Indentação para legibilidade (útil para debug)
const jsonFormatado = JSON.stringify(usuario, null, 2);
/*
{
  "nome": "Bruno",
  "idade": 25,
  ...
}
*/

// Replacer: filtrar ou transformar propriedades
const jsonSemSenha = JSON.stringify(usuario, (chave, valor) => {
  if (chave === 'senha') return undefined; // omite a propriedade
  return valor;
});

// Reviver: transformar valores ao fazer parse
const dados = JSON.parse('{"nascimento":"1995-08-20"}', (chave, valor) => {
  if (chave === 'nascimento') return new Date(valor);
  return valor;
});
console.log(dados.nascimento instanceof Date); // → true

// Tratamento de erros: JSON inválido lança SyntaxError
try {
  JSON.parse('{nome: "Ana"}'); // chaves sem aspas — JSON inválido
} catch (erro) {
  console.error('JSON inválido:', erro.message);
}
```

### 16.2.3 — Estruturas JSON complexas

```javascript
// Resposta típica de uma API paginada
const resposta = {
  "dados": [
    { "id": 1, "titulo": "HTML Semântico", "autor": { "id": 5, "nome": "Prof. Silva" } },
    { "id": 2, "titulo": "CSS Grid",       "autor": { "id": 5, "nome": "Prof. Silva" } },
    { "id": 3, "titulo": "JavaScript",     "autor": { "id": 7, "nome": "Prof. Lima"  } }
  ],
  "meta": {
    "total": 42,
    "pagina": 1,
    "porPagina": 3,
    "totalPaginas": 14
  },
  "links": {
    "self":     "/artigos?pagina=1",
    "proximo":  "/artigos?pagina=2",
    "anterior": null,
    "ultimo":   "/artigos?pagina=14"
  }
};

// Acessando dados aninhados
const primeiroTitulo = resposta.dados[0].titulo;
const nomeAutor      = resposta.dados[0].autor.nome;
const totalPaginas   = resposta.meta.totalPaginas;

// Desestruturação de resposta de API
const { dados: artigos, meta: { total, pagina } } = resposta;

// Mapeando para estrutura simplificada
const titulosPorAutor = artigos.map(a => ({
  titulo: a.titulo,
  autor: a.autor.nome
}));
```

### 16.2.4 — Armadilhas comuns com JSON

```javascript
// 1. Datas em JSON são strings — não objetos Date
const evento = JSON.parse('{"data":"2026-03-22T10:00:00Z"}');
console.log(evento.data instanceof Date); // → false (é string!)
const dataReal = new Date(evento.data);   // conversão manual necessária

// 2. null ≠ undefined em JSON
const obj = JSON.parse('{"nome":null}');
console.log(obj.nome);       // → null
console.log(obj.sobrenome);  // → undefined (propriedade não existe)

// 3. Números grandes perdem precisão
// JSON.parse preserva apenas até Number.MAX_SAFE_INTEGER (2^53 - 1)
const grande = JSON.parse('{"id":9007199254740993}');
console.log(grande.id); // → 9007199254740992 (impreciso!)
// Solução: APIs modernas enviam IDs grandes como strings

// 4. JSON.stringify omite undefined, functions e Symbol
const obj2 = { a: 1, b: undefined, c: () => {}, d: Symbol() };
JSON.stringify(obj2); // → '{"a":1}'

// 5. Referências circulares causam erro
const circular = {};
circular.self = circular;
JSON.stringify(circular); // TypeError: Converting circular structure to JSON
```

---

## 16.3 — Fetch API

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A **Fetch API** é a interface nativa do navegador para realizar requisições HTTP. Introduzida no ES2015 e amplamente suportada desde então, substituiu o antigo `XMLHttpRequest` com uma API baseada em Promises — muito mais legível e integrável com `async/await`.

### 16.3.1 — Sintaxe básica e o objeto Response

```javascript
// fetch() retorna uma Promise que resolve para um objeto Response
const resposta = await fetch('https://viacep.com.br/ws/57072970/json/');

// O objeto Response contém metadados da resposta HTTP
console.log(resposta.ok);      // → true (status 200-299)
console.log(resposta.status);  // → 200
console.log(resposta.statusText); // → "OK"
console.log(resposta.url);     // → URL final (após redirecionamentos)
console.log(resposta.headers.get('content-type')); // → "application/json"

// O corpo da resposta é lido com métodos assíncronos
const dados = await resposta.json();   // → objeto JavaScript
// ou
const texto = await resposta.text();   // → string
// ou
const blob  = await resposta.blob();   // → Blob (para arquivos/imagens)
```

### 16.3.2 — Por que `fetch` não rejeita em erros HTTP

Este é o comportamento mais contraintuitivo da Fetch API e causa de bugs frequentes:

```javascript
// fetch() APENAS rejeita (throw) em caso de erro de REDE
// (sem conexão, DNS falhou, timeout, etc.)
// Erros HTTP (404, 500, 403) NÃO causam rejeição — chegam como Response normal

// ❌ CÓDIGO BUGADO: não detecta erros HTTP
async function buscarUsuarioBugado(id) {
  const dados = await fetch(`/api/usuarios/${id}`).then(r => r.json());
  // Se a API retornar 404, dados conterá {"erro": "não encontrado"}
  // mas nenhum erro será lançado
  return dados;
}

// ✅ CÓDIGO CORRETO: verifica resposta.ok antes de parsear
async function buscarUsuario(id) {
  const resposta = await fetch(`/api/usuarios/${id}`);

  if (!resposta.ok) {
    throw new Error(`Erro HTTP ${resposta.status}: ${resposta.statusText}`);
  }

  return resposta.json();
}
```

### 16.3.3 — Requisições GET com `async/await`

```javascript
// Padrão completo e robusto para requisições GET
async function buscarDados(url) {
  try {
    const resposta = await fetch(url);

    if (!resposta.ok) {
      throw new Error(`HTTP ${resposta.status}: ${resposta.statusText}`);
    }

    return await resposta.json();

  } catch (erro) {
    if (erro instanceof TypeError) {
      // TypeError: falha de rede (sem conexão, CORS, URL inválida)
      throw new Error('Falha de rede. Verifique sua conexão.');
    }
    throw erro; // relança outros erros
  }
}

// Uso
const cep = await buscarDados('https://viacep.com.br/ws/57072970/json/');
console.log(cep.logradouro); // → "Av. Lourival Melo Mota"

// Com query parameters
function construirUrl(base, params) {
  const url = new URL(base);
  Object.entries(params).forEach(([chave, valor]) => {
    if (valor !== undefined && valor !== null) {
      url.searchParams.append(chave, valor);
    }
  });
  return url.toString();
}

const url = construirUrl('https://api.exemplo.com/produtos', {
  categoria: 'eletronicos',
  preco_max: 500,
  pagina: 1,
  limite: 20
});
// → "https://api.exemplo.com/produtos?categoria=eletronicos&preco_max=500&pagina=1&limite=20"

const produtos = await buscarDados(url);
```

### 16.3.4 — Requisições POST, PUT, PATCH e DELETE

```javascript
// POST — criar recurso
async function criarProduto(dadosProduto) {
  const resposta = await fetch('https://api.exemplo.com/produtos', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${obterToken()}`
    },
    body: JSON.stringify(dadosProduto)
  });

  if (!resposta.ok) {
    const erro = await resposta.json().catch(() => ({}));
    throw new Error(erro.mensagem || `Erro ${resposta.status}`);
  }

  return resposta.json(); // retorna o recurso criado (geralmente com ID)
}

// PUT — substituição completa
async function substituirProduto(id, dadosCompletos) {
  const resposta = await fetch(`https://api.exemplo.com/produtos/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(dadosCompletos)
  });

  if (!resposta.ok) throw new Error(`Erro ${resposta.status}`);
  return resposta.json();
}

// PATCH — atualização parcial
async function atualizarProduto(id, camposParaAtualizar) {
  const resposta = await fetch(`https://api.exemplo.com/produtos/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(camposParaAtualizar) // apenas os campos alterados
  });

  if (!resposta.ok) throw new Error(`Erro ${resposta.status}`);
  return resposta.json();
}

// DELETE — remoção
async function removerProduto(id) {
  const resposta = await fetch(`https://api.exemplo.com/produtos/${id}`, {
    method: 'DELETE',
    headers: { 'Authorization': `Bearer ${obterToken()}` }
  });

  // DELETE frequentemente retorna 204 No Content (sem corpo)
  if (!resposta.ok) throw new Error(`Erro ${resposta.status}`);

  if (resposta.status === 204) return null;
  return resposta.json();
}
```

### 16.3.5 — Enviando dados JSON no corpo da requisição

```javascript
// Padrão completo para POST com JSON
const novoPedido = {
  clienteId: 42,
  itens: [
    { produtoId: 1, quantidade: 2 },
    { produtoId: 5, quantidade: 1 }
  ],
  enderecoEntrega: {
    cep: '57072-970',
    numero: '100'
  },
  observacoes: 'Entregar pela manhã'
};

const resposta = await fetch('/api/pedidos', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',  // OBRIGATÓRIO para JSON
    'Accept': 'application/json',        // indica que esperamos JSON de volta
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify(novoPedido)
});

// Verificar status específico de criação
if (resposta.status === 201) {
  const pedidoCriado = await resposta.json();
  console.log('Pedido criado com ID:', pedidoCriado.id);
} else if (!resposta.ok) {
  const erro = await resposta.json();
  // API pode retornar erros detalhados de validação
  if (erro.erros) {
    erro.erros.forEach(e => console.error(`Campo ${e.campo}: ${e.mensagem}`));
  }
}
```

### 16.3.6 — Headers: `Content-Type`, `Authorization` e outros

```javascript
// Configuração de headers comuns
const headersBase = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Accept-Language': 'pt-BR',
};

// Autenticação Bearer (JWT — o mais comum em APIs modernas)
function headersAutenticados() {
  const token = localStorage.getItem('token');
  return {
    ...headersBase,
    'Authorization': `Bearer ${token}`
  };
}

// Autenticação por API Key (comum em APIs públicas)
function headersApiKey(chave) {
  return {
    ...headersBase,
    'X-API-Key': chave
  };
}

// Usando o objeto Headers para manipulação mais rica
const headers = new Headers({
  'Content-Type': 'application/json'
});

headers.append('Authorization', `Bearer ${token}`);
headers.has('Content-Type');    // → true
headers.get('Content-Type');    // → "application/json"
headers.delete('Authorization');

// ⚠️ Headers que o navegador não permite definir manualmente
// (por segurança — são definidos automaticamente):
// Cookie, Host, Referer, Origin, User-Agent
```

### 16.3.7 — Enviando formulários com `FormData`

```javascript
// FormData para envio de arquivos (multipart/form-data)
const form = document.querySelector('#form-upload');

form.addEventListener('submit', async (e) => {
  e.preventDefault();

  const formData = new FormData(form);
  // FormData captura automaticamente todos os campos do formulário
  // incluindo arquivos do type="file"

  // NÃO definir Content-Type manualmente — o browser define
  // automaticamente com o boundary correto para multipart
  const resposta = await fetch('/api/upload', {
    method: 'POST',
    body: formData
    // sem headers Content-Type aqui!
  });

  if (!resposta.ok) throw new Error('Falha no upload');
  const resultado = await resposta.json();
  console.log('Arquivo enviado:', resultado.url);
});

// FormData programático — construindo manualmente
const fd = new FormData();
fd.append('nome', 'Maria');
fd.append('foto', arquivoInput.files[0], 'foto-perfil.jpg');
fd.append('dados', JSON.stringify({ role: 'estudante' }));

// Inspecionar FormData
for (const [chave, valor] of fd.entries()) {
  console.log(chave, valor);
}
```

---

## 16.4 — Tratamento de erros e UX

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 16.4.1 — Erros de rede vs erros HTTP

```javascript
// Classificação completa de erros em requisições fetch

async function requisicaoRobusta(url, opcoes = {}) {
  try {
    const resposta = await fetch(url, opcoes);

    // Erro HTTP: servidor respondeu com código de erro
    if (!resposta.ok) {
      const corpo = await resposta.json().catch(() => null);
      const erro = new Error(corpo?.mensagem || `HTTP ${resposta.status}`);
      erro.status = resposta.status;
      erro.corpo = corpo;

      // Classificar por tipo de erro HTTP
      if (resposta.status === 401) erro.tipo = 'nao_autenticado';
      else if (resposta.status === 403) erro.tipo = 'sem_permissao';
      else if (resposta.status === 404) erro.tipo = 'nao_encontrado';
      else if (resposta.status === 422) erro.tipo = 'validacao';
      else if (resposta.status === 429) erro.tipo = 'limite_excedido';
      else if (resposta.status >= 500)  erro.tipo = 'servidor';
      else erro.tipo = 'cliente';

      throw erro;
    }

    return resposta;

  } catch (erro) {
    // TypeError: erro de REDE (sem conexão, CORS, timeout, DNS)
    if (erro instanceof TypeError) {
      const erroRede = new Error('Falha de rede. Verifique sua conexão.');
      erroRede.tipo = 'rede';
      throw erroRede;
    }
    throw erro;
  }
}
```

### 16.4.2 — Estados de interface: carregando, sucesso, erro, vazio

Toda operação assíncrona com uma API deve ser refletida na interface com estados visuais claros:

```javascript
// Gerenciador de estado de UI para operações assíncronas
class EstadoUI {
  constructor(containerSelector) {
    this.container = document.querySelector(containerSelector);
  }

  carregando(mensagem = 'Carregando...') {
    this.container.innerHTML = `
      <div class="estado estado--carregando" role="status" aria-live="polite">
        <div class="spinner" aria-hidden="true"></div>
        <p>${mensagem}</p>
      </div>
    `;
  }

  sucesso(html) {
    this.container.innerHTML = html;
  }

  erro(mensagem, onRetry = null) {
    this.container.innerHTML = `
      <div class="estado estado--erro" role="alert">
        <span class="estado__icone" aria-hidden="true">⚠️</span>
        <p class="estado__mensagem">${mensagem}</p>
        ${onRetry ? `
          <button type="button" class="btn btn--secundario" id="btn-tentar-novamente">
            Tentar novamente
          </button>
        ` : ''}
      </div>
    `;

    if (onRetry) {
      this.container.querySelector('#btn-tentar-novamente')
        .addEventListener('click', onRetry);
    }
  }

  vazio(mensagem = 'Nenhum item encontrado.') {
    this.container.innerHTML = `
      <div class="estado estado--vazio" role="status">
        <span class="estado__icone" aria-hidden="true">📭</span>
        <p>${mensagem}</p>
      </div>
    `;
  }
}

// Uso integrado com fetch
async function carregarProdutos(filtros = {}) {
  const ui = new EstadoUI('#lista-produtos');
  ui.carregando('Buscando produtos...');

  try {
    const url = construirUrl('/api/produtos', filtros);
    const dados = await buscarDados(url);

    if (!dados.items.length) {
      ui.vazio('Nenhum produto encontrado para os filtros selecionados.');
      return;
    }

    ui.sucesso(renderizarProdutos(dados.items));

  } catch (erro) {
    const mensagem = erro.tipo === 'rede'
      ? 'Sem conexão com a internet.'
      : 'Erro ao carregar produtos. Tente novamente.';

    ui.erro(mensagem, () => carregarProdutos(filtros));
  }
}
```

### 16.4.3 — Indicadores de carregamento acessíveis

```html
<!-- Spinner acessível -->
<div class="spinner-container" role="status" aria-label="Carregando">
  <div class="spinner" aria-hidden="true"></div>
  <!-- Texto visível apenas para leitores de tela -->
  <span class="sr-only">Carregando, aguarde...</span>
</div>

<!-- Skeleton loading — mais elegante que spinner para listas -->
<div class="skeleton-lista" aria-busy="true" aria-label="Carregando lista">
  <div class="skeleton-item">
    <div class="skeleton skeleton--titulo"></div>
    <div class="skeleton skeleton--texto"></div>
    <div class="skeleton skeleton--texto skeleton--curto"></div>
  </div>
  <!-- repetir N vezes -->
</div>
```

```css
/* Animação de skeleton */
@keyframes skeleton-shimmer {
  0%   { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

.skeleton {
  background: linear-gradient(
    90deg,
    #e2e8f0 25%,
    #f1f5f9 50%,
    #e2e8f0 75%
  );
  background-size: 200% 100%;
  animation: skeleton-shimmer 1.5s infinite;
  border-radius: 4px;
}

/* Respeitar preferências de movimento reduzido */
@media (prefers-reduced-motion: reduce) {
  .skeleton { animation: none; }
}
```

### 16.4.4 — Retry e timeout: padrões de resiliência

```javascript
// Retry automático com backoff exponencial
async function fetchComRetry(url, opcoes = {}, maxTentativas = 3) {
  let tentativa = 0;

  while (tentativa < maxTentativas) {
    try {
      const resposta = await fetch(url, opcoes);

      // Tentar novamente apenas em erros de servidor (5xx) ou 429
      if (resposta.status >= 500 || resposta.status === 429) {
        tentativa++;
        if (tentativa >= maxTentativas) throw new Error(`HTTP ${resposta.status}`);

        // Backoff exponencial: 1s, 2s, 4s...
        const espera = Math.pow(2, tentativa - 1) * 1000;
        await new Promise(resolve => setTimeout(resolve, espera));
        continue;
      }

      return resposta;

    } catch (erro) {
      if (erro instanceof TypeError) { // erro de rede
        tentativa++;
        if (tentativa >= maxTentativas) throw erro;
        await new Promise(resolve => setTimeout(resolve, 1000 * tentativa));
        continue;
      }
      throw erro;
    }
  }
}

// Timeout com AbortController
async function fetchComTimeout(url, opcoes = {}, timeoutMs = 5000) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const resposta = await fetch(url, {
      ...opcoes,
      signal: controller.signal
    });
    return resposta;

  } catch (erro) {
    if (erro.name === 'AbortError') {
      throw new Error(`Timeout: a requisição demorou mais de ${timeoutMs}ms`);
    }
    throw erro;
  } finally {
    clearTimeout(timeout);
  }
}
```

### 16.4.5 — Exercício prático: busca de CEP com ViaCEP

```html
<form class="form-cep" id="form-cep" novalidate>
  <div class="campo">
    <label for="cep">CEP</label>
    <div class="campo__input-wrapper">
      <input type="text" id="cep" name="cep"
             placeholder="00000-000" maxlength="9"
             aria-describedby="cep-erro" autocomplete="postal-code" />
      <button type="submit" class="btn btn--primario">Buscar</button>
    </div>
    <p class="campo__erro" id="cep-erro" role="alert" hidden></p>
  </div>
</form>

<div id="resultado-cep"></div>
```

```javascript
// Máscara automática de CEP
document.getElementById('cep').addEventListener('input', (e) => {
  let v = e.target.value.replace(/\D/g, '').slice(0, 8);
  if (v.length > 5) v = v.slice(0, 5) + '-' + v.slice(5);
  e.target.value = v;
});

// Busca ao pressionar Enter ou sair do campo
document.getElementById('cep').addEventListener('blur', buscarCEP);
document.getElementById('form-cep').addEventListener('submit', (e) => {
  e.preventDefault();
  buscarCEP();
});

async function buscarCEP() {
  const input    = document.getElementById('cep');
  const erroEl   = document.getElementById('cep-erro');
  const resultEl = document.getElementById('resultado-cep');
  const cep      = input.value.replace(/\D/g, '');

  // Validação
  if (cep.length !== 8) {
    erroEl.textContent = 'Informe um CEP válido com 8 dígitos.';
    erroEl.hidden = false;
    input.setAttribute('aria-invalid', 'true');
    return;
  }

  erroEl.hidden = true;
  input.setAttribute('aria-invalid', 'false');

  // Estado de carregamento
  resultEl.innerHTML = `
    <div class="estado estado--carregando" role="status" aria-live="polite">
      <div class="spinner" aria-hidden="true"></div>
      <p>Buscando endereço...</p>
    </div>
  `;

  try {
    const resposta = await fetchComTimeout(
      `https://viacep.com.br/ws/${cep}/json/`,
      {}, 5000
    );

    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);

    const dados = await resposta.json();

    // ViaCEP retorna { erro: true } para CEPs inexistentes
    if (dados.erro) {
      resultEl.innerHTML = `
        <div class="estado estado--vazio" role="alert">
          <p>CEP não encontrado. Verifique o número informado.</p>
        </div>
      `;
      return;
    }

    // Renderizar resultado
    resultEl.innerHTML = `
      <div class="endereco-card" aria-label="Endereço encontrado">
        <dl class="endereco-dados">
          <div class="endereco-campo">
            <dt>Logradouro</dt>
            <dd>${dados.logradouro || '—'}</dd>
          </div>
          <div class="endereco-campo">
            <dt>Bairro</dt>
            <dd>${dados.bairro || '—'}</dd>
          </div>
          <div class="endereco-campo">
            <dt>Cidade</dt>
            <dd>${dados.localidade} — ${dados.uf}</dd>
          </div>
          <div class="endereco-campo">
            <dt>DDD</dt>
            <dd>${dados.ddd || '—'}</dd>
          </div>
          <div class="endereco-campo">
            <dt>IBGE</dt>
            <dd>${dados.ibge || '—'}</dd>
          </div>
        </dl>
      </div>
    `;

    // Preencher formulário automaticamente (se existir)
    preencherFormularioComEndereco(dados);

  } catch (erro) {
    const mensagem = erro.message.includes('Timeout')
      ? 'A busca demorou muito. Tente novamente.'
      : 'Erro ao buscar o CEP. Tente novamente.';

    resultEl.innerHTML = `
      <div class="estado estado--erro" role="alert">
        <p>${mensagem}</p>
      </div>
    `;
  }
}

function preencherFormularioComEndereco(dados) {
  const mapa = {
    'endereco-rua':    dados.logradouro,
    'endereco-bairro': dados.bairro,
    'endereco-cidade': dados.localidade,
    'endereco-estado': dados.uf,
  };

  Object.entries(mapa).forEach(([id, valor]) => {
    const campo = document.getElementById(id);
    if (campo && valor) campo.value = valor;
  });

  document.getElementById('endereco-numero')?.focus();
}
```

---

## 16.5 — APIs públicas: exemplos práticos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 16.5.1 — Critérios para escolher uma API pública

| Critério | O que verificar |
|---|---|
| **Documentação** | Clara, com exemplos de requisição e resposta |
| **Autenticação** | Gratuita sem chave? Cadastro necessário? |
| **Rate limiting** | Quantas requisições por minuto/hora/dia? |
| **CORS** | Permite requisições de qualquer origem? |
| **Formato** | JSON? XML? |
| **Confiabilidade** | SLA? Uptime histórico? |
| **Versioning** | URL versionada `/v1/`? Política de deprecação? |

### 16.5.2 — ViaCEP: busca de endereço por CEP

```javascript
// Documentação: https://viacep.com.br
// Sem autenticação, sem rate limit declarado, CORS liberado

class ViaCEP {
  static BASE_URL = 'https://viacep.com.br/ws';

  static async buscarPorCEP(cep) {
    const cepNumerico = cep.replace(/\D/g, '');
    if (cepNumerico.length !== 8) throw new Error('CEP inválido');

    const resposta = await fetch(`${this.BASE_URL}/${cepNumerico}/json/`);
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);

    const dados = await resposta.json();
    if (dados.erro) throw new Error('CEP não encontrado');

    return dados;
  }

  static async buscarPorLogradouro(uf, cidade, logradouro) {
    const params = [uf, cidade, logradouro].map(encodeURIComponent).join('/');
    const resposta = await fetch(`${this.BASE_URL}/${params}/json/`);
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    return resposta.json();
  }
}

// Uso
const endereco = await ViaCEP.buscarPorCEP('57072-970');
console.log(endereco.logradouro); // → "Av. Lourival Melo Mota"
```

### 16.5.3 — OpenWeatherMap: previsão do tempo

```javascript
// Documentação: https://openweathermap.org/api
// Requer cadastro gratuito para obter API key

class OpenWeather {
  #apiKey;
  static BASE_URL = 'https://api.openweathermap.org/data/2.5';

  constructor(apiKey) {
    this.#apiKey = apiKey;
  }

  async buscarPorCidade(cidade) {
    const url = new URL(`${OpenWeather.BASE_URL}/weather`);
    url.searchParams.set('q', cidade);
    url.searchParams.set('appid', this.#apiKey);
    url.searchParams.set('units', 'metric');  // Celsius
    url.searchParams.set('lang', 'pt_br');

    const resposta = await fetch(url);
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    return resposta.json();
  }

  async previsao5Dias(cidade) {
    const url = new URL(`${OpenWeather.BASE_URL}/forecast`);
    url.searchParams.set('q', cidade);
    url.searchParams.set('appid', this.#apiKey);
    url.searchParams.set('units', 'metric');
    url.searchParams.set('lang', 'pt_br');
    url.searchParams.set('cnt', '5'); // 5 períodos de 3h

    const resposta = await fetch(url);
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    return resposta.json();
  }
}

// Renderizar dados do tempo
async function exibirTempo(cidade) {
  const weather = new OpenWeather('SUA_CHAVE_AQUI');

  try {
    const dados = await weather.buscarPorCidade(cidade);

    document.getElementById('tempo-card').innerHTML = `
      <div class="tempo">
        <h2 class="tempo__cidade">${dados.name}, ${dados.sys.country}</h2>
        <div class="tempo__principal">
          <img
            src="https://openweathermap.org/img/wn/${dados.weather[0].icon}@2x.png"
            alt="${dados.weather[0].description}"
            class="tempo__icone"
          />
          <span class="tempo__temperatura">${Math.round(dados.main.temp)}°C</span>
        </div>
        <p class="tempo__descricao">${dados.weather[0].description}</p>
        <dl class="tempo__detalhes">
          <div><dt>Sensação</dt><dd>${Math.round(dados.main.feels_like)}°C</dd></div>
          <div><dt>Umidade</dt><dd>${dados.main.humidity}%</dd></div>
          <div><dt>Vento</dt><dd>${Math.round(dados.wind.speed * 3.6)} km/h</dd></div>
        </dl>
      </div>
    `;
  } catch (erro) {
    console.error('Erro ao buscar tempo:', erro);
  }
}
```

### 16.5.4 — JSONPlaceholder: simulação de CRUD

```javascript
// Documentação: https://jsonplaceholder.typicode.com
// API de teste sem autenticação — simula operações CRUD
// As operações POST/PUT/PATCH/DELETE são simuladas (não persistem)

class JSONPlaceholder {
  static BASE = 'https://jsonplaceholder.typicode.com';

  // Posts
  static async listarPosts(params = {}) {
    const url = construirUrl(`${this.BASE}/posts`, params);
    return buscarDados(url);
  }

  static async buscarPost(id) {
    return buscarDados(`${this.BASE}/posts/${id}`);
  }

  static async criarPost(dados) {
    const resposta = await fetch(`${this.BASE}/posts`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados)
    });
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    return resposta.json();
  }

  static async atualizarPost(id, dados) {
    const resposta = await fetch(`${this.BASE}/posts/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados)
    });
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    return resposta.json();
  }

  static async removerPost(id) {
    const resposta = await fetch(`${this.BASE}/posts/${id}`, {
      method: 'DELETE'
    });
    if (!resposta.ok) throw new Error(`HTTP ${resposta.status}`);
    return true;
  }

  // Comentários de um post
  static async comentariosDoPost(postId) {
    return buscarDados(`${this.BASE}/posts/${postId}/comments`);
  }

  // Usuários
  static async listarUsuarios() {
    return buscarDados(`${this.BASE}/users`);
  }
}
```

### 16.5.5 — IBGE: dados geográficos do Brasil

```javascript
// Documentação: https://servicodados.ibge.gov.br/api/docs
// Sem autenticação, dados geográficos e populacionais oficiais do Brasil

class IBGE {
  static BASE = 'https://servicodados.ibge.gov.br/api/v1';

  static async listarEstados() {
    const estados = await buscarDados(`${this.BASE}/localidades/estados?orderBy=nome`);
    return estados.sort((a, b) => a.nome.localeCompare(b.nome));
  }

  static async municipiosPorEstado(uf) {
    return buscarDados(
      `${this.BASE}/localidades/estados/${uf}/municipios?orderBy=nome`
    );
  }

  static async buscarMunicipio(id) {
    return buscarDados(`${this.BASE}/localidades/municipios/${id}`);
  }
}

// Exemplo: select dinâmico de estado → município
async function inicializarSelectsLocalizacao() {
  const selectEstado   = document.getElementById('estado');
  const selectMunicipio = document.getElementById('municipio');

  // Carregar estados
  const estados = await IBGE.listarEstados();
  estados.forEach(estado => {
    const option = document.createElement('option');
    option.value = estado.sigla;
    option.textContent = estado.nome;
    selectEstado.appendChild(option);
  });

  // Carregar municípios ao selecionar estado
  selectEstado.addEventListener('change', async () => {
    const uf = selectEstado.value;
    selectMunicipio.innerHTML = '<option value="">Carregando...</option>';
    selectMunicipio.disabled = true;

    try {
      const municipios = await IBGE.municipiosPorEstado(uf);
      selectMunicipio.innerHTML = '<option value="">Selecione o município...</option>';
      municipios.forEach(m => {
        const option = document.createElement('option');
        option.value = m.id;
        option.textContent = m.nome;
        selectMunicipio.appendChild(option);
      });
      selectMunicipio.disabled = false;
    } catch (erro) {
      selectMunicipio.innerHTML = '<option value="">Erro ao carregar</option>';
    }
  });
}
```

### 16.5.6 — Exercício prático: dashboard com múltiplas APIs

```javascript
// Dashboard que exibe tempo + dados geográficos + posts simulados
async function carregarDashboard() {
  const ui = {
    tempo:    new EstadoUI('#widget-tempo'),
    estados:  new EstadoUI('#widget-estados'),
    posts:    new EstadoUI('#widget-posts'),
  };

  // Carregar tudo em paralelo
  ui.tempo.carregando();
  ui.estados.carregando();
  ui.posts.carregando();

  const [tempoResult, estadosResult, postsResult] = await Promise.allSettled([
    new OpenWeather('SUA_CHAVE').buscarPorCidade('Maceió'),
    IBGE.listarEstados(),
    JSONPlaceholder.listarPosts({ _limit: 5 }),
  ]);

  // Processar cada resultado independentemente
  if (tempoResult.status === 'fulfilled') {
    const d = tempoResult.value;
    ui.tempo.sucesso(`<p>${d.name}: ${Math.round(d.main.temp)}°C</p>`);
  } else {
    ui.tempo.erro('Não foi possível carregar o tempo.');
  }

  if (estadosResult.status === 'fulfilled') {
    const html = estadosResult.value
      .slice(0, 5)
      .map(e => `<li>${e.nome} (${e.sigla})</li>`)
      .join('');
    ui.estados.sucesso(`<ul>${html}</ul>`);
  } else {
    ui.estados.erro('Erro ao carregar estados.');
  }

  if (postsResult.status === 'fulfilled') {
    const html = postsResult.value
      .map(p => `<li>${p.title}</li>`)
      .join('');
    ui.posts.sucesso(`<ul>${html}</ul>`);
  } else {
    ui.posts.erro('Erro ao carregar posts.');
  }
}
```

**Referências:**
- [MDN — Fetch API](https://developer.mozilla.org/pt-BR/docs/Web/API/Fetch_API)
- [MDN — Using Fetch](https://developer.mozilla.org/pt-BR/docs/Web/API/Fetch_API/Using_Fetch)
- [ViaCEP](https://viacep.com.br)
- [JSONPlaceholder](https://jsonplaceholder.typicode.com)
- [IBGE API](https://servicodados.ibge.gov.br/api/docs)
- [OpenWeatherMap API](https://openweathermap.org/api)

---

#### **Atividades — Capítulo 16**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Por que <code>fetch()</code> não lança um erro quando o servidor retorna status 404 ou 500?</p>
  <button data-option="a">Porque fetch() ignora todos os erros HTTP por padrão.</button>
  <button data-option="b">Porque erros HTTP precisam ser tratados com <code>.catch()</code>, não com <code>try/catch</code>.</button>
  <button data-option="c">Porque fetch() rejeita a Promise apenas em falhas de rede (sem conexão, CORS, DNS). Erros HTTP são respostas válidas do servidor e chegam como objeto Response com <code>ok: false</code> — exigindo verificação explícita de <code>resposta.ok</code>.</button>
  <button data-option="d">Porque erros 4xx são erros do cliente e não do servidor, portanto não afetam o fetch.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Qual a diferença entre os métodos HTTP <code>PUT</code> e <code>PATCH</code>?</p>
  <button data-option="a">PUT é usado para criar recursos; PATCH para atualizar.</button>
  <button data-option="b">PUT substitui o recurso completo pelo corpo enviado; PATCH aplica apenas as alterações parciais especificadas no corpo — sem afetar campos não mencionados.</button>
  <button data-option="c">PUT é mais seguro que PATCH por ser idempotente.</button>
  <button data-option="d">Não há diferença funcional — a escolha é apenas convencional.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Por que ao enviar arquivos com <code>FormData</code> não se deve definir o header <code>Content-Type: multipart/form-data</code> manualmente?</p>
  <button data-option="a">Porque FormData não suporta o tipo multipart/form-data.</button>
  <button data-option="b">Porque o header Content-Type é ignorado quando o body é FormData.</button>
  <button data-option="c">Porque apenas o servidor pode definir o Content-Type da requisição.</button>
  <button data-option="d">Porque o navegador precisa incluir automaticamente o <em>boundary</em> — um delimitador único gerado para separar os campos do formulário. Definir o Content-Type manualmente omite o boundary e corrompe a requisição.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Construir um buscador de endereço que: (1) use a API ViaCEP para buscar dados por CEP com máscara automática; (2) use a API IBGE para popular selects dinâmicos de estado/município; (3) exiba todos os estados de interface (carregando, sucesso, erro, vazio) com indicadores acessíveis. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 15 — Eventos e Formulários](15-eventos-formularios.md)
[:material-arrow-right: Ir ao Capítulo 17 — Integração Frontend + API](17-integracao-frontend-api.md)
