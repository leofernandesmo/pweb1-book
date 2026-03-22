# Capítulo 13 — JavaScript Essencial

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 13.1 — JavaScript no navegador: contexto e papel

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O **JavaScript** é a linguagem de programação nativa do navegador web — o único ambiente de execução de código que opera diretamente no cliente, sem necessidade de instalação ou plugin. Criado em 1995 por **Brendan Eich** na Netscape Communications em apenas dez dias, o JavaScript foi concebido originalmente como uma linguagem de scripting para adicionar comportamento interativo simples a páginas HTML. Nas três décadas seguintes, evoluiu para uma das linguagens de programação mais amplamente utilizadas do mundo, presente em navegadores, servidores, dispositivos embarcados e aplicações de desktop.

### 13.1.1 — O que é JavaScript e sua história

JavaScript é uma linguagem **interpretada**, **dinamicamente tipada**, **multiparadigma** — suportando programação imperativa, orientada a objetos (com protótipos) e funcional — e **single-threaded** (executada em uma única thread). Sua especificação formal é mantida pela **ECMA International** sob o nome **ECMAScript** (ES). A versão ES5 (2009) modernizou a linguagem; o ES6/ES2015 representou a maior atualização da história, introduzindo `let`, `const`, arrow functions, classes, Promises, módulos e dezenas de outras funcionalidades. Desde então, novas versões são publicadas anualmente.

> **Nota terminológica:** JavaScript e ECMAScript são frequentemente usados como sinônimos. Tecnicamente, ECMAScript é a especificação; JavaScript é a implementação da especificação pelo navegador (e pelo Node.js). Ao longo deste capítulo, usaremos JavaScript como termo geral.

A padronização da linguagem foi motivada por uma guerra de incompatibilidades nos anos 1990, quando diferentes navegadores implementavam versões conflitantes. A criação do padrão ECMAScript pelo consórcio ECMA em 1997 iniciou a convergência que tornaria o JavaScript universal.

### 13.1.2 — JavaScript no navegador vs Node.js: o mesmo idioma, contextos diferentes

Na disciplina de Introdução à Programação, você provavelmente trabalhou com JavaScript no contexto do **Node.js** — um ambiente de execução JavaScript no servidor, criado em 2009, que permitiu usar a linguagem fora do navegador. É importante compreender que Node.js e o navegador compartilham **o mesmo núcleo da linguagem** (ECMAScript), mas operam em contextos com APIs completamente diferentes:

| | JavaScript no Navegador | JavaScript no Node.js |
|---|---|---|
| **Ambiente** | Navegador (Chrome, Firefox...) | Servidor / terminal |
| **Objeto global** | `window` | `global` / `globalThis` |
| **APIs exclusivas** | DOM, BOM, Fetch, Web APIs | `fs`, `http`, `path`, `process` |
| **Acesso ao sistema** | Restrito (sandbox) | Amplo (arquivos, rede, SO) |
| **Entrada do usuário** | Eventos de mouse, teclado, formulários | `process.stdin`, argumentos |
| **Saída visual** | DOM — manipula HTML/CSS | Terminal / arquivos |

O núcleo da linguagem — tipos de dados, funções, arrays, objetos, loops, condicionais, Promises, `async/await` — é idêntico em ambos os contextos. O que muda são as APIs disponíveis para interagir com o ambiente.

**Neste capítulo e nos seguintes**, o foco é o JavaScript no navegador: como ele interage com o HTML via DOM, como responde a eventos do usuário e como busca dados de servidores via Fetch API.

### 13.1.3 — Como o navegador executa JavaScript: o event loop e a thread única

Compreender o modelo de execução do JavaScript no navegador é fundamental para evitar erros comuns e escrever código assíncrono corretamente.

O JavaScript é **single-threaded** — executa em uma única thread, processando uma operação por vez. Isso significa que não há paralelismo nativo: enquanto um bloco de código está em execução, nenhum outro código JavaScript pode ser executado simultaneamente.

O mecanismo que permite ao JavaScript lidar com operações demoradas (requisições de rede, timers, eventos do usuário) sem bloquear a interface é o **event loop**:

```
┌─────────────────────────────────┐
│         Call Stack              │  ← onde o código é executado
│  (pilha de chamadas de função)  │
└────────────────┬────────────────┘
                 │
┌────────────────▼────────────────┐
│           Event Loop            │  ← monitora stack + queue
└────────────────┬────────────────┘
                 │
┌────────────────▼────────────────┐
│         Callback Queue          │  ← callbacks aguardando execução
│  (eventos, timers, fetch...)    │
└─────────────────────────────────┘
```

O funcionamento é: quando uma operação assíncrona (como `fetch()` ou `setTimeout()`) é iniciada, ela é delegada ao navegador (Web APIs). Quando completa, seu callback é colocado na fila (*queue*). O event loop verifica continuamente: se a call stack estiver vazia, pega o próximo callback da fila e o executa.

**Consequência prática:** código JavaScript que bloqueia a call stack por muito tempo (loops longos, computação pesada) trava a interface do usuário — o navegador não consegue processar eventos nem re-renderizar a página enquanto a stack não esvazia. Por isso, operações demoradas devem ser assíncronas.

### 13.1.4 — Como incluir JavaScript no HTML: `<script>`, `defer` e `async`

Existem três formas de incluir JavaScript em um documento HTML, cada uma com comportamento de carregamento distinto:

**Inline (no corpo do HTML):**
```html
<script>
  console.log('Executado imediatamente ao ser encontrado pelo parser');
</script>
```

**Arquivo externo — sem atributos (bloqueante):**
```html
<!-- O parser HTML pausa, baixa e executa o script, depois continua -->
<script src="js/script.js"></script>
```

**Arquivo externo — com `defer` (recomendado):**
```html
<!-- Download paralelo; executa apenas após o HTML ser completamente parseado -->
<script src="js/script.js" defer></script>
```

**Arquivo externo — com `async`:**
```html
<!-- Download paralelo; executa imediatamente quando o download termina
     (pode interromper o parsing do HTML) -->
<script src="js/script.js" async></script>
```

> **Imagem sugerida:** diagrama comparativo mostrando a linha do tempo de parsing HTML, download e execução do script para os três comportamentos (sem atributo, `defer`, `async`) — ilustrando visualmente por que `defer` é a escolha mais segura para scripts que dependem do DOM.
>
> *(imagem será adicionada posteriormente)*

**Regra prática:** use sempre `defer` para scripts que interagem com o DOM. Use `async` apenas para scripts completamente independentes (como analytics). Nunca coloque scripts sem atributos no `<head>` — coloque-os antes de `</body>` ou use `defer`.

```html
<!-- Padrão recomendado -->
<head>
  <meta charset="UTF-8" />
  <title>Página</title>
  <link rel="stylesheet" href="css/style.css" />
  <!-- defer: baixa em paralelo, executa após o DOM estar pronto -->
  <script src="js/app.js" defer></script>
</head>
```

### 13.1.5 — O console do navegador como ambiente de aprendizado

O **Console** do DevTools (`F12` → aba Console) é o ambiente interativo mais imediato para experimentar JavaScript. Ele funciona como um REPL (*Read-Eval-Print Loop*) — você digita uma expressão, pressiona Enter, e o resultado é exibido imediatamente.

```javascript
// Exemplos para experimentar no console do navegador

// Saída no console
console.log('Olá, navegador!');
console.warn('Aviso');
console.error('Erro');
console.table([{ nome: 'Ana', nota: 9 }, { nome: 'Bruno', nota: 7 }]);

// Expressões são avaliadas imediatamente
2 + 2          // → 4
'olá' + ' mundo' // → "olá mundo"
typeof 42      // → "number"

// Variáveis persistem durante a sessão
let x = 10;
x * 3;         // → 30
```

---

## 13.2 — Variáveis, tipos e operadores

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 13.2.1 — `var`, `let` e `const`: diferenças e boas práticas

JavaScript possui três palavras-chave para declaração de variáveis, com comportamentos distintos em relação a escopo, reatribuição e hoisting:

```javascript
// var — escopo de função, sofre hoisting, evitar em código moderno
var nome = 'Ana';
var nome = 'Bruno'; // redeclaração permitida — fonte de bugs

// let — escopo de bloco, pode ser reatribuída, não pode ser redeclarada
let contador = 0;
contador = 1;       // reatribuição permitida
// let contador = 2; // erro: já foi declarada neste escopo

// const — escopo de bloco, não pode ser reatribuída após a declaração
const PI = 3.14159;
// PI = 3;           // erro: assignment to constant variable

// IMPORTANTE: const não significa "imutável" — significa "não reatribuível"
// Objetos e arrays declarados com const podem ter seu conteúdo alterado
const usuario = { nome: 'Ana', idade: 20 };
usuario.idade = 21;   // permitido: alterando propriedade
// usuario = {};       // erro: reatribuindo a variável
```

**Regra prática moderna:**
- Use `const` por padrão para tudo
- Use `let` apenas quando a variável precisar ser reatribuída (contadores, acumuladores)
- Nunca use `var` em código novo — seu comportamento de escopo e hoisting é fonte de bugs

| | `var` | `let` | `const` |
|---|---|---|---|
| Escopo | Função | Bloco | Bloco |
| Hoisting | Sim (com `undefined`) | Sim (TDZ) | Sim (TDZ) |
| Reatribuição | Sim | Sim | Não |
| Redeclaração | Sim | Não | Não |

### 13.2.2 — Tipos primitivos

JavaScript possui seis tipos primitivos e um tipo de objeto:

```javascript
// string — sequência de caracteres
const nome = 'Maria';
const mensagem = "Olá, mundo!";
const template = `Olá, ${nome}!`; // template literal

// number — todos os números (inteiros e decimais)
const inteiro = 42;
const decimal = 3.14;
const negativo = -7;
const infinito = Infinity;
const naoNumero = NaN; // Not a Number — resultado de operação inválida

// boolean
const ativo = true;
const arquivado = false;

// null — ausência intencional de valor
const semValor = null;

// undefined — variável declarada mas não inicializada
let naoInicializada;
console.log(naoInicializada); // → undefined

// symbol — identificador único (uso avançado)
const id = Symbol('id');

// bigint — inteiros arbitrariamente grandes
const grandeNumero = 9007199254740991n;

// typeof: verifica o tipo de um valor
typeof 'texto'    // → "string"
typeof 42         // → "number"
typeof true       // → "boolean"
typeof undefined  // → "undefined"
typeof null       // → "object" ← bug histórico da linguagem
typeof {}         // → "object"
typeof []         // → "object"
typeof function(){} // → "function"
```

### 13.2.3 — Tipagem dinâmica e coerção de tipos

JavaScript é **dinamicamente tipado** — o tipo de uma variável é determinado pelo valor que ela contém em determinado momento, não por uma declaração explícita. Uma mesma variável pode conter diferentes tipos ao longo da execução.

A **coerção de tipos** (*type coercion*) é a conversão automática entre tipos realizada pelo JavaScript em determinadas operações — um comportamento que frequentemente surpreende desenvolvedores iniciantes:

```javascript
// Coerção implícita — acontece automaticamente
'5' + 3      // → "53"  (number coercido para string)
'5' - 3      // → 2     (string coercida para number)
'5' * '3'    // → 15    (ambas coercidas para number)
true + 1     // → 2     (true vira 1)
false + 1    // → 1     (false vira 0)
null + 1     // → 1     (null vira 0)
undefined + 1 // → NaN

// Comparação com coerção (==) vs sem coerção (===)
5 == '5'    // → true  (coerção: '5' vira 5)
5 === '5'   // → false (sem coerção: tipos diferentes)
null == undefined  // → true
null === undefined // → false

// Conversão explícita — sempre preferível à implícita
Number('42')        // → 42
Number('')          // → 0
Number('abc')       // → NaN
String(42)          // → "42"
Boolean(0)          // → false
Boolean('')         // → false
Boolean(null)       // → false
Boolean(undefined)  // → false
Boolean(NaN)        // → false
Boolean([])         // → true  (array vazio é truthy!)
Boolean({})         // → true  (objeto vazio é truthy!)
parseInt('42px')    // → 42
parseFloat('3.14m') // → 3.14
```

> **Boa prática:** sempre use `===` (igualdade estrita) e `!==` em vez de `==` e `!=`. A igualdade estrita não realiza coerção de tipos, produzindo resultados mais previsíveis.

### 13.2.4 — Operadores aritméticos, de comparação e lógicos

```javascript
// ── Aritméticos ──
10 + 3   // → 13
10 - 3   // → 7
10 * 3   // → 30
10 / 3   // → 3.3333...
10 % 3   // → 1  (resto da divisão)
10 ** 3  // → 1000 (exponenciação)

// Incremento e decremento
let x = 5;
x++;    // x = 6 (pós-incremento)
++x;    // x = 7 (pré-incremento)
x--;    // x = 6
--x;    // x = 5

// Atribuição composta
x += 10;  // x = x + 10
x -= 5;   // x = x - 5
x *= 2;   // x = x * 2
x /= 4;   // x = x / 4
x **= 2;  // x = x ** 2
x %= 3;   // x = x % 3

// ── Comparação ──
5 > 3     // → true
5 < 3     // → false
5 >= 5    // → true
5 <= 4    // → false
5 === 5   // → true  (igualdade estrita — recomendada)
5 !== 3   // → true  (desigualdade estrita)

// ── Lógicos ──
true && true    // → true   (E lógico)
true && false   // → false
false || true   // → true   (OU lógico)
false || false  // → false
!true           // → false  (NÃO lógico)
!false          // → true

// Short-circuit evaluation
false && expressaoCara()  // expressaoCara() NÃO é chamada
true  || expressaoCara()  // expressaoCara() NÃO é chamada

// Uso prático do short-circuit
const nome = usuario.nome || 'Anônimo'; // fallback se nome for falsy
const exibir = estaLogado && renderizarPerfil(); // executa apenas se logado
```

### 13.2.5 — Template literals

Template literals são strings delimitadas por backticks (`` ` ``) que permitem interpolação de expressões e strings multilinhas:

```javascript
const nome = 'Ana';
const nota = 9.5;

// Interpolação de variáveis e expressões
const mensagem = `Olá, ${nome}! Sua nota foi ${nota}.`;
// → "Olá, Ana! Sua nota foi 9.5."

const calculo = `Resultado: ${10 * 3 + 5}`;
// → "Resultado: 35"

// Expressões complexas
const aprovado = `${nome} foi ${nota >= 7 ? 'aprovada' : 'reprovada'}.`;
// → "Ana foi aprovada."

// String multilinha — sem necessidade de \n
const html = `
  <article class="card">
    <h2>${nome}</h2>
    <p>Nota: ${nota}</p>
  </article>
`;
```

### 13.2.6 — Nullish coalescing (`??`) e optional chaining (`?.`)

Dois operadores modernos do ES2020 que simplificam o tratamento de valores nulos:

```javascript
// Nullish coalescing (??) — retorna o lado direito apenas se o esquerdo
// for null ou undefined (diferente de ||, que reage a qualquer falsy)
const nome = null ?? 'Anônimo';        // → "Anônimo"
const porto = undefined ?? 'Maceió';   // → "Maceió"
const zero = 0 ?? 42;                  // → 0  (|| retornaria 42)
const vazio = '' ?? 'padrão';          // → '' (|| retornaria 'padrão')

// Optional chaining (?.) — acessa propriedades sem lançar erro se o objeto
// for null ou undefined
const usuario = null;
const cidade = usuario?.endereco?.cidade; // → undefined (sem erro)
// sem ?.: usuario.endereco lançaria TypeError

const usuarios = [{ nome: 'Ana' }, null];
const primeiroNome = usuarios[0]?.nome;  // → "Ana"
const segundoNome  = usuarios[1]?.nome;  // → undefined (sem erro)

// Combinando ?? com ?.
const cidade = usuario?.endereco?.cidade ?? 'Cidade não informada';
```

---

## 13.3 — Funções e escopo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 13.3.1 — Declaração de função vs expressão de função

```javascript
// Declaração de função (function declaration)
// Sofre hoisting completo — pode ser chamada antes de ser declarada
function saudacao(nome) {
  return `Olá, ${nome}!`;
}

console.log(saudacao('Maria')); // → "Olá, Maria!"

// Expressão de função (function expression)
// NÃO sofre hoisting — deve ser declarada antes de ser chamada
const saudacao = function(nome) {
  return `Olá, ${nome}!`;
};

// Função nomeada — útil para debug e recursão
const fatorial = function calcularFatorial(n) {
  return n <= 1 ? 1 : n * calcularFatorial(n - 1);
};
```

### 13.3.2 — Arrow functions

Arrow functions são uma sintaxe concisa para funções introduzida no ES6. Além da brevidade, possuem uma diferença semântica importante em relação ao `this` — relevante no contexto do DOM (Capítulo 14):

```javascript
// Sintaxe básica
const dobrar = (n) => n * 2;
const somar = (a, b) => a + b;

// Parênteses opcionais com um único parâmetro
const quadrado = n => n * n;

// Sem parâmetros: parênteses obrigatórios
const saudacao = () => 'Olá!';

// Corpo com múltiplas linhas: chaves e return explícito
const calcularImc = (peso, altura) => {
  const imc = peso / (altura * altura);
  return imc.toFixed(2);
};

// Retorno de objeto literal: envolva em parênteses
const criarUsuario = (nome, idade) => ({ nome, idade });
// sem parênteses, as chaves seriam interpretadas como corpo da função

// Arrow functions são ideais como callbacks
const numeros = [1, 2, 3, 4, 5];
const dobrados = numeros.map(n => n * 2);     // → [2, 4, 6, 8, 10]
const pares    = numeros.filter(n => n % 2 === 0); // → [2, 4]
```

### 13.3.3 — Parâmetros padrão e rest parameters

```javascript
// Parâmetros padrão (default parameters)
function cumprimentar(nome, saudacao = 'Olá') {
  return `${saudacao}, ${nome}!`;
}

cumprimentar('Ana');           // → "Olá, Ana!"
cumprimentar('Ana', 'Bem-vinda'); // → "Bem-vinda, Ana!"

// Rest parameters (...) — agrupa argumentos extras em um array
function somar(...numeros) {
  return numeros.reduce((total, n) => total + n, 0);
}

somar(1, 2, 3)       // → 6
somar(1, 2, 3, 4, 5) // → 15

// Combinando parâmetros normais com rest
function log(nivel, ...mensagens) {
  console.log(`[${nivel}]`, ...mensagens);
}

log('INFO', 'Servidor iniciado', 'porta 3000');
// → [INFO] Servidor iniciado porta 3000
```

### 13.3.4 — Escopo: global, de função e de bloco

O **escopo** determina onde uma variável é acessível. JavaScript possui três níveis:

```javascript
// Escopo global — acessível em qualquer lugar
const APP_NOME = 'PWEB1';

function demonstrar() {
  // Escopo de função — acessível apenas dentro da função
  const local = 'variável local';
  console.log(APP_NOME); // → 'PWEB1' (acessa escopo global)
  console.log(local);    // → 'variável local'

  if (true) {
    // Escopo de bloco (let e const) — acessível apenas dentro do bloco
    let bloco = 'variável de bloco';
    var funcao = 'variável de função'; // var ignora o bloco!
    console.log(bloco);  // → 'variável de bloco'
  }

  // console.log(bloco); // ReferenceError: bloco is not defined
  console.log(funcao); // → 'variável de função' (var ignora o bloco)
}

// console.log(local); // ReferenceError: local is not defined
```

### 13.3.5 — Hoisting

**Hoisting** é o comportamento pelo qual declarações de funções e variáveis são "elevadas" para o topo do seu escopo antes da execução:

```javascript
// Declarações de função sofrem hoisting completo
console.log(somar(2, 3)); // → 5 — funciona antes da declaração!

function somar(a, b) {
  return a + b;
}

// var sofre hoisting mas é inicializado como undefined
console.log(x); // → undefined (não lança erro)
var x = 10;
console.log(x); // → 10

// let e const sofrem hoisting mas ficam na Temporal Dead Zone (TDZ)
// console.log(y); // ReferenceError: Cannot access 'y' before initialization
let y = 20;

// Expressões de função NÃO sofrem hoisting
// console.log(multiplicar(2, 3)); // TypeError: multiplicar is not a function
const multiplicar = (a, b) => a * b;
```

### 13.3.6 — Closures: conceito e casos de uso práticos

Uma **closure** é a capacidade de uma função de "lembrar" e acessar variáveis do escopo onde foi criada, mesmo após esse escopo ter encerrado sua execução. É um dos conceitos mais poderosos e fundamentais do JavaScript:

```javascript
// Exemplo fundamental de closure
function criarContador() {
  let contagem = 0; // variável do escopo externo

  return function() {
    contagem++;
    return contagem;
  };
}

const contador = criarContador();
console.log(contador()); // → 1
console.log(contador()); // → 2
console.log(contador()); // → 3
// 'contagem' é inacessível diretamente, mas a função interna a "lembra"

// Closure com parâmetro — fábrica de funções
function multiplicadorDe(fator) {
  return (numero) => numero * fator;
}

const dobrar  = multiplicadorDe(2);
const triplicar = multiplicadorDe(3);

dobrar(5)    // → 10
triplicar(5) // → 15

// Caso de uso prático: encapsulamento de estado
function criarCarrinho() {
  const itens = []; // privado — inacessível externamente

  return {
    adicionar(produto) { itens.push(produto); },
    remover(nome) {
      const idx = itens.findIndex(i => i.nome === nome);
      if (idx !== -1) itens.splice(idx, 1);
    },
    total() { return itens.reduce((s, i) => s + i.preco, 0); },
    listar() { return [...itens]; }
  };
}

const carrinho = criarCarrinho();
carrinho.adicionar({ nome: 'Curso JS', preco: 99 });
carrinho.adicionar({ nome: 'Livro CSS', preco: 49 });
console.log(carrinho.total()); // → 148
```

---

## 13.4 — Arrays e objetos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 13.4.1 — Arrays: criação, acesso e métodos essenciais

```javascript
// Criação
const frutas = ['maçã', 'banana', 'laranja'];
const numeros = [1, 2, 3, 4, 5];
const misto = [1, 'texto', true, null, { chave: 'valor' }];
const vazio = [];
const tamanho5 = new Array(5).fill(0); // → [0, 0, 0, 0, 0]

// Acesso por índice (começa em 0)
frutas[0]  // → 'maçã'
frutas[2]  // → 'laranja'
frutas.at(-1) // → 'laranja' (último elemento — ES2022)

// Propriedade length
frutas.length // → 3

// Adição e remoção
frutas.push('uva');       // adiciona ao final → ['maçã','banana','laranja','uva']
frutas.pop();             // remove do final → ['maçã','banana','laranja']
frutas.unshift('morango');// adiciona ao início → ['morango','maçã','banana','laranja']
frutas.shift();           // remove do início → ['maçã','banana','laranja']

// splice: remove/insere em posição específica
frutas.splice(1, 1);              // remove 1 elemento a partir do índice 1
frutas.splice(1, 0, 'pêra', 'kiwi'); // insere sem remover

// slice: extrai sem modificar o original
const primeiras = frutas.slice(0, 2);  // cópia dos 2 primeiros
const ultimas   = frutas.slice(-2);    // cópia dos 2 últimos

// indexOf e includes
frutas.indexOf('banana')   // → 1 (ou -1 se não encontrar)
frutas.includes('laranja') // → true

// join e split
frutas.join(', ')             // → "maçã, banana, laranja"
'a,b,c'.split(',')            // → ['a', 'b', 'c']

// sort e reverse
[3,1,4,1,5].sort((a, b) => a - b) // → [1, 1, 3, 4, 5]
frutas.reverse()                   // inverte no lugar
```

### 13.4.2 — Métodos funcionais: `map`, `filter`, `reduce`, `find`, `some`, `every`

Estes métodos são fundamentais no JavaScript moderno — especialmente para manipular dados vindos de APIs:

```javascript
const alunos = [
  { nome: 'Ana',   nota: 9.5, aprovado: true  },
  { nome: 'Bruno', nota: 5.0, aprovado: false },
  { nome: 'Carla', nota: 8.2, aprovado: true  },
  { nome: 'Diego', nota: 6.8, aprovado: true  },
];

// map — transforma cada elemento, retorna novo array de mesmo tamanho
const nomes = alunos.map(a => a.nome);
// → ['Ana', 'Bruno', 'Carla', 'Diego']

const notas = alunos.map(a => a.nota);
// → [9.5, 5.0, 8.2, 6.8]

const resumos = alunos.map(a =>
  `${a.nome}: ${a.aprovado ? '✓' : '✗'}`
);
// → ['Ana: ✓', 'Bruno: ✗', 'Carla: ✓', 'Diego: ✓']

// filter — retorna novo array com elementos que satisfazem a condição
const aprovados = alunos.filter(a => a.aprovado);
// → [{Ana}, {Carla}, {Diego}]

const notaAlta = alunos.filter(a => a.nota >= 8);
// → [{Ana}, {Carla}]

// reduce — acumula todos os elementos em um único valor
const somaNotas = alunos.reduce((soma, a) => soma + a.nota, 0);
// → 29.5

const mediaNotas = somaNotas / alunos.length;
// → 7.375

// Reduce para construir objeto
const porNome = alunos.reduce((acc, a) => {
  acc[a.nome] = a.nota;
  return acc;
}, {});
// → { Ana: 9.5, Bruno: 5.0, Carla: 8.2, Diego: 6.8 }

// find — retorna o PRIMEIRO elemento que satisfaz a condição (ou undefined)
const primeiroAprovado = alunos.find(a => a.aprovado);
// → { nome: 'Ana', nota: 9.5, aprovado: true }

const alunoInexistente = alunos.find(a => a.nome === 'Eva');
// → undefined

// findIndex — como find, mas retorna o índice
const idxBruno = alunos.findIndex(a => a.nome === 'Bruno'); // → 1

// some — verdadeiro se PELO MENOS UM elemento satisfaz a condição
const algumReprovado = alunos.some(a => !a.aprovado); // → true

// every — verdadeiro se TODOS os elementos satisfazem a condição
const todosAprovados = alunos.every(a => a.aprovado);  // → false

// flat e flatMap
const matriz = [[1, 2], [3, 4], [5]];
matriz.flat()    // → [1, 2, 3, 4, 5]

const frasesComPalavras = ['olá mundo', 'bom dia'];
frasesComPalavras.flatMap(f => f.split(' '));
// → ['olá', 'mundo', 'bom', 'dia']

// Encadeamento de métodos — muito comum na prática
const mediasAprovados = alunos
  .filter(a => a.aprovado)
  .map(a => a.nota)
  .reduce((soma, nota, _, arr) => soma + nota / arr.length, 0);
// média das notas apenas dos aprovados
```

### 13.4.3 — Objetos: criação, acesso e manipulação

```javascript
// Criação de objeto literal
const usuario = {
  nome: 'Maria Silva',
  idade: 22,
  email: 'maria@exemplo.com',
  ativo: true,
  endereco: {              // objeto aninhado
    cidade: 'Maceió',
    estado: 'AL'
  },
  hobbies: ['leitura', 'programação'], // array como propriedade
  saudacao() {             // método
    return `Olá, sou ${this.nome}`;
  }
};

// Acesso a propriedades
usuario.nome              // → 'Maria Silva' (notação de ponto)
usuario['email']          // → 'maria@exemplo.com' (notação de colchetes)
usuario.endereco.cidade   // → 'Maceió'
usuario.hobbies[0]        // → 'leitura'
usuario.saudacao()        // → 'Olá, sou Maria Silva'

// Propriedade dinâmica (nome da propriedade em variável)
const campo = 'nome';
usuario[campo]            // → 'Maria Silva'

// Adição e modificação de propriedades
usuario.curso = 'Sistemas de Informação'; // adiciona
usuario.idade = 23;                       // modifica

// Remoção
delete usuario.ativo;

// Verificação de existência
'nome' in usuario          // → true
usuario.hasOwnProperty('curso') // → true

// Shorthand property — quando variável e chave têm o mesmo nome
const nome = 'João';
const idade = 25;
const pessoa = { nome, idade }; // equivale a { nome: nome, idade: idade }

// Computed property names — nome de chave dinâmico
const chave = 'cor';
const objeto = { [chave]: 'azul' }; // → { cor: 'azul' }
```

### 13.4.4 — Desestruturação de arrays e objetos

A desestruturação (*destructuring*) permite extrair valores de arrays e objetos de forma concisa:

```javascript
// Desestruturação de array
const coordenadas = [10, 20, 30];
const [x, y, z] = coordenadas;
// x → 10, y → 20, z → 30

// Ignorando elementos
const [primeiro, , terceiro] = coordenadas;
// primeiro → 10, terceiro → 30

// Com valor padrão
const [a = 0, b = 0, c = 0, d = 0] = [1, 2];
// a→1, b→2, c→0, d→0

// Troca de variáveis sem temporária
let p = 1, q = 2;
[p, q] = [q, p]; // p→2, q→1

// Desestruturação de objeto
const usuario = { nome: 'Ana', idade: 22, cidade: 'Maceió' };
const { nome, idade } = usuario;
// nome → 'Ana', idade → 22

// Com renomeação
const { nome: nomeUsuario, cidade: localidade } = usuario;
// nomeUsuario → 'Ana', localidade → 'Maceió'

// Com valor padrão
const { nome: n, curso = 'Não informado' } = usuario;
// n → 'Ana', curso → 'Não informado'

// Desestruturação aninhada
const { endereco: { cidade, estado } } = {
  endereco: { cidade: 'Maceió', estado: 'AL' }
};

// Desestruturação em parâmetros de função
function exibirUsuario({ nome, idade, curso = 'SI' }) {
  return `${nome}, ${idade} anos — ${curso}`;
}

exibirUsuario({ nome: 'Ana', idade: 22 });
// → "Ana, 22 anos — SI"
```

### 13.4.5 — Spread operator e rest em objetos

```javascript
// Spread em arrays — expande elementos
const a = [1, 2, 3];
const b = [4, 5, 6];
const combinado = [...a, ...b]; // → [1, 2, 3, 4, 5, 6]
const copia = [...a];           // cópia superficial

// Spread em objetos — copia e/ou mescla propriedades
const base = { tema: 'claro', idioma: 'pt-BR' };
const extensao = { idioma: 'en-US', fonte: 'Inter' };

const configuracao = { ...base, ...extensao };
// → { tema: 'claro', idioma: 'en-US', fonte: 'Inter' }
// 'idioma' de extensao sobrescreve o de base

// Cópia com modificação (padrão imutável — muito usado com estado)
const usuarioAtualizado = { ...usuario, idade: 23 };
// cria novo objeto com todos os campos, mas idade = 23

// Rest em objetos — captura o restante
const { nome, ...restante } = usuario;
// nome → 'Ana'
// restante → { idade: 22, cidade: 'Maceió' }
```

### 13.4.6 — Métodos estáticos: `Object.keys()`, `Object.values()`, `Object.entries()`

```javascript
const produto = {
  nome: 'Notebook',
  preco: 3500,
  estoque: 12
};

// Object.keys — array de chaves
Object.keys(produto)    // → ['nome', 'preco', 'estoque']

// Object.values — array de valores
Object.values(produto)  // → ['Notebook', 3500, 12]

// Object.entries — array de pares [chave, valor]
Object.entries(produto)
// → [['nome','Notebook'], ['preco',3500], ['estoque',12]]

// Iterando sobre um objeto com for...of + entries
for (const [chave, valor] of Object.entries(produto)) {
  console.log(`${chave}: ${valor}`);
}

// Object.assign — copia propriedades
const destino = {};
Object.assign(destino, produto, { desconto: 10 });
// equivale a spread: { ...produto, desconto: 10 }

// Object.freeze — torna objeto imutável
const CONFIG = Object.freeze({ API_URL: 'https://api.exemplo.com' });
// CONFIG.API_URL = 'outra'; — silenciosamente ignorado (ou erro em strict mode)

// Object.fromEntries — o inverso de entries
const mapa = [['a', 1], ['b', 2], ['c', 3]];
Object.fromEntries(mapa) // → { a: 1, b: 2, c: 3 }

// Transformando objeto via entries + map
const precosComDesconto = Object.fromEntries(
  Object.entries(produto)
    .filter(([k]) => k === 'preco')
    .map(([k, v]) => [k, v * 0.9])
);
```

---

## 13.5 — Condicionais e loops

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 13.5.1 — `if`, `else if`, `else` e operador ternário

```javascript
const nota = 7.5;

// if/else if/else
if (nota >= 9) {
  console.log('Excelente');
} else if (nota >= 7) {
  console.log('Aprovado');
} else if (nota >= 5) {
  console.log('Recuperação');
} else {
  console.log('Reprovado');
}

// Operador ternário — para expressões simples
const resultado = nota >= 7 ? 'Aprovado' : 'Reprovado';

// Ternário aninhado (use com moderação — prejudica legibilidade)
const conceito = nota >= 9 ? 'A' : nota >= 7 ? 'B' : nota >= 5 ? 'C' : 'D';

// Condicional com truthy/falsy
const nome = '';
const exibicao = nome || 'Anônimo'; // → 'Anônimo' (nome é falsy)

// Guardas (early return) — evitam aninhamento excessivo
function processar(valor) {
  if (!valor) return null;          // guarda: retorna cedo se inválido
  if (valor < 0) return 0;          // guarda: retorna cedo se negativo
  return valor * 2;                 // lógica principal sem aninhamento
}
```

### 13.5.2 — `switch`

```javascript
const diaSemana = 3;

switch (diaSemana) {
  case 1:
    console.log('Segunda-feira');
    break;
  case 2:
    console.log('Terça-feira');
    break;
  case 3:
  case 4:
    console.log('Quarta ou Quinta-feira'); // fallthrough intencional
    break;
  case 5:
    console.log('Sexta-feira');
    break;
  default:
    console.log('Fim de semana');
}

// switch com strings
const comando = 'iniciar';

switch (comando) {
  case 'iniciar':
    iniciar();
    break;
  case 'parar':
    parar();
    break;
  default:
    console.warn(`Comando desconhecido: ${comando}`);
}
```

### 13.5.3 — `for`, `while` e `do...while`

```javascript
// for — quando o número de iterações é conhecido
for (let i = 0; i < 5; i++) {
  console.log(i); // → 0, 1, 2, 3, 4
}

// Iterando sobre array com índice
const frutas = ['maçã', 'banana', 'laranja'];
for (let i = 0; i < frutas.length; i++) {
  console.log(`${i}: ${frutas[i]}`);
}

// while — quando a condição de parada não é conhecida previamente
let tentativas = 0;
let acertou = false;

while (!acertou && tentativas < 3) {
  tentativas++;
  const resposta = obterResposta();
  if (resposta === 'correta') acertou = true;
}

// do...while — executa pelo menos uma vez antes de verificar a condição
let entrada;
do {
  entrada = solicitarEntrada();
} while (!entradaValida(entrada));
```

### 13.5.4 — `for...of` e `for...in`

```javascript
// for...of — itera sobre valores de iteráveis (arrays, strings, Maps, Sets)
const numeros = [10, 20, 30];
for (const numero of numeros) {
  console.log(numero); // → 10, 20, 30
}

// Com string
for (const letra of 'IFAL') {
  console.log(letra); // → I, F, A, L
}

// Com desestruturação e entries
for (const [indice, valor] of numeros.entries()) {
  console.log(`${indice}: ${valor}`);
}

// for...in — itera sobre chaves enumeráveis de objetos
// (use com cautela em arrays)
const configuracao = { tema: 'escuro', idioma: 'pt', fonte: 16 };

for (const chave in configuracao) {
  console.log(`${chave}: ${configuracao[chave]}`);
}
// → tema: escuro | idioma: pt | fonte: 16

// for...of vs for...in em arrays
const arr = ['a', 'b', 'c'];
for (const v of arr) console.log(v);   // → a, b, c  (valores)
for (const k in arr) console.log(k);   // → 0, 1, 2  (índices como strings)
// Prefira for...of para arrays
```

### 13.5.5 — `break` e `continue`

```javascript
// break — interrompe o loop imediatamente
const numeros = [1, 5, 3, 8, 2, 9, 4];
let primeiraMaiorQue6;

for (const n of numeros) {
  if (n > 6) {
    primeiraMaiorQue6 = n;
    break; // para o loop ao encontrar o primeiro
  }
}
// → primeiraMaiorQue6 = 8

// continue — pula para a próxima iteração
const resultado = [];
for (let i = 0; i <= 10; i++) {
  if (i % 2 !== 0) continue; // pula ímpares
  resultado.push(i);
}
// → [0, 2, 4, 6, 8, 10]

// Labels — para break/continue em loops aninhados
externo: for (let i = 0; i < 3; i++) {
  for (let j = 0; j < 3; j++) {
    if (j === 1) continue externo; // continua o loop externo
    console.log(i, j);
  }
}
```

---

## 13.6 — Assincronia: introdução

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 13.6.1 — Por que JavaScript é assíncrono

Como apresentado na seção 13.1.3, o JavaScript é *single-threaded* — executa em uma única thread. Operações que demoram para completar — requisições de rede, leitura de arquivos, timers — não podem simplesmente bloquear essa thread aguardando o resultado, pois isso congelaria a interface do usuário.

A solução é o modelo **assíncrono**: em vez de esperar, o JavaScript inicia a operação, registra o que deve ser feito quando ela completar (um *callback*), e continua executando o restante do código. Quando a operação completa, o callback é chamado.

```javascript
// Exemplo de assincronia: setTimeout
console.log('1 — antes');

setTimeout(() => {
  console.log('3 — dentro do timeout (após 1 segundo)');
}, 1000);

console.log('2 — depois');

// Saída:
// 1 — antes
// 2 — depois
// 3 — dentro do timeout (após 1 segundo)
```

O código após o `setTimeout` executa imediatamente, sem esperar o timer. Quando o segundo passa, o callback é colocado na fila e executado após a call stack esvaziar.

### 13.6.2 — Callbacks: o padrão original

O **callback** é o padrão mais básico de assincronia: uma função passada como argumento para ser chamada quando uma operação assíncrona completa:

```javascript
// Callback simples
function buscarDados(id, callback) {
  setTimeout(() => { // simula requisição de rede
    const dados = { id, nome: 'Produto ' + id, preco: 99.90 };
    callback(null, dados); // convenção: (erro, resultado)
  }, 500);
}

buscarDados(1, (erro, produto) => {
  if (erro) {
    console.error('Erro:', erro);
    return;
  }
  console.log(produto);
});

// Callback hell — problema clássico com callbacks aninhados
buscarUsuario(id, (erro, usuario) => {
  if (erro) return tratarErro(erro);
  buscarPedidos(usuario.id, (erro, pedidos) => {
    if (erro) return tratarErro(erro);
    buscarProdutos(pedidos[0].id, (erro, produto) => {
      if (erro) return tratarErro(erro);
      // aninhamento torna o código ilegível e difícil de manter
    });
  });
});
```

O "callback hell" — aninhamento profundo de callbacks — foi o principal motivador para a criação das Promises.

### 13.6.3 — Promises: conceito, estados e encadeamento

Uma **Promise** representa o resultado eventual de uma operação assíncrona. Em vez de passar um callback, a função assíncrona retorna uma Promise que pode estar em um de três estados:

- **Pending:** operação em andamento
- **Fulfilled:** operação completou com sucesso (tem um valor)
- **Rejected:** operação falhou (tem um motivo de erro)

```javascript
// Criando uma Promise
function buscarDados(id) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id > 0) {
        resolve({ id, nome: 'Produto ' + id }); // sucesso
      } else {
        reject(new Error('ID inválido')); // falha
      }
    }, 500);
  });
}

// Consumindo com .then() e .catch()
buscarDados(1)
  .then(produto => {
    console.log('Sucesso:', produto);
    return produto.nome; // retorno é passado para o próximo .then()
  })
  .then(nome => {
    console.log('Nome:', nome);
  })
  .catch(erro => {
    console.error('Erro:', erro.message);
  })
  .finally(() => {
    console.log('Operação concluída'); // sempre executado
  });

// Promise.all — aguarda múltiplas promises em paralelo
Promise.all([
  buscarDados(1),
  buscarDados(2),
  buscarDados(3),
]).then(([p1, p2, p3]) => {
  console.log(p1, p2, p3);
}).catch(erro => {
  // falha se QUALQUER uma rejeitar
  console.error(erro);
});

// Promise.allSettled — aguarda todas, independente de sucesso ou falha
Promise.allSettled([buscarDados(1), buscarDados(-1)])
  .then(resultados => {
    resultados.forEach(r => {
      if (r.status === 'fulfilled') console.log('OK:', r.value);
      else console.log('Erro:', r.reason.message);
    });
  });
```

### 13.6.4 — `async`/`await`: sintaxe síncrona para código assíncrono

`async`/`await` é uma sintaxe introduzida no ES2017 que permite escrever código assíncrono com aparência síncrona — tornando-o mais legível e próximo do fluxo de pensamento linear:

```javascript
// async: declara que a função retorna uma Promise
// await: pausa a execução da função até a Promise resolver

async function carregarPerfil(userId) {
  // await pausa aqui até buscarUsuario resolver
  const usuario = await buscarUsuario(userId);
  const pedidos = await buscarPedidos(usuario.id);
  const ultimoPedido = await buscarPedido(pedidos[0].id);

  return {
    usuario,
    totalPedidos: pedidos.length,
    ultimoPedido
  };
}

// Equivale ao encadeamento de .then() mas muito mais legível
// Compare com o callback hell da seção 13.6.2

// Consumindo uma função async
carregarPerfil(1)
  .then(perfil => console.log(perfil))
  .catch(erro => console.error(erro));

// await também funciona no nível do módulo (top-level await)
```

### 13.6.5 — Tratamento de erros com `try/catch`

```javascript
async function carregarDados(id) {
  try {
    const usuario = await buscarUsuario(id);
    const pedidos = await buscarPedidos(usuario.id);
    return { usuario, pedidos };

  } catch (erro) {
    // captura qualquer erro nas operações await acima
    console.error('Falha ao carregar dados:', erro.message);
    return null; // ou relançar: throw erro;

  } finally {
    // executado sempre, independente de sucesso ou erro
    esconderIndicadorDeCarregamento();
  }
}

// Tratamento de erros específicos
async function salvar(dados) {
  try {
    const resposta = await fetch('/api/salvar', {
      method: 'POST',
      body: JSON.stringify(dados)
    });

    if (!resposta.ok) {
      // fetch não rejeita em erros HTTP — é necessário verificar
      throw new Error(`HTTP ${resposta.status}: ${resposta.statusText}`);
    }

    return await resposta.json();

  } catch (erro) {
    if (erro instanceof TypeError) {
      // TypeError do fetch: sem conexão, URL inválida
      console.error('Erro de rede:', erro.message);
    } else {
      console.error('Erro ao salvar:', erro.message);
    }
    throw erro; // relança para o chamador decidir
  }
}
```

**Referências:**
- [MDN — JavaScript](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript)
- [MDN — JavaScript Guide](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Guide)
- [ECMAScript — Especificação oficial](https://tc39.es/ecma262/)
- [javascript.info — O Tutorial Moderno de JavaScript](https://javascript.info)
- [You Don't Know JS (livro gratuito)](https://github.com/getify/You-Dont-Know-JS)

---

#### **Atividades — Capítulo 13**

<div class="quiz" data-answer="b">
  <p><strong>1.</strong> Por que é recomendado usar <code>===</code> em vez de <code>==</code> para comparações em JavaScript?</p>
  <button data-option="a">Porque <code>===</code> é mais rápido de executar que <code>==</code>.</button>
  <button data-option="b">Porque <code>===</code> verifica tipo e valor sem coerção de tipos, produzindo resultados previsíveis — enquanto <code>==</code> pode converter tipos automaticamente, gerando comparações inesperadas como <code>'5' == 5 → true</code>.</button>
  <button data-option="c">Porque <code>==</code> não funciona com objetos e arrays.</button>
  <button data-option="d">Não há diferença funcional — é apenas uma convenção de estilo.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="c">
  <p><strong>2.</strong> Qual é a diferença entre <code>map()</code> e <code>filter()</code>?</p>
  <button data-option="a"><code>map()</code> funciona apenas com números; <code>filter()</code> funciona com qualquer tipo.</button>
  <button data-option="b"><code>filter()</code> transforma cada elemento; <code>map()</code> seleciona elementos com base em uma condição.</button>
  <button data-option="c"><code>map()</code> transforma cada elemento retornando um novo array de mesmo tamanho; <code>filter()</code> seleciona elementos que satisfazem uma condição, retornando um array potencialmente menor.</button>
  <button data-option="d">São sinônimos — ambos retornam um novo array com os mesmos elementos.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> O que é uma closure em JavaScript?</p>
  <button data-option="a">Uma função que não aceita parâmetros.</button>
  <button data-option="b">Um bloco de código que captura erros com try/catch.</button>
  <button data-option="c">Uma função que é executada imediatamente após ser declarada (IIFE).</button>
  <button data-option="d">A capacidade de uma função de acessar e "lembrar" variáveis do escopo onde foi criada, mesmo após esse escopo ter encerrado sua execução.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="a">
  <p><strong>4.</strong> Qual é a vantagem de <code>async/await</code> em relação ao encadeamento de <code>.then()</code>?</p>
  <button data-option="a">Permite escrever código assíncrono com aparência síncrona e fluxo linear, tornando-o mais legível e mais próximo do raciocínio sequencial — especialmente quando há múltiplas operações assíncronas dependentes.</button>
  <button data-option="b"><code>async/await</code> executa o código mais rapidamente que Promises com <code>.then()</code>.</button>
  <button data-option="c"><code>async/await</code> elimina a necessidade de tratamento de erros.</button>
  <button data-option="d"><code>async/await</code> permite executar múltiplas Promises em paralelo, o que <code>.then()</code> não suporta.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom:** Implementar um módulo JavaScript que: (1) processe um array de alunos usando `filter`, `map` e `reduce` para calcular médias e classificar aprovados; (2) implemente uma função com closure para criar um placar de pontuação; (3) use `async/await` com `setTimeout` para simular uma operação assíncrona de busca de dados. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 12 — Framework CSS: Tailwind CSS](12-tailwind.md)
[:material-arrow-right: Ir ao Capítulo 14 — Manipulação do DOM](14-dom.md)
