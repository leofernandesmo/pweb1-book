# Capítulo 14 — Manipulação do DOM

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 14.1 — O que é o DOM

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **DOM** (*Document Object Model*) é a representação do documento HTML em memória, estruturada como uma árvore de objetos que o JavaScript pode inspecionar e modificar em tempo de execução. Quando o navegador carrega um documento HTML, ele não apenas renderiza o visual — ele constrói uma estrutura de dados hierárquica em memória que modela cada elemento, atributo e fragmento de texto do documento como um **nó** (*node*).

Esta estrutura é o que torna possível o desenvolvimento de interfaces dinâmicas: adicionar e remover elementos, alterar textos e estilos, responder a cliques e digitações — tudo via JavaScript operando sobre o DOM.

### 14.1.1 — A árvore DOM

Para o seguinte documento HTML:

```html
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <title>Exemplo</title>
  </head>
  <body>
    <h1 id="titulo">Olá, DOM</h1>
    <p class="descricao">Primeiro parágrafo.</p>
    <p class="descricao">Segundo parágrafo.</p>
  </body>
</html>
```

O DOM construído pelo navegador é:

```
document
└── html
    ├── head
    │   └── title
    │       └── "Exemplo"  (nó de texto)
    └── body
        ├── h1#titulo
        │   └── "Olá, DOM"
        ├── p.descricao
        │   └── "Primeiro parágrafo."
        └── p.descricao
            └── "Segundo parágrafo."
```

Cada caixa é um **nó DOM**. Os tipos mais relevantes são:

| Tipo | Descrição | Exemplo |
|---|---|---|
| `Document` | O documento inteiro | `document` |
| `Element` | Um elemento HTML | `<h1>`, `<p>`, `<div>` |
| `Text` | Conteúdo textual de um elemento | `"Olá, DOM"` |
| `Attr` | Um atributo de elemento | `id="titulo"` |
| `Comment` | Comentário HTML | `<!-- comentário -->` |

### 14.1.2 — O objeto `document`

O ponto de entrada para toda interação com o DOM é o objeto global **`document`** — disponível automaticamente em qualquer script que rode no navegador:

```javascript
document.title          // → "Exemplo" — título da página
document.URL            // → URL atual
document.documentElement // → elemento <html>
document.head           // → elemento <head>
document.body           // → elemento <body>
document.characterSet   // → "UTF-8"
document.readyState     // → "complete" | "interactive" | "loading"
```

### 14.1.3 — DOM vs HTML: a distinção importante

O DOM **não é** uma cópia estática do HTML — é uma representação viva e dinâmica que pode divergir do HTML original. Quando JavaScript modifica o DOM (adiciona um elemento, altera um texto), o HTML original no servidor não muda — apenas a representação em memória no navegador. O HTML que você vê em "Visualizar Código-fonte" é sempre o original; o que o DevTools mostra na aba Elements é o DOM atual (possivelmente modificado por JavaScript).

> **No DevTools:** abra a aba **Elements** enquanto inspeciona uma página. Você está vendo o DOM em tempo real — não o HTML original. Ao executar JavaScript que modifica o DOM, as mudanças aparecem imediatamente na aba Elements.

---

## 14.2 — Seleção de elementos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Para manipular um elemento, é necessário primeiro **selecioná-lo** — obter uma referência ao nó DOM correspondente. O JavaScript oferece múltiplos métodos de seleção, cada um com sua semântica e caso de uso.

### 14.2.1 — Métodos modernos: `querySelector` e `querySelectorAll`

Os métodos mais versáteis e recomendados para seleção de elementos utilizam **seletores CSS** como argumento — tornando familiar a quem já domina CSS:

```javascript
// querySelector — retorna O PRIMEIRO elemento que corresponde ao seletor
// (ou null se nenhum for encontrado)
const titulo = document.querySelector('h1');
const primeiroBotao = document.querySelector('button');
const entrada = document.querySelector('#email');
const destaque = document.querySelector('.destaque');
const inputEmail = document.querySelector('input[type="email"]');
const primeiroLi = document.querySelector('nav ul > li:first-child');

// querySelectorAll — retorna TODOS os elementos correspondentes
// Retorna NodeList (similar a array, mas não é array)
const paragrafos = document.querySelectorAll('p');
const botoes = document.querySelectorAll('.btn');
const campos = document.querySelectorAll('input, select, textarea');

// Iterando sobre NodeList
paragrafos.forEach(p => {
  console.log(p.textContent);
});

// Convertendo NodeList para Array (para usar métodos como filter, map)
const arrayBotoes = Array.from(botoes);
// ou: const arrayBotoes = [...botoes];

// Seleção dentro de um elemento específico (não apenas no document)
const formulario = document.querySelector('#form-contato');
const camposDoForm = formulario.querySelectorAll('input, textarea');
```

### 14.2.2 — Métodos clássicos (ainda amplamente usados)

```javascript
// getElementById — seleciona por ID (mais rápido para IDs únicos)
const header = document.getElementById('cabecalho');
// Não usa # — o ID é passado direto como string

// getElementsByClassName — retorna HTMLCollection (dinâmica)
const cards = document.getElementsByClassName('card');

// getElementsByTagName — retorna HTMLCollection por tag
const links = document.getElementsByTagName('a');
const inputs = document.getElementsByTagName('input');

// Diferença importante: HTMLCollection vs NodeList
// HTMLCollection: atualizada automaticamente quando o DOM muda
// NodeList (querySelectorAll): estática — representa o DOM no momento da chamada
```

### 14.2.3 — Navegação pela árvore DOM

Além de selecionar diretamente, é possível **navegar** pela árvore a partir de um nó já referenciado:

```javascript
const lista = document.querySelector('ul');

// Filhos
lista.children          // HTMLCollection de filhos Element
lista.childNodes        // NodeList de todos os filhos (inclui Text nodes)
lista.firstElementChild // primeiro filho Element
lista.lastElementChild  // último filho Element

// Pai
lista.parentElement     // elemento pai
lista.parentNode        // nó pai (pode ser Document)
lista.closest('.container') // ancestral mais próximo que corresponde ao seletor

// Irmãos
lista.nextElementSibling     // próximo irmão Element
lista.previousElementSibling // irmão anterior Element

// Exemplo: percorrendo filhos
for (const item of lista.children) {
  console.log(item.textContent);
}
```

---

## 14.3 — Manipulação de conteúdo e atributos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 14.3.1 — Lendo e modificando conteúdo

```javascript
const titulo = document.querySelector('h1');
const paragrafo = document.querySelector('p');

// textContent — lê/modifica apenas o texto (sem HTML)
console.log(titulo.textContent); // → "Olá, DOM"
titulo.textContent = 'Novo título'; // altera o texto

// innerHTML — lê/modifica o HTML interno
paragrafo.innerHTML = '<strong>Texto em negrito</strong>';
// ⚠️ NUNCA use innerHTML com dados de usuário — risco de XSS

// innerText — similar ao textContent, mas considera CSS (mais lento)
// Não recomendado para escrita; use textContent

// Conteúdo de inputs
const input = document.querySelector('input');
input.value           // lê o valor atual
input.value = 'novo'; // define o valor

// Conteúdo de selects
const select = document.querySelector('select');
select.value          // opção selecionada

// Criando elementos com template literals (seguro)
function criarCard(produto) {
  const card = document.createElement('article');
  card.className = 'card';
  // textContent é seguro para texto; innerHTML apenas para HTML controlado
  card.innerHTML = `
    <h2 class="card__titulo">${escapeHtml(produto.nome)}</h2>
    <p class="card__preco">R$ ${produto.preco.toFixed(2)}</p>
  `;
  return card;
}

// Função auxiliar para escapar HTML (evita XSS)
function escapeHtml(texto) {
  const div = document.createElement('div');
  div.textContent = texto;
  return div.innerHTML;
}
```

### 14.3.2 — Manipulando atributos

```javascript
const link = document.querySelector('a');
const imagem = document.querySelector('img');
const input = document.querySelector('input[type="text"]');

// getAttribute / setAttribute
link.getAttribute('href')           // → "/pagina"
link.setAttribute('href', '/nova')  // modifica
link.setAttribute('target', '_blank') // adiciona

// Atributos como propriedades (para atributos padrão HTML)
link.href          // → URL completa (diferente de getAttribute)
imagem.src         // → URL completa da imagem
imagem.alt         // → texto alternativo
input.placeholder  // → placeholder
input.disabled     // → boolean
input.required     // → boolean

// removeAttribute
link.removeAttribute('target');

// hasAttribute
link.hasAttribute('download') // → false

// dataset — atributos data-*
// HTML: <div data-id="42" data-tipo="produto">
const div = document.querySelector('div');
div.dataset.id    // → "42"
div.dataset.tipo  // → "produto"
div.dataset.novoAtributo = 'valor'; // cria data-novo-atributo="valor"
```

### 14.3.3 — Manipulando classes CSS

```javascript
const elemento = document.querySelector('.card');

// classList API — a forma recomendada
elemento.classList.add('ativo');             // adiciona classe
elemento.classList.remove('oculto');         // remove classe
elemento.classList.toggle('expandido');      // adiciona se não tem, remove se tem
elemento.classList.toggle('oculto', false);  // force remove
elemento.classList.toggle('visivel', true);  // force add
elemento.classList.contains('ativo');        // → boolean
elemento.classList.replace('antigo', 'novo'); // substitui

// Múltiplas classes de uma vez
elemento.classList.add('ativo', 'destacado', 'animado');
elemento.classList.remove('oculto', 'desabilitado');

// className — lê/define todas as classes como string (evitar para manipulação)
console.log(elemento.className); // → "card ativo"
```

### 14.3.4 — Manipulando estilos inline

```javascript
const caixa = document.querySelector('.caixa');

// style — define estilos inline (camelCase para propriedades com hífen)
caixa.style.backgroundColor = '#E8632A';
caixa.style.fontSize = '1.5rem';
caixa.style.marginTop = '2rem';
caixa.style.display = 'none';  // oculta

// Removendo estilo inline
caixa.style.backgroundColor = ''; // string vazia remove a propriedade

// getComputedStyle — lê os estilos CALCULADOS (após cascata e herança)
const estilosCalculados = window.getComputedStyle(caixa);
estilosCalculados.backgroundColor // → "rgb(232, 99, 42)"
estilosCalculados.fontSize        // → "24px"
// getComputedStyle é somente leitura

// Variáveis CSS via JavaScript
document.documentElement.style.setProperty('--cor-primaria', '#E8632A');
const corAtual = getComputedStyle(document.documentElement)
  .getPropertyValue('--cor-primaria').trim();
```

### 14.3.5 — Criando, inserindo e removendo elementos

```javascript
// Criando elementos
const novoTitulo = document.createElement('h2');
novoTitulo.textContent = 'Novo título';
novoTitulo.className = 'titulo-secao';

const novoLink = document.createElement('a');
novoLink.href = '/pagina';
novoLink.textContent = 'Ir para a página';

// Inserindo no DOM
const container = document.querySelector('.container');

container.appendChild(novoTitulo);      // insere como último filho
container.prepend(novoLink);            // insere como primeiro filho
container.append('texto no final');     // append aceita string e nodes
container.insertBefore(novoTitulo, container.firstElementChild);

// insertAdjacentElement — mais controle sobre a posição
const referencia = document.querySelector('#secao-principal');
referencia.insertAdjacentElement('beforebegin', novoTitulo); // antes do elemento
referencia.insertAdjacentElement('afterbegin',  novoTitulo); // primeiro filho
referencia.insertAdjacentElement('beforeend',   novoTitulo); // último filho
referencia.insertAdjacentElement('afterend',    novoTitulo); // após o elemento

// insertAdjacentHTML — insere HTML como string
referencia.insertAdjacentHTML('beforeend', '<p>Novo parágrafo</p>');

// Removendo elementos
const elementoARemover = document.querySelector('.obsoleto');
elementoARemover.remove(); // remove a si mesmo

// Clonando
const copia = novoTitulo.cloneNode(true); // true = clona filhos também
container.appendChild(copia);

// Substituindo
const velho = document.querySelector('.velho');
const novo = document.createElement('span');
velho.replaceWith(novo);

// Fragment — para inserções eficientes de múltiplos elementos
const fragment = document.createDocumentFragment();
const produtos = ['Produto A', 'Produto B', 'Produto C'];

produtos.forEach(nome => {
  const li = document.createElement('li');
  li.textContent = nome;
  fragment.appendChild(li); // manipulações no fragment não afetam o DOM
});

document.querySelector('ul').appendChild(fragment); // uma única operação no DOM
```

---

## 14.4 — Eventos e interatividade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Os **eventos** são o mecanismo pelo qual JavaScript responde às ações do usuário e do navegador. Um evento é uma notificação de que algo aconteceu — um clique, uma digitação, o carregamento da página, o movimento do mouse. O JavaScript registra **listeners** (ouvintes) que são chamados quando determinados eventos ocorrem em determinados elementos.

### 14.4.1 — `addEventListener`

O método `addEventListener` é a forma recomendada de registrar event listeners:

```javascript
const botao = document.querySelector('#meu-botao');

// Sintaxe: elemento.addEventListener(evento, callback, opcoes)
botao.addEventListener('click', function(evento) {
  console.log('Clicado!', evento);
});

// Com arrow function
botao.addEventListener('click', (e) => {
  console.log('Clicado!', e.target);
});

// Função nomeada — permite remover o listener depois
function aoClicar(e) {
  console.log('Clicado!');
}

botao.addEventListener('click', aoClicar);
botao.removeEventListener('click', aoClicar); // remove o listener

// Opções
botao.addEventListener('click', aoClicar, {
  once: true,    // executa apenas uma vez e se remove
  passive: true, // indica que não chamará preventDefault (melhora performance em scroll)
  capture: true  // captura durante a fase de captura (ver 14.4.4)
});
```

### 14.4.2 — O objeto Event

O callback recebe um objeto `Event` com informações sobre o evento:

```javascript
document.querySelector('form').addEventListener('submit', (evento) => {
  // Previne o comportamento padrão (envio do formulário)
  evento.preventDefault();

  // Propriedades comuns a todos os eventos
  evento.type          // → "submit"
  evento.target        // elemento que disparou o evento
  evento.currentTarget // elemento onde o listener está registrado
  evento.timeStamp     // momento em que o evento ocorreu

  // stopPropagation — impede o evento de subir na árvore DOM
  evento.stopPropagation();
});

// Eventos de mouse
document.addEventListener('mousemove', (e) => {
  e.clientX  // posição X relativa à viewport
  e.clientY  // posição Y relativa à viewport
  e.pageX    // posição X relativa ao documento inteiro
  e.pageY    // posição Y
  e.button   // qual botão: 0=esquerdo, 1=meio, 2=direito
});

// Eventos de teclado
document.addEventListener('keydown', (e) => {
  e.key      // → "Enter", "Escape", "a", "ArrowLeft"...
  e.code     // → "KeyA", "Enter", "Space"... (independente do layout)
  e.ctrlKey  // → boolean
  e.shiftKey // → boolean
  e.altKey   // → boolean
  e.metaKey  // → boolean (Cmd no Mac)
});
```

### 14.4.3 — Eventos mais comuns

```javascript
// ── Eventos de mouse ──
elemento.addEventListener('click',      handler); // clique único
elemento.addEventListener('dblclick',   handler); // duplo clique
elemento.addEventListener('mouseenter', handler); // mouse entra (não borbulha)
elemento.addEventListener('mouseleave', handler); // mouse sai (não borbulha)
elemento.addEventListener('mouseover',  handler); // mouse sobre (borbulha)
elemento.addEventListener('mouseout',   handler); // mouse fora (borbulha)
elemento.addEventListener('mousedown',  handler); // botão pressionado
elemento.addEventListener('mouseup',    handler); // botão liberado
elemento.addEventListener('contextmenu', handler); // clique direito

// ── Eventos de teclado ──
elemento.addEventListener('keydown',  handler); // tecla pressionada
elemento.addEventListener('keyup',    handler); // tecla liberada
elemento.addEventListener('keypress', handler); // (depreciado — evitar)

// ── Eventos de formulário ──
input.addEventListener('input',   handler); // valor mudou (tempo real)
input.addEventListener('change',  handler); // valor confirmado (ao sair do campo)
input.addEventListener('focus',   handler); // campo recebeu foco
input.addEventListener('blur',    handler); // campo perdeu foco
form.addEventListener('submit',   handler); // formulário submetido
form.addEventListener('reset',    handler); // formulário reiniciado

// ── Eventos de documento/janela ──
document.addEventListener('DOMContentLoaded', handler); // DOM pronto
window.addEventListener('load',   handler); // página inteira carregada
window.addEventListener('resize', handler); // janela redimensionada
window.addEventListener('scroll', handler); // página rolada

// ── Eventos de toque (mobile) ──
elemento.addEventListener('touchstart', handler);
elemento.addEventListener('touchend',   handler);
elemento.addEventListener('touchmove',  handler);
```

### 14.4.4 — Event bubbling e delegação de eventos

**Event bubbling** (borbulhamento): quando um evento ocorre em um elemento, ele sobe pela árvore DOM — disparando nos ancestrais até alcançar o `document`. Isso permite uma técnica poderosa chamada **delegação de eventos**:

```javascript
// Problema: adicionar listener a cada item de uma lista dinâmica
// (ineficiente — e não funciona para itens adicionados depois)
document.querySelectorAll('.btn-remover').forEach(btn => {
  btn.addEventListener('click', removerItem);
});

// Solução: delegação de eventos — listener único no pai
const lista = document.querySelector('#lista-tarefas');

lista.addEventListener('click', (evento) => {
  // verifica se o clique foi num botão de remover
  if (evento.target.matches('.btn-remover')) {
    const item = evento.target.closest('li');
    item.remove();
  }

  // ou usando dataset para identificar a ação
  if (evento.target.dataset.acao === 'editar') {
    const id = evento.target.dataset.id;
    editarItem(id);
  }
});

// Vantagens da delegação:
// 1. Apenas um listener para N itens
// 2. Funciona automaticamente para elementos adicionados dinamicamente
// 3. Menos uso de memória
```

### 14.4.5 — Exemplo integrado: to-do list

```javascript
// HTML esperado:
// <form id="form-tarefa">
//   <input type="text" id="input-tarefa" placeholder="Nova tarefa..." required />
//   <button type="submit">Adicionar</button>
// </form>
// <ul id="lista-tarefas"></ul>

const form  = document.querySelector('#form-tarefa');
const input = document.querySelector('#input-tarefa');
const lista = document.querySelector('#lista-tarefas');

let tarefas = [];

// Adicionar tarefa
form.addEventListener('submit', (e) => {
  e.preventDefault();

  const texto = input.value.trim();
  if (!texto) return;

  const tarefa = {
    id: Date.now(),
    texto,
    concluida: false
  };

  tarefas.push(tarefa);
  input.value = '';
  renderizar();
  input.focus();
});

// Delegação para ações na lista
lista.addEventListener('click', (e) => {
  const id = Number(e.target.closest('[data-id]')?.dataset.id);
  if (!id) return;

  if (e.target.matches('.btn-concluir')) {
    tarefas = tarefas.map(t =>
      t.id === id ? { ...t, concluida: !t.concluida } : t
    );
  }

  if (e.target.matches('.btn-remover')) {
    tarefas = tarefas.filter(t => t.id !== id);
  }

  renderizar();
});

function renderizar() {
  lista.innerHTML = '';

  const fragment = document.createDocumentFragment();

  tarefas.forEach(tarefa => {
    const li = document.createElement('li');
    li.dataset.id = tarefa.id;
    li.className = `tarefa ${tarefa.concluida ? 'tarefa--concluida' : ''}`;
    li.innerHTML = `
      <span class="tarefa__texto">${escapeHtml(tarefa.texto)}</span>
      <div class="tarefa__acoes">
        <button class="btn-concluir" type="button"
                aria-label="${tarefa.concluida ? 'Reabrir' : 'Concluir'}">
          ${tarefa.concluida ? '↩' : '✓'}
        </button>
        <button class="btn-remover" type="button" aria-label="Remover">
          ✕
        </button>
      </div>
    `;
    fragment.appendChild(li);
  });

  lista.appendChild(fragment);
}

function escapeHtml(texto) {
  const div = document.createElement('div');
  div.textContent = texto;
  return div.innerHTML;
}
```

---

## 14.5 — Jogos no navegador: HTML5, CSS e JavaScript

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

Com o DOM, eventos e JavaScript essencial dominados, é possível construir experiências interativas completas diretamente no navegador — incluindo jogos. Esta seção apresenta três jogos em complexidade crescente, cada um introduzindo conceitos progressivos: lógica pura, manipulação de DOM com estado, e renderização com Canvas.

### 14.5.1 — O navegador como plataforma de jogos

O navegador moderno é uma plataforma de jogos completa. As tecnologias disponíveis incluem:

- **DOM + CSS:** suficiente para jogos baseados em elementos HTML (puzzles, jogos de cartas, quizzes, jogos de texto)
- **Canvas 2D:** API de desenho raster para jogos com gráficos personalizados (plataformers, shooters, Snake, Tetris)
- **WebGL:** renderização 3D com aceleração GPU
- **Web Audio API:** síntese e reprodução de áudio
- **Gamepad API:** suporte a controles

Para os exemplos deste capítulo, usaremos DOM e Canvas 2D — o suficiente para construir jogos funcionais e divertidos.

### 14.5.2 — O game loop: `requestAnimationFrame`

O **game loop** é o coração de qualquer jogo: um ciclo que, repetidamente, atualiza o estado do jogo e renderiza o resultado na tela. No navegador, o mecanismo correto para implementá-lo é `requestAnimationFrame`:

```javascript
// requestAnimationFrame chama o callback antes do próximo repaint do navegador
// Isso sincroniza o loop com a taxa de atualização da tela (geralmente 60fps)

function gameLoop(timestamp) {
  // timestamp: tempo em ms desde o início da página

  atualizar(timestamp); // atualiza posições, colisões, pontuação
  renderizar();         // redesenha a tela

  // agenda a próxima iteração
  requestAnimationFrame(gameLoop);
}

// Inicia o loop
requestAnimationFrame(gameLoop);

// Para pausar: guarde o ID retornado e cancele
let loopId;
loopId = requestAnimationFrame(gameLoop);
cancelAnimationFrame(loopId); // pausa o loop

// Calculando delta time — tempo entre frames (para movimento consistente)
let ultimoTimestamp = 0;

function gameLoop(timestamp) {
  const deltaTime = timestamp - ultimoTimestamp; // ms desde o último frame
  ultimoTimestamp = timestamp;

  // Mover 200 pixels por segundo, independente do fps
  posicaoX += velocidade * (deltaTime / 1000);

  requestAnimationFrame(gameLoop);
}
```

**Por que `requestAnimationFrame` e não `setInterval`?**

- Sincronizado com o ciclo de refresh da tela (60fps, 120fps, etc.)
- Pausa automaticamente quando a aba fica inativa (economiza bateria e CPU)
- Mais preciso que `setInterval` para animações

### 14.5.3 — Capturando entrada do usuário: teclado e mouse

```javascript
// Estado das teclas — melhor abordagem para jogos (permite múltiplas teclas)
const teclasPressionadas = new Set();

document.addEventListener('keydown', (e) => {
  teclasPressionadas.add(e.code);
  e.preventDefault(); // evita scroll da página com setas
});

document.addEventListener('keyup', (e) => {
  teclasPressionadas.delete(e.code);
});

// No game loop: verificar estado das teclas
function atualizar() {
  if (teclasPressionadas.has('ArrowLeft'))  jogador.x -= velocidade;
  if (teclasPressionadas.has('ArrowRight')) jogador.x += velocidade;
  if (teclasPressionadas.has('ArrowUp'))    jogador.y -= velocidade;
  if (teclasPressionadas.has('ArrowDown'))  jogador.y += velocidade;
  if (teclasPressionadas.has('Space'))      atirar();
}

// Mouse / touch no Canvas
const canvas = document.querySelector('canvas');

canvas.addEventListener('click', (e) => {
  const rect = canvas.getBoundingClientRect();
  const x = e.clientX - rect.left; // posição relativa ao canvas
  const y = e.clientY - rect.top;
  aoClicarEm(x, y);
});
```

---

### 14.5.4 — Jogo 1: Adivinhe o número

O primeiro jogo usa apenas lógica JavaScript e manipulação básica de DOM — sem canvas. O objetivo: adivinhar um número aleatório entre 1 e 100 com dicas de "maior" ou "menor".

> **Imagem sugerida:** captura do jogo em execução mostrando o campo de entrada, o histórico de tentativas e a mensagem de vitória com o número de tentativas.
>
> *(imagem será adicionada posteriormente)*

```html
<!-- HTML do jogo -->
<div class="jogo" id="jogo-adivinha">
  <h1>🎯 Adivinhe o número</h1>
  <p class="instrucao">Pensei em um número entre <strong>1</strong> e <strong>100</strong>.</p>

  <div class="entrada-grupo">
    <label for="palpite" class="sr-only">Seu palpite</label>
    <input type="number" id="palpite" min="1" max="100"
           placeholder="Digite seu palpite..." />
    <button type="button" id="btn-tentar">Tentar</button>
  </div>

  <p class="feedback" id="feedback" aria-live="polite"></p>
  <p class="tentativas" id="tentativas"></p>

  <ul class="historico" id="historico" aria-label="Histórico de tentativas"></ul>

  <button type="button" id="btn-reiniciar" class="btn-reiniciar hidden">
    Jogar novamente
  </button>
</div>
```

```javascript
// Lógica do jogo
const MINIMO = 1;
const MAXIMO = 100;

let numeroSecreto;
let totalTentativas;
let jogoAtivo;

function inicializar() {
  numeroSecreto = Math.floor(Math.random() * (MAXIMO - MINIMO + 1)) + MINIMO;
  totalTentativas = 0;
  jogoAtivo = true;

  // Resetar interface
  document.querySelector('#feedback').textContent = '';
  document.querySelector('#tentativas').textContent = '';
  document.querySelector('#historico').innerHTML = '';
  document.querySelector('#palpite').value = '';
  document.querySelector('#palpite').disabled = false;
  document.querySelector('#btn-tentar').disabled = false;
  document.querySelector('#btn-reiniciar').classList.add('hidden');
  document.querySelector('#palpite').focus();
}

function processarPalpite() {
  if (!jogoAtivo) return;

  const input = document.querySelector('#palpite');
  const palpite = parseInt(input.value);

  // Validação
  if (isNaN(palpite) || palpite < MINIMO || palpite > MAXIMO) {
    exibirFeedback(`Digite um número entre ${MINIMO} e ${MAXIMO}.`, 'aviso');
    return;
  }

  totalTentativas++;
  adicionarAoHistorico(palpite);
  input.value = '';
  input.focus();

  // Verificar resultado
  if (palpite === numeroSecreto) {
    exibirFeedback(
      `🎉 Parabéns! Você acertou em ${totalTentativas} tentativa${totalTentativas > 1 ? 's' : ''}!`,
      'sucesso'
    );
    encerrarJogo();
    return;
  }

  const dica = palpite < numeroSecreto ? '📈 Maior!' : '📉 Menor!';
  exibirFeedback(`${dica} Tentativa ${totalTentativas}.`, 'dica');
}

function adicionarAoHistorico(palpite) {
  const historico = document.querySelector('#historico');
  const li = document.createElement('li');
  li.textContent = `Tentativa ${totalTentativas}: ${palpite}`;

  const icone = palpite < numeroSecreto ? '↑' : '↓';
  li.insertAdjacentHTML('beforeend', ` <span class="dica-icone">${icone}</span>`);

  historico.prepend(li); // mais recente primeiro
}

function exibirFeedback(mensagem, tipo) {
  const el = document.querySelector('#feedback');
  el.textContent = mensagem;
  el.className = `feedback feedback--${tipo}`;
}

function encerrarJogo() {
  jogoAtivo = false;
  document.querySelector('#palpite').disabled = true;
  document.querySelector('#btn-tentar').disabled = true;
  document.querySelector('#btn-reiniciar').classList.remove('hidden');
}

// Event listeners
document.querySelector('#btn-tentar').addEventListener('click', processarPalpite);

document.querySelector('#palpite').addEventListener('keydown', (e) => {
  if (e.key === 'Enter') processarPalpite();
});

document.querySelector('#btn-reiniciar').addEventListener('click', inicializar);

// Iniciar
inicializar();
```

---

### 14.5.5 — Jogo 2: Clique no alvo

O segundo jogo introduz: geração dinâmica de elementos, posicionamento aleatório, timer com `setInterval`, e gerenciamento de estado mais complexo (pontuação, tempo restante, nível de dificuldade).

> **Imagem sugerida:** captura do jogo em andamento mostrando o alvo colorido em posição aleatória, o placar de pontos e o timer regressivo.
>
> *(imagem será adicionada posteriormente)*

```html
<!-- HTML do jogo -->
<div class="jogo-alvo" id="jogo-alvo">
  <header class="hud">
    <div class="hud__item">
      <span class="hud__label">Pontos</span>
      <span class="hud__valor" id="placar">0</span>
    </div>
    <div class="hud__item">
      <span class="hud__label">Tempo</span>
      <span class="hud__valor" id="timer">30</span>
    </div>
    <div class="hud__item">
      <span class="hud__label">Nível</span>
      <span class="hud__valor" id="nivel">1</span>
    </div>
  </header>

  <div class="arena" id="arena" aria-label="Arena do jogo">
    <!-- alvos são inseridos aqui via JavaScript -->
  </div>

  <div class="tela-inicio" id="tela-inicio">
    <h2>🎯 Clique no Alvo!</h2>
    <p>Clique nos alvos o mais rápido que puder.<br>
       Alvos maiores = menos pontos. Alvos menores = mais pontos!</p>
    <button type="button" id="btn-iniciar-alvo">Iniciar</button>
  </div>

  <div class="tela-fim hidden" id="tela-fim">
    <h2>Fim de jogo!</h2>
    <p>Pontuação final: <strong id="pontuacao-final">0</strong></p>
    <button type="button" id="btn-reiniciar-alvo">Jogar novamente</button>
  </div>
</div>
```

```javascript
// Estado do jogo
const estado = {
  pontos: 0,
  tempoRestante: 30,
  nivel: 1,
  ativo: false,
  intervalTimer: null,
  intervalAlvo: null
};

const arena = document.querySelector('#arena');

// Configurações por nível
const NIVEIS = {
  1: { intervalo: 1200, tamanhoMin: 60, tamanhoMax: 90, pontos: 10 },
  2: { intervalo: 900,  tamanhoMin: 45, tamanhoMax: 70, pontos: 15 },
  3: { intervalo: 650,  tamanhoMin: 30, tamanhoMax: 55, pontos: 25 },
  4: { intervalo: 450,  tamanhoMin: 20, tamanhoMax: 40, pontos: 40 },
};

function iniciarJogo() {
  // Reset estado
  estado.pontos = 0;
  estado.tempoRestante = 30;
  estado.nivel = 1;
  estado.ativo = true;

  // Atualizar HUD
  atualizarHUD();

  // Esconder telas de início/fim
  document.querySelector('#tela-inicio').classList.add('hidden');
  document.querySelector('#tela-fim').classList.add('hidden');

  // Timer regressivo
  estado.intervalTimer = setInterval(() => {
    estado.tempoRestante--;
    document.querySelector('#timer').textContent = estado.tempoRestante;

    // Aumentar nível a cada 10 segundos
    if (estado.tempoRestante === 20) subirNivel(2);
    if (estado.tempoRestante === 10) subirNivel(3);
    if (estado.tempoRestante === 5)  subirNivel(4);

    if (estado.tempoRestante <= 0) encerrarJogo();
  }, 1000);

  // Spawnar alvos
  spawnarAlvo();
  estado.intervalAlvo = setInterval(
    spawnarAlvo,
    NIVEIS[estado.nivel].intervalo
  );
}

function spawnarAlvo() {
  if (!estado.ativo) return;

  const cfg = NIVEIS[estado.nivel];
  const tamanho = aleatorio(cfg.tamanhoMin, cfg.tamanhoMax);
  const arenaRect = arena.getBoundingClientRect();

  // Posição aleatória dentro da arena
  const maxX = arenaRect.width - tamanho;
  const maxY = arenaRect.height - tamanho;
  const x = aleatorio(0, maxX);
  const y = aleatorio(0, maxY);

  const alvo = document.createElement('button');
  alvo.type = 'button';
  alvo.className = 'alvo';
  alvo.style.cssText = `
    width: ${tamanho}px;
    height: ${tamanho}px;
    left: ${x}px;
    top: ${y}px;
    background-color: hsl(${aleatorio(0, 360)}, 80%, 55%);
  `;
  alvo.setAttribute('aria-label', `Alvo: ${cfg.pontos} pontos`);

  // Remover alvo após 1.5x o intervalo se não for clicado
  const timeout = setTimeout(() => alvo.remove(), cfg.intervalo * 1.5);

  alvo.addEventListener('click', () => {
    clearTimeout(timeout);
    marcarPonto(alvo, cfg.pontos, x + tamanho / 2, y);
    alvo.remove();
  });

  arena.appendChild(alvo);
}

function marcarPonto(alvo, pontos, x, y) {
  estado.pontos += pontos;
  atualizarHUD();

  // Feedback visual: mostrar pontos ganhos
  const feedback = document.createElement('span');
  feedback.className = 'ponto-feedback';
  feedback.textContent = `+${pontos}`;
  feedback.style.cssText = `left: ${x}px; top: ${y}px;`;
  arena.appendChild(feedback);
  setTimeout(() => feedback.remove(), 600);
}

function subirNivel(novoNivel) {
  if (estado.nivel >= novoNivel) return;
  estado.nivel = novoNivel;
  document.querySelector('#nivel').textContent = novoNivel;

  clearInterval(estado.intervalAlvo);
  estado.intervalAlvo = setInterval(spawnarAlvo, NIVEIS[novoNivel].intervalo);
}

function atualizarHUD() {
  document.querySelector('#placar').textContent = estado.pontos;
}

function encerrarJogo() {
  estado.ativo = false;
  clearInterval(estado.intervalTimer);
  clearInterval(estado.intervalAlvo);
  arena.innerHTML = ''; // remove alvos restantes

  document.querySelector('#pontuacao-final').textContent = estado.pontos;
  document.querySelector('#tela-fim').classList.remove('hidden');
}

function aleatorio(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Event listeners
document.querySelector('#btn-iniciar-alvo').addEventListener('click', iniciarJogo);
document.querySelector('#btn-reiniciar-alvo').addEventListener('click', iniciarJogo);
```

---

### 14.5.6 — Jogo 3: Snake com Canvas

O terceiro jogo introduz o elemento `<canvas>` e a API de desenho 2D — a base para jogos com gráficos personalizados. O Snake é um clássico que demonstra: game loop com `requestAnimationFrame`, detecção de colisão, gerenciamento de estado complexo e renderização frame a frame.

> **Imagem sugerida:** captura do jogo Snake em andamento, mostrando a cobra de múltiplos segmentos, a maçã como alimento, o placar e o canvas com fundo escuro.
>
> *(imagem será adicionada posteriormente)*

```html
<!-- HTML do jogo -->
<div class="jogo-snake">
  <div class="snake-hud">
    <span>Pontos: <strong id="snake-placar">0</strong></span>
    <span>Recorde: <strong id="snake-recorde">0</strong></span>
  </div>

  <canvas id="canvas-snake" width="400" height="400"
          tabindex="0"
          aria-label="Jogo Snake — use as teclas de seta para mover">
  </canvas>

  <p class="snake-instrucao" id="snake-instrucao">
    Pressione qualquer seta para começar
  </p>
</div>
```

```javascript
// ── Configuração ──────────────────────────────────────────
const TAMANHO_CELULA = 20;  // px por célula da grade
const COLUNAS = 20;         // 400px / 20px = 20 células
const LINHAS  = 20;
const VELOCIDADE_INICIAL = 150; // ms entre frames lógicos

// ── Referências ───────────────────────────────────────────
const canvas   = document.querySelector('#canvas-snake');
const ctx      = canvas.getContext('2d');
const placarEl = document.querySelector('#snake-placar');
const recordeEl= document.querySelector('#snake-recorde');

// ── Estado do jogo ────────────────────────────────────────
let cobra, direcao, proximaDirecao, comida, pontos, recorde, ativo, loopId;
let ultimoFrame = 0;

function inicializar() {
  cobra = [
    { x: 10, y: 10 },  // cabeça
    { x: 9,  y: 10 },
    { x: 8,  y: 10 },
  ];
  direcao       = { x: 1, y: 0 }; // movendo para direita
  proximaDirecao = { x: 1, y: 0 };
  pontos        = 0;
  recorde       = parseInt(localStorage.getItem('snake-recorde') || '0');
  ativo         = false;

  gerarComida();
  atualizarPlacar();
  desenhar();

  canvas.focus();
}

// ── Controles ─────────────────────────────────────────────
document.addEventListener('keydown', (e) => {
  const mapa = {
    'ArrowUp':    { x: 0, y: -1 },
    'ArrowDown':  { x: 0, y: 1  },
    'ArrowLeft':  { x: -1, y: 0 },
    'ArrowRight': { x: 1,  y: 0 },
  };

  if (!mapa[e.code]) return;
  e.preventDefault();

  const nova = mapa[e.code];

  // Impede reversão de direção (não pode ir para trás)
  if (nova.x === -direcao.x && nova.y === -direcao.y) return;

  proximaDirecao = nova;

  // Iniciar jogo na primeira tecla pressionada
  if (!ativo) {
    ativo = true;
    document.querySelector('#snake-instrucao').style.display = 'none';
    requestAnimationFrame(gameLoop);
  }
});

// ── Game Loop ──────────────────────────────────────────────
function gameLoop(timestamp) {
  if (!ativo) return;

  const velocidade = Math.max(80, VELOCIDADE_INICIAL - pontos * 2);

  if (timestamp - ultimoFrame >= velocidade) {
    ultimoFrame = timestamp;
    atualizar();
  }

  desenhar();
  loopId = requestAnimationFrame(gameLoop);
}

// ── Lógica ────────────────────────────────────────────────
function atualizar() {
  direcao = { ...proximaDirecao };

  // Nova posição da cabeça
  const cabeca = {
    x: cobra[0].x + direcao.x,
    y: cobra[0].y + direcao.y
  };

  // Colisão com paredes
  if (
    cabeca.x < 0 || cabeca.x >= COLUNAS ||
    cabeca.y < 0 || cabeca.y >= LINHAS
  ) {
    gameOver();
    return;
  }

  // Colisão com o próprio corpo
  if (cobra.some(seg => seg.x === cabeca.x && seg.y === cabeca.y)) {
    gameOver();
    return;
  }

  cobra.unshift(cabeca); // adiciona nova cabeça

  // Verificar se comeu
  if (cabeca.x === comida.x && cabeca.y === comida.y) {
    pontos += 10;
    atualizarPlacar();
    gerarComida();
    // NÃO remove a cauda — cobra cresce
  } else {
    cobra.pop(); // remove a cauda
  }
}

function gerarComida() {
  // Posição aleatória que não seja ocupada pela cobra
  do {
    comida = {
      x: Math.floor(Math.random() * COLUNAS),
      y: Math.floor(Math.random() * LINHAS)
    };
  } while (cobra.some(seg => seg.x === comida.x && seg.y === comida.y));
}

function gameOver() {
  ativo = false;
  cancelAnimationFrame(loopId);

  // Salvar recorde
  if (pontos > recorde) {
    recorde = pontos;
    localStorage.setItem('snake-recorde', recorde);
  }

  // Desenhar tela de fim
  desenhar();
  ctx.fillStyle = 'rgba(0, 0, 0, 0.7)';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.fillStyle = 'white';
  ctx.font = 'bold 28px sans-serif';
  ctx.textAlign = 'center';
  ctx.fillText('Game Over!', canvas.width / 2, canvas.height / 2 - 20);

  ctx.font = '18px sans-serif';
  ctx.fillText(`Pontos: ${pontos}`, canvas.width / 2, canvas.height / 2 + 15);
  ctx.fillText('Pressione qualquer seta para reiniciar',
    canvas.width / 2, canvas.height / 2 + 45);

  atualizarPlacar();

  // Reiniciar ao pressionar tecla
  const reiniciar = (e) => {
    if (!['ArrowUp','ArrowDown','ArrowLeft','ArrowRight'].includes(e.code)) return;
    e.preventDefault();
    document.removeEventListener('keydown', reiniciar);
    inicializar();
  };
  document.addEventListener('keydown', reiniciar);
}

function atualizarPlacar() {
  placarEl.textContent = pontos;
  recordeEl.textContent = Math.max(recorde, pontos);
}

// ── Renderização ──────────────────────────────────────────
function desenhar() {
  // Fundo
  ctx.fillStyle = '#1a1a2e';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Grade sutil
  ctx.strokeStyle = 'rgba(255,255,255,0.03)';
  ctx.lineWidth = 0.5;
  for (let i = 0; i <= COLUNAS; i++) {
    ctx.beginPath();
    ctx.moveTo(i * TAMANHO_CELULA, 0);
    ctx.lineTo(i * TAMANHO_CELULA, canvas.height);
    ctx.stroke();
  }
  for (let i = 0; i <= LINHAS; i++) {
    ctx.beginPath();
    ctx.moveTo(0, i * TAMANHO_CELULA);
    ctx.lineTo(canvas.width, i * TAMANHO_CELULA);
    ctx.stroke();
  }

  // Comida
  const cx = comida.x * TAMANHO_CELULA + TAMANHO_CELULA / 2;
  const cy = comida.y * TAMANHO_CELULA + TAMANHO_CELULA / 2;
  ctx.fillStyle = '#E8632A';
  ctx.beginPath();
  ctx.arc(cx, cy, TAMANHO_CELULA / 2 - 2, 0, Math.PI * 2);
  ctx.fill();

  // Cobra
  cobra.forEach((segmento, indice) => {
    const ehCabeca = indice === 0;
    const x = segmento.x * TAMANHO_CELULA;
    const y = segmento.y * TAMANHO_CELULA;
    const s = TAMANHO_CELULA;
    const r = ehCabeca ? 6 : 3; // cantos mais arredondados na cabeça

    // Gradiente de cor do corpo (cabeça mais clara)
    const progresso = indice / cobra.length;
    const verde = Math.floor(200 - progresso * 80);
    ctx.fillStyle = ehCabeca
      ? `rgb(80, ${verde + 55}, 80)`
      : `rgb(40, ${verde}, 40)`;

    // Retângulo arredondado
    ctx.beginPath();
    ctx.roundRect(x + 1, y + 1, s - 2, s - 2, r);
    ctx.fill();

    // Olhos na cabeça
    if (ehCabeca) {
      ctx.fillStyle = 'white';
      const olhoOffset = 4;
      if (direcao.x === 1)  { // direita
        ctx.fillRect(x + s - 6, y + olhoOffset,     3, 3);
        ctx.fillRect(x + s - 6, y + s - olhoOffset - 3, 3, 3);
      } else if (direcao.x === -1) { // esquerda
        ctx.fillRect(x + 3, y + olhoOffset,     3, 3);
        ctx.fillRect(x + 3, y + s - olhoOffset - 3, 3, 3);
      } else if (direcao.y === -1) { // cima
        ctx.fillRect(x + olhoOffset,     y + 3, 3, 3);
        ctx.fillRect(x + s - olhoOffset - 3, y + 3, 3, 3);
      } else { // baixo
        ctx.fillRect(x + olhoOffset,     y + s - 6, 3, 3);
        ctx.fillRect(x + s - olhoOffset - 3, y + s - 6, 3, 3);
      }
    }
  });
}

// Iniciar
inicializar();
```

### 14.5.7 — Próximos passos: onde ir depois

Os três jogos deste capítulo introduzem os fundamentos do desenvolvimento de jogos no navegador. Para aprofundamento:

**Frameworks e bibliotecas de jogos 2D:**
- **Phaser** ([phaser.io](https://phaser.io)) — o framework mais popular para jogos 2D no navegador; inclui física, animações, tilemaps e muito mais
- **PixiJS** ([pixijs.com](https://pixijs.com)) — renderização 2D de alto desempenho com WebGL

**Conceitos para explorar:**
- Física básica: gravidade, velocidade, aceleração
- Detecção de colisão AABB (*Axis-Aligned Bounding Box*)
- Tilemaps: mapas baseados em grades
- Sprites e animações de quadros
- Som com a Web Audio API
- Persistência de dados com `localStorage`

**Referências:**
- [MDN — Canvas API](https://developer.mozilla.org/pt-BR/docs/Web/API/Canvas_API)
- [MDN — requestAnimationFrame](https://developer.mozilla.org/pt-BR/docs/Web/API/window/requestAnimationFrame)
- [javascript.info — Canvas](https://javascript.info/canvas)

---

**Referências gerais do capítulo:**
- [MDN — Introdução ao DOM](https://developer.mozilla.org/pt-BR/docs/Web/API/Document_Object_Model/Introduction)
- [MDN — EventTarget.addEventListener](https://developer.mozilla.org/pt-BR/docs/Web/API/EventTarget/addEventListener)
- [javascript.info — Document](https://javascript.info/document)

---

#### **Atividades — Capítulo 14**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Qual é a diferença entre <code>textContent</code> e <code>innerHTML</code> ao modificar o conteúdo de um elemento?</p>
  <button data-option="a">Não há diferença — ambos definem o conteúdo do elemento.</button>
  <button data-option="b"><code>textContent</code> trata o valor como texto puro (escapando HTML), tornando-o seguro para dados do usuário; <code>innerHTML</code> interpreta o valor como HTML, permitindo injeção de elementos mas representando risco de XSS com dados não sanitizados.</button>
  <button data-option="c"><code>innerHTML</code> é mais lento que <code>textContent</code> em todos os casos.</button>
  <button data-option="d"><code>textContent</code> só funciona em elementos de texto como <code>&lt;p&gt;</code> e <code>&lt;span&gt;</code>.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> O que é delegação de eventos e por que é preferível a adicionar listeners individuais a cada elemento de uma lista dinâmica?</p>
  <button data-option="a">Delegação de eventos é uma técnica para prevenir o borbulhamento de eventos usando <code>stopPropagation()</code>.</button>
  <button data-option="b">Delegação de eventos é a prática de usar <code>addEventListener</code> no <code>document</code> em vez de em elementos individuais.</button>
  <button data-option="c">Delegação de eventos registra um único listener no elemento pai, que captura eventos de todos os filhos via borbulhamento — é mais eficiente em memória e funciona automaticamente para elementos adicionados dinamicamente ao DOM.</button>
  <button data-option="d">Delegação de eventos só funciona com o evento <code>click</code>.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> Por que <code>requestAnimationFrame</code> é preferível a <code>setInterval</code> para game loops?</p>
  <button data-option="a">Porque <code>requestAnimationFrame</code> executa mais vezes por segundo que <code>setInterval</code>.</button>
  <button data-option="b">Porque <code>setInterval</code> foi depreciado no HTML5.</button>
  <button data-option="c">Porque <code>requestAnimationFrame</code> aceita funções assíncronas e <code>setInterval</code> não.</button>
  <button data-option="d">Porque <code>requestAnimationFrame</code> sincroniza com o ciclo de refresh da tela, pausa automaticamente em abas inativas e é mais preciso para animações — enquanto <code>setInterval</code> pode acumular atrasos e continuar executando desnecessariamente.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Implementar uma aplicação de lista de tarefas completa com: adicionar, concluir e remover tarefas via DOM; persistência no `localStorage`; filtros (todas, ativas, concluídas) usando delegação de eventos; e contador de tarefas pendentes atualizado em tempo real. *(link será adicionado)*

- **Desafio (opcional):** Estender o jogo Snake adicionando: níveis de dificuldade selecionáveis antes de iniciar; obstáculos fixos que aumentam a cada nível; efeito sonoro de "comer" com a Web Audio API. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 13 — JavaScript Essencial](13-javascript-essencial.md)
[:material-arrow-right: Ir ao Capítulo 15 — Eventos e Formulários com JavaScript](15-eventos-formularios.md)
