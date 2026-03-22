# Capítulo 15 — Eventos e Formulários com JavaScript

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

---

## 15.1 — Revisão aprofundada do sistema de eventos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

O sistema de eventos do navegador é mais rico do que uma primeira leitura sugere. O Capítulo 14 introduziu `addEventListener` e os eventos mais comuns. Esta seção aprofunda o modelo de propagação de eventos — um mecanismo que, quando bem compreendido, permite construir interfaces interativas mais sofisticadas com menos código.

### 15.1.1 — O ciclo de vida de um evento: captura, alvo e borbulhamento

Quando um evento ocorre em um elemento, ele não surge diretamente naquele elemento — ele percorre a árvore DOM em três fases distintas:

```
Fase 1 — CAPTURA (de cima para baixo):
document → html → body → section → div → botão

Fase 2 — ALVO:
O evento chega ao elemento que o originou (botão)

Fase 3 — BORBULHAMENTO (de baixo para cima):
botão → div → section → body → html → document
```

> **Imagem sugerida:** diagrama vertical da árvore DOM mostrando as três fases com setas — seta descendo para captura (azul), círculo no alvo (laranja) e seta subindo para borbulhamento (verde).
>
> *(imagem será adicionada posteriormente)*

Por padrão, `addEventListener` registra listeners na **fase de borbulhamento**. Para registrar na fase de captura, passe `{ capture: true }` como terceiro argumento:

```javascript
const pai = document.querySelector('.container');
const filho = document.querySelector('.botao');

// Listener na fase de borbulhamento (padrão)
pai.addEventListener('click', () => {
  console.log('PAI — borbulhamento');
});

// Listener na fase de captura
pai.addEventListener('click', () => {
  console.log('PAI — captura');
}, { capture: true });

filho.addEventListener('click', () => {
  console.log('FILHO — alvo');
});

// Ao clicar no filho, a ordem de saída é:
// PAI — captura    (fase 1: desce)
// FILHO — alvo     (fase 2: alvo)
// PAI — borbulhamento (fase 3: sobe)
```

**Caso de uso real para captura:** interceptar eventos antes que cheguem ao alvo — por exemplo, um sistema de analytics que registra todos os cliques em uma página antes que os handlers individuais os processem.

### 15.1.2 — `stopPropagation` vs `stopImmediatePropagation`

```javascript
const container = document.querySelector('.container');
const botao = document.querySelector('.botao');

container.addEventListener('click', () => {
  console.log('Container recebeu o clique');
});

// stopPropagation: impede que o evento continue subindo
botao.addEventListener('click', (e) => {
  e.stopPropagation();
  console.log('Botão clicado — evento NÃO chega ao container');
});

// stopImmediatePropagation: além de parar a propagação,
// impede outros listeners NO MESMO ELEMENTO de serem chamados
botao.addEventListener('click', (e) => {
  e.stopImmediatePropagation();
  console.log('Este listener executa');
});

botao.addEventListener('click', () => {
  console.log('Este listener NÃO executa — foi bloqueado');
});
```

> **Cuidado com `stopPropagation`:** seu uso indiscriminado pode quebrar funcionalidades que dependem do borbulhamento — como delegação de eventos e bibliotecas de analytics. Use apenas quando houver necessidade explícita de isolar um evento.

### 15.1.3 — `preventDefault`: quando e por que usar

`preventDefault` cancela o **comportamento padrão** do navegador para aquele evento — sem interromper sua propagação:

```javascript
// Cancelar envio de formulário para processamento via JS
document.querySelector('form').addEventListener('submit', (e) => {
  e.preventDefault(); // sem isso, a página recarregaria
  validarEEnviar();
});

// Cancelar navegação de link
document.querySelector('a.modal-trigger').addEventListener('click', (e) => {
  e.preventDefault(); // sem isso, o navegador seguiria o href
  abrirModal();
});

// Cancelar menu de contexto (clique direito)
document.querySelector('.area-especial').addEventListener('contextmenu', (e) => {
  e.preventDefault();
  exibirMenuCustomizado(e.clientX, e.clientY);
});

// Cancelar drag padrão em imagens
document.querySelector('img').addEventListener('dragstart', (e) => {
  e.preventDefault();
});

// Verificar se pode ser cancelado
document.addEventListener('scroll', (e) => {
  console.log(e.cancelable); // → false — scroll não pode ser cancelado assim
});
```

### 15.1.4 — Eventos customizados com `CustomEvent`

JavaScript permite criar e despachar eventos personalizados — uma forma de comunicação entre componentes sem dependência direta:

```javascript
// Criar e despachar um evento customizado
const evento = new CustomEvent('tarefa-concluida', {
  detail: {          // dados anexados ao evento
    id: 42,
    titulo: 'Estudar DOM',
    completadoEm: new Date()
  },
  bubbles: true,     // borbulha pela árvore DOM
  cancelable: true   // pode ser cancelado com preventDefault
});

document.querySelector('#lista').dispatchEvent(evento);

// Ouvir o evento customizado em qualquer ancestral
document.addEventListener('tarefa-concluida', (e) => {
  console.log('Tarefa concluída:', e.detail.titulo);
  atualizarContador();
  salvarProgresso(e.detail);
});

// Exemplo prático: componente de notificação desacoplado
function notificar(mensagem, tipo = 'info') {
  document.dispatchEvent(new CustomEvent('notificacao', {
    detail: { mensagem, tipo },
    bubbles: false
  }));
}

document.addEventListener('notificacao', (e) => {
  exibirToast(e.detail.mensagem, e.detail.tipo);
});

// Qualquer parte do código pode chamar:
notificar('Salvo com sucesso!', 'sucesso');
notificar('Erro ao conectar.', 'erro');
```

### 15.1.5 — Exercício prático: sistema de abas sem biblioteca

Um sistema de abas é um dos componentes mais comuns de interfaces web. Implementá-lo do zero consolida: seleção de elementos, manipulação de classes, eventos e acessibilidade com ARIA.

```html
<!-- HTML do componente de abas -->
<div class="abas" id="abas-curso">

  <!-- Lista de abas: role="tablist" para acessibilidade -->
  <div class="abas__lista" role="tablist" aria-label="Seções do curso">
    <button
      class="abas__botao abas__botao--ativo"
      role="tab"
      id="aba-ementa"
      aria-controls="painel-ementa"
      aria-selected="true"
      type="button"
    >Ementa</button>

    <button
      class="abas__botao"
      role="tab"
      id="aba-objetivos"
      aria-controls="painel-objetivos"
      aria-selected="false"
      tabindex="-1"
      type="button"
    >Objetivos</button>

    <button
      class="abas__botao"
      role="tab"
      id="aba-avaliacao"
      aria-controls="painel-avaliacao"
      aria-selected="false"
      tabindex="-1"
      type="button"
    >Avaliação</button>
  </div>

  <!-- Painéis de conteúdo -->
  <div
    class="abas__painel"
    role="tabpanel"
    id="painel-ementa"
    aria-labelledby="aba-ementa"
  >
    <h3>Ementa</h3>
    <p>HTML semântico, CSS moderno, JavaScript, APIs...</p>
  </div>

  <div
    class="abas__painel abas__painel--oculto"
    role="tabpanel"
    id="painel-objetivos"
    aria-labelledby="aba-objetivos"
    hidden
  >
    <h3>Objetivos</h3>
    <p>Desenvolver interfaces web modernas e responsivas...</p>
  </div>

  <div
    class="abas__painel abas__painel--oculto"
    role="tabpanel"
    id="painel-avaliacao"
    aria-labelledby="aba-avaliacao"
    hidden
  >
    <h3>Avaliação</h3>
    <p>Atividades práticas, mini-projetos e projeto final...</p>
  </div>

</div>
```

```javascript
// Sistema de abas acessível — navegação por teclado incluída
function inicializarAbas(containerSelector) {
  const container = document.querySelector(containerSelector);
  if (!container) return;

  const botoes = container.querySelectorAll('[role="tab"]');
  const paineis = container.querySelectorAll('[role="tabpanel"]');

  function ativarAba(botaoAlvo) {
    // Desativar todas as abas
    botoes.forEach(btn => {
      btn.setAttribute('aria-selected', 'false');
      btn.setAttribute('tabindex', '-1');
      btn.classList.remove('abas__botao--ativo');
    });

    // Ocultar todos os painéis
    paineis.forEach(painel => {
      painel.hidden = true;
    });

    // Ativar a aba alvo
    botaoAlvo.setAttribute('aria-selected', 'true');
    botaoAlvo.removeAttribute('tabindex');
    botaoAlvo.classList.add('abas__botao--ativo');
    botaoAlvo.focus();

    // Exibir painel correspondente
    const painelId = botaoAlvo.getAttribute('aria-controls');
    const painel = document.getElementById(painelId);
    if (painel) painel.hidden = false;

    // Disparar evento customizado
    container.dispatchEvent(new CustomEvent('aba-mudou', {
      detail: { abaId: botaoAlvo.id, painelId },
      bubbles: true
    }));
  }

  // Clique nas abas
  botoes.forEach(botao => {
    botao.addEventListener('click', () => ativarAba(botao));
  });

  // Navegação por teclado (padrão WAI-ARIA para tablist)
  container.addEventListener('keydown', (e) => {
    const abaAtiva = container.querySelector('[role="tab"][aria-selected="true"]');
    const lista = [...botoes];
    const indiceAtual = lista.indexOf(abaAtiva);

    let novoIndice;

    switch (e.key) {
      case 'ArrowRight':
      case 'ArrowDown':
        e.preventDefault();
        novoIndice = (indiceAtual + 1) % lista.length;
        break;
      case 'ArrowLeft':
      case 'ArrowUp':
        e.preventDefault();
        novoIndice = (indiceAtual - 1 + lista.length) % lista.length;
        break;
      case 'Home':
        e.preventDefault();
        novoIndice = 0;
        break;
      case 'End':
        e.preventDefault();
        novoIndice = lista.length - 1;
        break;
      default:
        return;
    }

    ativarAba(lista[novoIndice]);
  });
}

// Inicializar todas as instâncias de abas na página
inicializarAbas('#abas-curso');
```

---

## 15.2 — Eventos de teclado em profundidade

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 15.2.1 — `keydown`, `keyup` e `key` vs `code`

```javascript
document.addEventListener('keydown', (e) => {
  // e.key: o valor da tecla conforme o layout do teclado
  // Muda com Shift, CapsLock e layout de idioma
  console.log(e.key);
  // → 'a', 'A' (com Shift), 'Enter', 'ArrowLeft', 'Escape', ' '

  // e.code: o código físico da tecla — independente do layout
  // Não muda com Shift ou layout de idioma
  console.log(e.code);
  // → 'KeyA', 'Enter', 'ArrowLeft', 'Escape', 'Space'
});

// Quando usar key vs code:
// - key: para capturar o CARACTERE digitado (busca, formulário)
// - code: para capturar a POSIÇÃO física da tecla (atalhos, jogos)

// Exemplo: atalho que funciona igual no teclado QWERTY e AZERTY
document.addEventListener('keydown', (e) => {
  if (e.ctrlKey && e.code === 'KeyS') { // 'S' físico, independente do layout
    e.preventDefault();
    salvar();
  }
});

// Diferença prática:
// Teclado AZERTY: a tecla na posição de 'Q' no QWERTY
//   → e.key = 'a' (caractere do layout AZERTY)
//   → e.code = 'KeyQ' (posição física)
```

### 15.2.2 — Atalhos de teclado: detectando combinações

```javascript
// Mapa de atalhos — fácil de manter e estender
const atalhos = {
  'ctrl+s':        () => salvar(),
  'ctrl+z':        () => desfazer(),
  'ctrl+shift+z':  () => refazer(),
  'ctrl+/':        () => toggleComentario(),
  'escape':        () => fecharModal(),
  'f1':            () => abrirAjuda(),
  'ctrl+k':        () => focarBusca(),
};

function obterChaveAtalho(e) {
  const partes = [];
  if (e.ctrlKey  || e.metaKey) partes.push('ctrl');
  if (e.altKey)                partes.push('alt');
  if (e.shiftKey)              partes.push('shift');

  const tecla = e.key.toLowerCase();
  // Não duplica modificadores
  if (!['control','alt','shift','meta'].includes(tecla)) {
    partes.push(tecla);
  }

  return partes.join('+');
}

document.addEventListener('keydown', (e) => {
  const chave = obterChaveAtalho(e);
  const handler = atalhos[chave];

  if (handler) {
    // Não ativar atalhos quando usuário está digitando em campo
    const emCampo = ['INPUT','TEXTAREA','SELECT'].includes(
      document.activeElement.tagName
    );

    if (!emCampo || chave === 'escape') {
      e.preventDefault();
      handler();
    }
  }
});
```

### 15.2.3 — Navegação por teclado customizada

```javascript
// Navegação por setas em uma lista de itens
function tornarListaNavegavel(listaSelector) {
  const lista = document.querySelector(listaSelector);
  const itens = () => [...lista.querySelectorAll('[data-navegavel]')];

  lista.addEventListener('keydown', (e) => {
    const todos = itens();
    const ativo = document.activeElement;
    const indice = todos.indexOf(ativo);
    if (indice === -1) return;

    let novoIndice;

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        novoIndice = Math.min(indice + 1, todos.length - 1);
        break;
      case 'ArrowUp':
        e.preventDefault();
        novoIndice = Math.max(indice - 1, 0);
        break;
      case 'Home':
        e.preventDefault();
        novoIndice = 0;
        break;
      case 'End':
        e.preventDefault();
        novoIndice = todos.length - 1;
        break;
      default:
        return;
    }

    todos[novoIndice].focus();
  });

  // Garantir que apenas o item focado está no tab order
  lista.addEventListener('focusin', (e) => {
    const todos = itens();
    if (!todos.includes(e.target)) return;
    todos.forEach(item => item.setAttribute('tabindex', '-1'));
    e.target.setAttribute('tabindex', '0');
  });
}
```

### 15.2.4 — Exercício prático: campo de busca com atalho e navegação por setas

```html
<div class="busca-container">
  <div class="busca-campo">
    <input
      type="search"
      id="campo-busca"
      placeholder="Buscar... (Ctrl+K)"
      role="combobox"
      aria-expanded="false"
      aria-controls="lista-sugestoes"
      aria-autocomplete="list"
      autocomplete="off"
    />
  </div>

  <ul
    class="busca-sugestoes oculto"
    id="lista-sugestoes"
    role="listbox"
    aria-label="Sugestões de busca"
  ></ul>
</div>
```

```javascript
const DADOS = [
  'HTML semântico', 'CSS Flexbox', 'CSS Grid', 'JavaScript ES6',
  'Manipulação do DOM', 'Eventos', 'Fetch API', 'Promises',
  'async/await', 'Tailwind CSS', 'Design System', 'Acessibilidade',
  'Responsividade', 'Media Queries', 'Canvas API', 'LocalStorage'
];

const input = document.querySelector('#campo-busca');
const lista = document.querySelector('#lista-sugestoes');

let sugestoesVisiveis = [];
let indiceFocado = -1;

// Atalho global: Ctrl+K foca o campo de busca
document.addEventListener('keydown', (e) => {
  if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
    e.preventDefault();
    input.focus();
    input.select();
  }
});

// Busca em tempo real
input.addEventListener('input', () => {
  const termo = input.value.trim().toLowerCase();
  indiceFocado = -1;

  if (!termo) {
    fecharSugestoes();
    return;
  }

  sugestoesVisiveis = DADOS.filter(item =>
    item.toLowerCase().includes(termo)
  );

  renderizarSugestoes(termo);
});

function renderizarSugestoes(termo) {
  lista.innerHTML = '';

  if (!sugestoesVisiveis.length) {
    fecharSugestoes();
    return;
  }

  const fragment = document.createDocumentFragment();

  sugestoesVisiveis.forEach((sugestao, idx) => {
    const li = document.createElement('li');
    li.role = 'option';
    li.setAttribute('tabindex', '-1');
    li.dataset.indice = idx;

    // Destaca o termo buscado no texto
    const regex = new RegExp(`(${escapeRegex(termo)})`, 'gi');
    li.innerHTML = sugestao.replace(regex, '<mark>$1</mark>');

    li.addEventListener('click', () => selecionarSugestao(sugestao));
    fragment.appendChild(li);
  });

  lista.appendChild(fragment);
  lista.classList.remove('oculto');
  input.setAttribute('aria-expanded', 'true');
}

// Navegação por teclado nas sugestões
input.addEventListener('keydown', (e) => {
  const itens = lista.querySelectorAll('li');
  if (!itens.length) return;

  switch (e.key) {
    case 'ArrowDown':
      e.preventDefault();
      indiceFocado = Math.min(indiceFocado + 1, itens.length - 1);
      atualizarFoco(itens);
      break;

    case 'ArrowUp':
      e.preventDefault();
      if (indiceFocado <= 0) {
        indiceFocado = -1;
        input.focus();
      } else {
        indiceFocado--;
        atualizarFoco(itens);
      }
      break;

    case 'Enter':
      if (indiceFocado >= 0) {
        e.preventDefault();
        selecionarSugestao(sugestoesVisiveis[indiceFocado]);
      }
      break;

    case 'Escape':
      fecharSugestoes();
      input.focus();
      break;
  }
});

function atualizarFoco(itens) {
  itens.forEach((item, i) => {
    const ativo = i === indiceFocado;
    item.classList.toggle('sugestao--ativa', ativo);
    item.setAttribute('aria-selected', ativo);
    if (ativo) item.scrollIntoView({ block: 'nearest' });
  });
  input.setAttribute('aria-activedescendant',
    indiceFocado >= 0 ? `sugestao-${indiceFocado}` : ''
  );
}

function selecionarSugestao(valor) {
  input.value = valor;
  fecharSugestoes();
  input.focus();
  input.dispatchEvent(new CustomEvent('busca-selecionada', {
    detail: { valor }, bubbles: true
  }));
}

function fecharSugestoes() {
  lista.classList.add('oculto');
  lista.innerHTML = '';
  input.setAttribute('aria-expanded', 'false');
  sugestoesVisiveis = [];
  indiceFocado = -1;
}

// Fecha ao clicar fora
document.addEventListener('click', (e) => {
  if (!e.target.closest('.busca-container')) fecharSugestoes();
});

function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
```

---

## 15.3 — Eventos de mouse e pointer

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 15.3.1 — A família de eventos de pointer

Os **Pointer Events** unificam mouse, toque (*touch*) e caneta (*stylus*) em uma única API, eliminando a necessidade de tratar separadamente `mousedown`/`touchstart`:

```javascript
const elemento = document.querySelector('.interativo');

// Pointer Events — funcionam com mouse, toque e caneta
elemento.addEventListener('pointerdown',  handler); // botão/dedo pressionado
elemento.addEventListener('pointerup',    handler); // botão/dedo liberado
elemento.addEventListener('pointermove',  handler); // movimento
elemento.addEventListener('pointerenter', handler); // entra no elemento
elemento.addEventListener('pointerleave', handler); // sai do elemento
elemento.addEventListener('pointercancel', handler); // interação cancelada (ex: scroll iniciado)

// Propriedades específicas de pointer
elemento.addEventListener('pointerdown', (e) => {
  e.pointerId   // ID único do ponto de toque (útil para multi-touch)
  e.pointerType // → 'mouse', 'touch', 'pen'
  e.pressure    // → 0 a 1 (pressão — caneta/touch)
  e.width       // largura da área de contato
  e.height      // altura da área de contato
  e.clientX     // posição X
  e.clientY     // posição Y
  e.isPrimary   // → true para o primeiro ponto de multi-touch
});

// setPointerCapture — mantém o pointer no elemento mesmo
// quando o cursor sai dos seus limites (essencial para drag)
elemento.addEventListener('pointerdown', (e) => {
  elemento.setPointerCapture(e.pointerId);
});
```

### 15.3.2 — Drag and drop com eventos de pointer

```javascript
// Implementação de drag reutilizável
function tornarArrastavel(elemento) {
  let arrastando = false;
  let offsetX, offsetY;

  elemento.addEventListener('pointerdown', (e) => {
    if (e.button !== 0 && e.pointerType === 'mouse') return; // apenas botão esquerdo

    arrastando = true;
    elemento.setPointerCapture(e.pointerId);

    const rect = elemento.getBoundingClientRect();
    offsetX = e.clientX - rect.left;
    offsetY = e.clientY - rect.top;

    elemento.classList.add('arrastando');
    elemento.style.cursor = 'grabbing';
  });

  elemento.addEventListener('pointermove', (e) => {
    if (!arrastando) return;

    const pai = elemento.parentElement;
    const paiRect = pai.getBoundingClientRect();

    let x = e.clientX - paiRect.left - offsetX;
    let y = e.clientY - paiRect.top  - offsetY;

    // Conter dentro do pai
    x = Math.max(0, Math.min(x, paiRect.width  - elemento.offsetWidth));
    y = Math.max(0, Math.min(y, paiRect.height - elemento.offsetHeight));

    elemento.style.left = `${x}px`;
    elemento.style.top  = `${y}px`;
  });

  elemento.addEventListener('pointerup', () => {
    arrastando = false;
    elemento.classList.remove('arrastando');
    elemento.style.cursor = 'grab';
  });

  elemento.addEventListener('pointercancel', () => {
    arrastando = false;
    elemento.classList.remove('arrastando');
    elemento.style.cursor = 'grab';
  });

  // Estilo inicial
  elemento.style.position = 'absolute';
  elemento.style.cursor   = 'grab';
  elemento.style.userSelect = 'none';
  elemento.style.touchAction = 'none'; // previne scroll em touch
}
```

### 15.3.3 — Exercício prático: lista reordenável por arrastar e soltar

```html
<ul class="lista-reordenavel" id="lista-ordem" aria-label="Lista reordenável">
  <li class="item-lista" draggable="true" data-id="1">
    <span class="handle" aria-hidden="true">⠿</span>
    <span>Fundamentos de HTML</span>
  </li>
  <li class="item-lista" draggable="true" data-id="2">
    <span class="handle" aria-hidden="true">⠿</span>
    <span>CSS Moderno</span>
  </li>
  <li class="item-lista" draggable="true" data-id="3">
    <span class="handle" aria-hidden="true">⠿</span>
    <span>JavaScript Essencial</span>
  </li>
  <li class="item-lista" draggable="true" data-id="4">
    <span class="handle" aria-hidden="true">⠿</span>
    <span>Manipulação do DOM</span>
  </li>
  <li class="item-lista" draggable="true" data-id="5">
    <span class="handle" aria-hidden="true">⠿</span>
    <span>Fetch API e Projetos</span>
  </li>
</ul>
```

```javascript
function inicializarListaReordenavel(listaSelector) {
  const lista = document.querySelector(listaSelector);
  let itemArrastado = null;
  let itemOrigem = null;

  // Usando Drag and Drop API nativa (para listas de elementos HTML)
  lista.addEventListener('dragstart', (e) => {
    itemArrastado = e.target.closest('.item-lista');
    itemOrigem = itemArrastado;

    // Pequeno delay para o estilo de arrastar não afetar o ghost
    requestAnimationFrame(() => {
      itemArrastado.classList.add('arrastando');
    });

    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', itemArrastado.dataset.id);
  });

  lista.addEventListener('dragend', () => {
    if (itemArrastado) {
      itemArrastado.classList.remove('arrastando');
      itemArrastado = null;
    }
    lista.querySelectorAll('.item-lista').forEach(item => {
      item.classList.remove('sobre-item');
    });
    salvarOrdem();
  });

  lista.addEventListener('dragover', (e) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';

    const alvo = e.target.closest('.item-lista');
    if (!alvo || alvo === itemArrastado) return;

    // Determinar se inserir antes ou depois pelo meio do elemento
    const rect = alvo.getBoundingClientRect();
    const meio = rect.top + rect.height / 2;
    const antes = e.clientY < meio;

    lista.querySelectorAll('.item-lista').forEach(i =>
      i.classList.remove('sobre-item', 'inserir-antes', 'inserir-depois')
    );

    alvo.classList.add('sobre-item', antes ? 'inserir-antes' : 'inserir-depois');
  });

  lista.addEventListener('drop', (e) => {
    e.preventDefault();

    const alvo = e.target.closest('.item-lista');
    if (!alvo || alvo === itemArrastado) return;

    const rect = alvo.getBoundingClientRect();
    const antes = e.clientY < rect.top + rect.height / 2;

    if (antes) {
      lista.insertBefore(itemArrastado, alvo);
    } else {
      lista.insertBefore(itemArrastado, alvo.nextSibling);
    }
  });

  // Navegação por teclado para reordenar (acessibilidade)
  lista.addEventListener('keydown', (e) => {
    const item = e.target.closest('.item-lista');
    if (!item) return;

    if (e.altKey && e.key === 'ArrowUp') {
      e.preventDefault();
      const anterior = item.previousElementSibling;
      if (anterior) {
        lista.insertBefore(item, anterior);
        item.focus();
        salvarOrdem();
      }
    }

    if (e.altKey && e.key === 'ArrowDown') {
      e.preventDefault();
      const proximo = item.nextElementSibling;
      if (proximo) {
        lista.insertBefore(proximo, item);
        item.focus();
        salvarOrdem();
      }
    }
  });

  function salvarOrdem() {
    const ordem = [...lista.querySelectorAll('.item-lista')]
      .map(item => item.dataset.id);
    localStorage.setItem('ordem-lista', JSON.stringify(ordem));

    lista.dispatchEvent(new CustomEvent('lista-reordenada', {
      detail: { ordem }, bubbles: true
    }));
  }

  // Restaurar ordem salva
  const ordemSalva = JSON.parse(localStorage.getItem('ordem-lista') || 'null');
  if (ordemSalva) {
    ordemSalva.forEach(id => {
      const item = lista.querySelector(`[data-id="${id}"]`);
      if (item) lista.appendChild(item);
    });
  }
}

inicializarListaReordenavel('#lista-ordem');
```

---

## 15.4 — Validação de formulários com JavaScript

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

A validação nativa do HTML (atributos `required`, `pattern`, `type`) oferece uma camada de proteção básica e útil para o usuário. Contudo, ela tem limitações significativas para aplicações reais: mensagens de erro genéricas, ausência de validação cruzada entre campos, impossibilidade de validação assíncrona (verificar se um e-mail já existe no servidor) e dificuldade de customização visual. O JavaScript preenche essas lacunas, permitindo validação rica, em tempo real e completamente customizada.

> **Princípio fundamental** (reforçado do Capítulo 5): validação no frontend é uma conveniência para o usuário. A validação definitiva **sempre** ocorre no servidor. Todo código de validação JavaScript pode ser contornado por um usuário com conhecimento técnico.

### 15.4.1 — Limitações da validação nativa do HTML

```html
<!-- Problemas com a validação nativa -->

<!-- 1. Mensagens genéricas e não customizáveis em todos os navegadores -->
<input type="email" required />
<!-- Chrome: "Insira um endereço de e-mail válido" -->
<!-- Firefox: "Por favor, insira um endereço de e-mail válido" -->

<!-- 2. Sem validação cruzada -->
<input type="password" id="senha" />
<input type="password" id="confirmar-senha" />
<!-- Não há como verificar se os dois campos são iguais com HTML puro -->

<!-- 3. Feedback apenas no submit — não em tempo real -->
<!-- O usuário só descobre os erros ao tentar enviar -->

<!-- 4. Impossível validar com dados externos -->
<!-- "Este e-mail já está cadastrado?" requer uma requisição ao servidor -->
```

### 15.4.2 — A Constraint Validation API

O navegador expõe uma API JavaScript para interagir com o sistema de validação nativo:

```javascript
const input = document.querySelector('#email');

// Verificar validade
input.validity.valid          // → boolean: campo é válido?
input.validity.valueMissing   // → true se required e vazio
input.validity.typeMismatch   // → true se type="email" e formato inválido
input.validity.patternMismatch // → true se pattern não satisfeito
input.validity.tooShort       // → true se menor que minlength
input.validity.tooLong        // → true se maior que maxlength
input.validity.rangeUnderflow // → true se menor que min
input.validity.rangeOverflow  // → true se maior que max
input.validity.stepMismatch   // → true se não múltiplo de step
input.validity.customError    // → true se setCustomValidity foi chamado

// Obter mensagem de erro do navegador
input.validationMessage // → "Por favor, preencha este campo."

// Definir erro customizado (entra na validação nativa)
input.setCustomValidity('Este e-mail já está cadastrado.');
input.setCustomValidity(''); // limpa o erro customizado

// Verificar se o formulário inteiro é válido
const form = document.querySelector('form');
form.checkValidity()    // → boolean
form.reportValidity()   // → boolean + exibe erros nativos

// novalidate: desabilita validação nativa para usar a própria
// <form novalidate>
```

### 15.4.3 — Validação em tempo real com o evento `input`

A estratégia mais eficaz para UX é validar enquanto o usuário digita, mas com uma experiência cuidadosa: não mostrar erros antes que o usuário interaja com o campo, e não punir precocemente quem ainda está digitando.

```javascript
// Estratégia: validar no blur (saída do campo) e depois em tempo real
function configurarValidacaoTempoReal(campo, validar) {
  let jaInteragiu = false;

  // Primeiro erro: mostrado ao sair do campo
  campo.addEventListener('blur', () => {
    jaInteragiu = true;
    const erro = validar(campo.value);
    exibirErro(campo, erro);
  });

  // Erros subsequentes: atualizados em tempo real
  campo.addEventListener('input', () => {
    if (!jaInteragiu) return;
    const erro = validar(campo.value);
    exibirErro(campo, erro);
  });
}

// Exibir/limpar mensagem de erro acessível
function exibirErro(campo, mensagem) {
  const campoWrapper = campo.closest('.campo');
  if (!campoWrapper) return;

  const erroEl = campoWrapper.querySelector('.campo__erro');
  const iconeSucesso = campoWrapper.querySelector('.campo__icone-sucesso');

  if (mensagem) {
    campo.setAttribute('aria-invalid', 'true');
    if (erroEl) {
      erroEl.textContent = mensagem;
      erroEl.hidden = false;
    }
    campoWrapper.classList.add('campo--erro');
    campoWrapper.classList.remove('campo--valido');
    if (iconeSucesso) iconeSucesso.hidden = true;
  } else {
    campo.setAttribute('aria-invalid', 'false');
    if (erroEl) {
      erroEl.textContent = '';
      erroEl.hidden = true;
    }
    campoWrapper.classList.remove('campo--erro');
    campoWrapper.classList.add('campo--valido');
    if (iconeSucesso) iconeSucesso.hidden = false;
  }
}
```

### 15.4.4 — Validando diferentes tipos de componentes HTML

Esta seção demonstra a validação de **todos os tipos principais de componentes** de formulário — cada um com suas particularidades.

**Validando `<input type="text">`**

```javascript
// Regras de validação para texto livre
function validarNome(valor) {
  if (!valor.trim()) return 'O nome é obrigatório.';
  if (valor.trim().length < 3) return 'O nome deve ter pelo menos 3 caracteres.';
  if (valor.trim().length > 100) return 'O nome deve ter no máximo 100 caracteres.';
  if (!/^[a-zA-ZÀ-ÿ\s'-]+$/.test(valor)) return 'O nome deve conter apenas letras.';
  return null; // sem erro
}
```

**Validando `<input type="email">`**

```javascript
function validarEmail(valor) {
  if (!valor.trim()) return 'O e-mail é obrigatório.';
  // Regex RFC 5322 simplificada para uso prático
  const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!regexEmail.test(valor)) return 'Informe um e-mail válido. Ex.: usuario@dominio.com';
  return null;
}
```

**Validando `<input type="password">` com confirmação**

```javascript
function validarSenha(valor) {
  if (!valor) return 'A senha é obrigatória.';
  if (valor.length < 8) return 'A senha deve ter pelo menos 8 caracteres.';
  if (!/[A-Z]/.test(valor)) return 'A senha deve conter pelo menos uma letra maiúscula.';
  if (!/[0-9]/.test(valor)) return 'A senha deve conter pelo menos um número.';
  if (!/[!@#$%^&*]/.test(valor)) return 'A senha deve conter pelo menos um caractere especial (!@#$%^&*).';
  return null;
}

function validarConfirmacaoSenha(valorConfirmacao, valorSenha) {
  if (!valorConfirmacao) return 'A confirmação de senha é obrigatória.';
  if (valorConfirmacao !== valorSenha) return 'As senhas não coincidem.';
  return null;
}

// Indicador de força da senha
function calcularForcaSenha(senha) {
  let pontos = 0;
  if (senha.length >= 8)  pontos++;
  if (senha.length >= 12) pontos++;
  if (/[A-Z]/.test(senha)) pontos++;
  if (/[0-9]/.test(senha)) pontos++;
  if (/[!@#$%^&*]/.test(senha)) pontos++;

  if (pontos <= 1) return { nivel: 'fraca',  label: 'Fraca',  cor: '#dc2626' };
  if (pontos <= 3) return { nivel: 'media',  label: 'Média',  cor: '#d97706' };
  return              { nivel: 'forte', label: 'Forte', cor: '#16a34a' };
}
```

**Validando `<input type="tel">`**

```javascript
function validarTelefone(valor) {
  if (!valor.trim()) return null; // campo opcional
  // Formatos aceitos: (82) 99999-9999 ou (82) 9999-9999
  const regex = /^\(\d{2}\)\s?\d{4,5}-\d{4}$/;
  if (!regex.test(valor)) {
    return 'Informe o telefone no formato (DDD) NNNNN-NNNN.';
  }
  return null;
}

// Máscara automática para telefone
function aplicarMascaraTelefone(input) {
  input.addEventListener('input', (e) => {
    let v = e.target.value.replace(/\D/g, ''); // apenas dígitos
    if (v.length > 11) v = v.slice(0, 11);

    if (v.length <= 10) {
      v = v.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
    } else {
      v = v.replace(/(\d{2})(\d{5})(\d{0,4})/, '($1) $2-$3');
    }
    e.target.value = v;
  });
}
```

**Validando `<input type="date">`**

```javascript
function validarDataNascimento(valor) {
  if (!valor) return 'A data de nascimento é obrigatória.';

  const data = new Date(valor + 'T00:00:00'); // evita problemas de fuso
  const hoje = new Date();

  if (isNaN(data.getTime())) return 'Data inválida.';

  const idade = hoje.getFullYear() - data.getFullYear();
  const aniversarioPassou =
    hoje.getMonth() > data.getMonth() ||
    (hoje.getMonth() === data.getMonth() && hoje.getDate() >= data.getDate());
  const idadeReal = aniversarioPassou ? idade : idade - 1;

  if (idadeReal < 16) return 'Você deve ter pelo menos 16 anos.';
  if (idadeReal > 120) return 'Data de nascimento inválida.';

  return null;
}
```

**Validando `<input type="number">`**

```javascript
function validarIdade(valor) {
  if (!valor) return 'A idade é obrigatória.';
  const numero = Number(valor);
  if (!Number.isInteger(numero)) return 'Informe um número inteiro.';
  if (numero < 16) return 'A idade mínima é 16 anos.';
  if (numero > 120) return 'Informe uma idade válida.';
  return null;
}
```

**Validando `<select>`**

```javascript
function validarSelect(valor, nomeCampo = 'campo') {
  if (!valor || valor === '') {
    return `Selecione uma opção para ${nomeCampo}.`;
  }
  return null;
}

// Para select múltiplo
function validarSelectMultiplo(select, min = 1, max = Infinity) {
  const selecionados = [...select.selectedOptions].map(o => o.value);
  if (selecionados.length < min) {
    return `Selecione pelo menos ${min} opção${min > 1 ? 'ões' : ''}.`;
  }
  if (selecionados.length > max) {
    return `Selecione no máximo ${max} opção${max > 1 ? 'ões' : ''}.`;
  }
  return null;
}
```

**Validando `<input type="checkbox">`**

```javascript
// Checkbox único (aceite de termos)
function validarCheckbox(checkbox, mensagem = 'Este campo é obrigatório.') {
  return checkbox.checked ? null : mensagem;
}

// Grupo de checkboxes (múltiplas escolhas)
function validarGrupoCheckbox(nome, min = 1, max = Infinity) {
  const marcados = document.querySelectorAll(
    `input[type="checkbox"][name="${nome}"]:checked`
  );
  if (marcados.length < min) {
    return `Selecione pelo menos ${min} opção${min > 1 ? 'ões' : ''}.`;
  }
  if (marcados.length > max) {
    return `Selecione no máximo ${max} opção${max > 1 ? 'ões' : ''}.`;
  }
  return null;
}
```

**Validando `<input type="radio">`**

```javascript
function validarRadio(nome) {
  const selecionado = document.querySelector(
    `input[type="radio"][name="${nome}"]:checked`
  );
  return selecionado ? null : 'Selecione uma opção.';
}
```

**Validando `<textarea>`**

```javascript
function validarMensagem(valor, minChars = 20, maxChars = 1000) {
  if (!valor.trim()) return 'A mensagem é obrigatória.';
  if (valor.trim().length < minChars) {
    return `A mensagem deve ter pelo menos ${minChars} caracteres. ` +
           `Atual: ${valor.trim().length}.`;
  }
  if (valor.length > maxChars) {
    return `A mensagem deve ter no máximo ${maxChars} caracteres. ` +
           `Atual: ${valor.length}.`;
  }
  return null;
}

// Contador de caracteres em tempo real
function adicionarContadorCaracteres(textarea, max) {
  const container = textarea.closest('.campo');
  const contador = document.createElement('p');
  contador.className = 'campo__contador';
  contador.setAttribute('aria-live', 'polite');
  container.appendChild(contador);

  function atualizar() {
    const restante = max - textarea.value.length;
    contador.textContent = `${textarea.value.length}/${max} caracteres`;
    contador.classList.toggle('campo__contador--limite', restante <= 20);
    textarea.setAttribute('aria-describedby',
      [textarea.getAttribute('aria-describedby'), contador.id]
      .filter(Boolean).join(' ')
    );
  }

  textarea.addEventListener('input', atualizar);
  atualizar();
}
```

**Validando `<input type="file">`**

```javascript
function validarArquivo(input, opcoes = {}) {
  const {
    obrigatorio = false,
    tiposPermitidos = [],      // ex.: ['image/jpeg', 'image/png', 'application/pdf']
    extensoesPermitidas = [],  // ex.: ['.jpg', '.png', '.pdf']
    tamanhoMaximoMB = 5
  } = opcoes;

  const arquivo = input.files[0];

  if (!arquivo) {
    return obrigatorio ? 'Selecione um arquivo.' : null;
  }

  if (tiposPermitidos.length && !tiposPermitidos.includes(arquivo.type)) {
    return `Tipo de arquivo não permitido. Aceitos: ${extensoesPermitidas.join(', ')}.`;
  }

  const tamanhoMB = arquivo.size / (1024 * 1024);
  if (tamanhoMB > tamanhoMaximoMB) {
    return `O arquivo é muito grande (${tamanhoMB.toFixed(1)} MB). Máximo: ${tamanhoMaximoMB} MB.`;
  }

  return null;
}

// Preview de imagem antes do upload
function configurarPreviewImagem(input, imgPreview) {
  input.addEventListener('change', () => {
    const arquivo = input.files[0];
    if (!arquivo || !arquivo.type.startsWith('image/')) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      imgPreview.src = e.target.result;
      imgPreview.hidden = false;
    };
    reader.readAsDataURL(arquivo);
  });
}
```

### 15.4.5 — Mensagens de erro acessíveis com ARIA

Mensagens de erro devem ser percebidas por todos os usuários — incluindo aqueles que utilizam leitores de tela:

```html
<!-- Estrutura HTML para campo com erro acessível -->
<div class="campo" id="campo-email-wrapper">
  <label class="campo__label" for="email">
    E-mail
    <span class="campo__obrigatorio" aria-hidden="true">*</span>
  </label>

  <div class="campo__input-wrapper">
    <input
      class="campo__input"
      type="email"
      id="email"
      name="email"
      required
      aria-required="true"
      aria-invalid="false"
      aria-describedby="email-erro email-dica"
      autocomplete="email"
    />
    <span class="campo__icone-sucesso" hidden aria-hidden="true">✓</span>
  </div>

  <p class="campo__dica" id="email-dica">
    Ex.: usuario@dominio.com.br
  </p>

  <!-- role="alert": anunciado automaticamente por leitores de tela ao aparecer -->
  <p
    class="campo__erro"
    id="email-erro"
    role="alert"
    aria-live="assertive"
    hidden
  ></p>
</div>
```

```javascript
// Função centralizada de exibição de erro com ARIA completo
function exibirErroAcessivel(campoId, mensagem) {
  const campo = document.getElementById(campoId);
  const erroEl = document.getElementById(`${campoId}-erro`);
  const wrapper = campo.closest('.campo');

  if (mensagem) {
    campo.setAttribute('aria-invalid', 'true');
    erroEl.textContent = mensagem;
    erroEl.hidden = false;
    wrapper.classList.add('campo--erro');
    wrapper.classList.remove('campo--valido');
  } else {
    campo.setAttribute('aria-invalid', 'false');
    erroEl.textContent = '';
    erroEl.hidden = true;
    wrapper.classList.remove('campo--erro');
    wrapper.classList.add('campo--valido');
  }
}

// Focar no primeiro campo com erro após tentativa de submit
function focarPrimeiroErro(form) {
  const primeiroErro = form.querySelector('[aria-invalid="true"]');
  if (primeiroErro) {
    primeiroErro.focus();
    primeiroErro.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
}

// Anúncio de resumo de erros para leitores de tela
function anunciarResumoErros(erros) {
  const regiao = document.querySelector('#resumo-erros');
  if (!regiao) return;

  if (erros.length === 0) {
    regiao.hidden = true;
    regiao.innerHTML = '';
    return;
  }

  regiao.hidden = false;
  regiao.innerHTML = `
    <h3>Corrija ${erros.length} erro${erros.length > 1 ? 's' : ''} antes de continuar:</h3>
    <ul>
      ${erros.map(e => `<li><a href="#${e.campoId}">${e.mensagem}</a></li>`).join('')}
    </ul>
  `;
  regiao.focus();
}
```

### 15.4.6 — Exercício prático: formulário de cadastro completo

Este exercício integra a validação de **todos os tipos de componentes** vistos nas seções anteriores em um formulário coeso:

```html
<form id="form-cadastro" novalidate aria-label="Formulário de cadastro">

  <!-- Resumo de erros (para leitores de tela) -->
  <div id="resumo-erros" role="alert" aria-live="assertive" tabindex="-1" hidden></div>

  <!-- ── Dados Pessoais ── -->
  <fieldset>
    <legend>Dados Pessoais</legend>

    <!-- Nome completo (text) -->
    <div class="campo" id="campo-nome-wrapper">
      <label class="campo__label" for="nome">
        Nome completo <span aria-hidden="true">*</span>
      </label>
      <input class="campo__input" type="text" id="nome" name="nome"
             required aria-required="true" aria-invalid="false"
             aria-describedby="nome-erro"
             autocomplete="name" placeholder="Maria da Silva" />
      <p class="campo__erro" id="nome-erro" role="alert" hidden></p>
    </div>

    <!-- E-mail (email) -->
    <div class="campo" id="campo-email-wrapper">
      <label class="campo__label" for="email">
        E-mail <span aria-hidden="true">*</span>
      </label>
      <input class="campo__input" type="email" id="email" name="email"
             required aria-required="true" aria-invalid="false"
             aria-describedby="email-erro email-dica"
             autocomplete="email" />
      <p class="campo__dica" id="email-dica">Ex.: usuario@dominio.com</p>
      <p class="campo__erro" id="email-erro" role="alert" hidden></p>
    </div>

    <!-- Telefone (tel) com máscara -->
    <div class="campo" id="campo-telefone-wrapper">
      <label class="campo__label" for="telefone">Telefone</label>
      <input class="campo__input" type="tel" id="telefone" name="telefone"
             aria-invalid="false" aria-describedby="telefone-erro telefone-dica"
             autocomplete="tel" placeholder="(82) 99999-9999" />
      <p class="campo__dica" id="telefone-dica">Formato: (DDD) NNNNN-NNNN</p>
      <p class="campo__erro" id="telefone-erro" role="alert" hidden></p>
    </div>

    <!-- Data de nascimento (date) -->
    <div class="campo" id="campo-nascimento-wrapper">
      <label class="campo__label" for="nascimento">
        Data de nascimento <span aria-hidden="true">*</span>
      </label>
      <input class="campo__input" type="date" id="nascimento" name="nascimento"
             required aria-required="true" aria-invalid="false"
             aria-describedby="nascimento-erro"
             autocomplete="bday" />
      <p class="campo__erro" id="nascimento-erro" role="alert" hidden></p>
    </div>

  </fieldset>

  <!-- ── Curso e Preferências ── -->
  <fieldset>
    <legend>Curso e Preferências</legend>

    <!-- Curso (select) -->
    <div class="campo" id="campo-curso-wrapper">
      <label class="campo__label" for="curso">
        Curso de interesse <span aria-hidden="true">*</span>
      </label>
      <select class="campo__input" id="curso" name="curso"
              required aria-required="true" aria-invalid="false"
              aria-describedby="curso-erro">
        <option value="">Selecione um curso...</option>
        <option value="si">Sistemas de Informação</option>
        <option value="cc">Ciência da Computação</option>
        <option value="ec">Engenharia da Computação</option>
        <option value="ads">Análise e Desenvolvimento de Sistemas</option>
      </select>
      <p class="campo__erro" id="curso-erro" role="alert" hidden></p>
    </div>

    <!-- Turno (radio) -->
    <div class="campo" id="campo-turno-wrapper">
      <fieldset>
        <legend class="campo__label">
          Turno de preferência <span aria-hidden="true">*</span>
        </legend>
        <div class="campo__radio-grupo" role="group">
          <label class="campo__radio-label">
            <input type="radio" name="turno" value="manha" />
            Manhã
          </label>
          <label class="campo__radio-label">
            <input type="radio" name="turno" value="tarde" />
            Tarde
          </label>
          <label class="campo__radio-label">
            <input type="radio" name="turno" value="noite" />
            Noite
          </label>
        </div>
        <p class="campo__erro" id="turno-erro" role="alert" hidden></p>
      </fieldset>
    </div>

    <!-- Áreas de interesse (checkbox múltiplo) -->
    <div class="campo" id="campo-interesses-wrapper">
      <fieldset>
        <legend class="campo__label">
          Áreas de interesse <span aria-hidden="true">*</span>
          <span class="campo__dica-inline">(selecione pelo menos 2)</span>
        </legend>
        <div class="campo__checkbox-grupo">
          <label><input type="checkbox" name="interesse" value="web" /> Desenvolvimento Web</label>
          <label><input type="checkbox" name="interesse" value="dados" /> Ciência de Dados</label>
          <label><input type="checkbox" name="interesse" value="infra" /> Infraestrutura</label>
          <label><input type="checkbox" name="interesse" value="seguranca" /> Segurança</label>
          <label><input type="checkbox" name="interesse" value="ia" /> Inteligência Artificial</label>
        </div>
        <p class="campo__erro" id="interesses-erro" role="alert" hidden></p>
      </fieldset>
    </div>

    <!-- Mensagem (textarea) com contador -->
    <div class="campo" id="campo-mensagem-wrapper">
      <label class="campo__label" for="mensagem">
        Por que deseja estudar aqui? <span aria-hidden="true">*</span>
      </label>
      <textarea class="campo__input" id="mensagem" name="mensagem"
                rows="5" required aria-required="true" aria-invalid="false"
                aria-describedby="mensagem-erro mensagem-contador"
                placeholder="Descreva sua motivação (mínimo 50 caracteres)...">
      </textarea>
      <p class="campo__contador" id="mensagem-contador" aria-live="polite">0/500</p>
      <p class="campo__erro" id="mensagem-erro" role="alert" hidden></p>
    </div>

    <!-- Foto (file) -->
    <div class="campo" id="campo-foto-wrapper">
      <label class="campo__label" for="foto">Foto de perfil</label>
      <input class="campo__input" type="file" id="foto" name="foto"
             accept="image/jpeg,image/png,image/webp"
             aria-invalid="false" aria-describedby="foto-erro foto-dica" />
      <p class="campo__dica" id="foto-dica">JPG, PNG ou WebP. Máximo 2 MB.</p>
      <img id="foto-preview" class="campo__preview" hidden alt="Preview da foto" />
      <p class="campo__erro" id="foto-erro" role="alert" hidden></p>
    </div>

  </fieldset>

  <!-- ── Segurança ── -->
  <fieldset>
    <legend>Acesso</legend>

    <!-- Senha (password) com indicador de força -->
    <div class="campo" id="campo-senha-wrapper">
      <label class="campo__label" for="senha">
        Senha <span aria-hidden="true">*</span>
      </label>
      <div class="campo__input-wrapper">
        <input class="campo__input" type="password" id="senha" name="senha"
               required aria-required="true" aria-invalid="false"
               aria-describedby="senha-erro senha-forca senha-dica"
               autocomplete="new-password" />
        <button type="button" class="campo__toggle-senha"
                aria-label="Mostrar senha" data-target="senha">
          👁
        </button>
      </div>
      <div class="campo__forca" id="senha-forca" aria-live="polite"></div>
      <p class="campo__dica" id="senha-dica">
        Mínimo 8 caracteres, com maiúscula, número e símbolo (!@#$%^&*).
      </p>
      <p class="campo__erro" id="senha-erro" role="alert" hidden></p>
    </div>

    <!-- Confirmar senha (password) -->
    <div class="campo" id="campo-confirmar-wrapper">
      <label class="campo__label" for="confirmar-senha">
        Confirmar senha <span aria-hidden="true">*</span>
      </label>
      <div class="campo__input-wrapper">
        <input class="campo__input" type="password" id="confirmar-senha"
               name="confirmar_senha"
               required aria-required="true" aria-invalid="false"
               aria-describedby="confirmar-erro"
               autocomplete="new-password" />
        <button type="button" class="campo__toggle-senha"
                aria-label="Mostrar confirmação" data-target="confirmar-senha">
          👁
        </button>
      </div>
      <p class="campo__erro" id="confirmar-erro" role="alert" hidden></p>
    </div>

  </fieldset>

  <!-- Aceite de termos (checkbox) -->
  <div class="campo" id="campo-termos-wrapper">
    <label class="campo__checkbox-label">
      <input type="checkbox" id="termos" name="termos"
             required aria-required="true" aria-invalid="false"
             aria-describedby="termos-erro" />
      Li e aceito os <a href="/termos" target="_blank" rel="noopener">termos de uso</a>
      e a <a href="/privacidade" target="_blank" rel="noopener">política de privacidade</a>.
      <span aria-hidden="true">*</span>
    </label>
    <p class="campo__erro" id="termos-erro" role="alert" hidden></p>
  </div>

  <div class="form-acoes">
    <button type="reset" class="btn btn--secundario">Limpar</button>
    <button type="submit" class="btn btn--primario">Enviar cadastro</button>
  </div>

</form>
```

```javascript
// ── Controlador do formulário de cadastro ──────────────────

const form = document.querySelector('#form-cadastro');

// Configuração dos campos e suas regras
const CAMPOS = {
  nome:            { validar: validarNome },
  email:           { validar: validarEmail },
  telefone:        { validar: validarTelefone },
  nascimento:      { validar: validarDataNascimento },
  curso:           { validar: (v) => validarSelect(v, 'o curso') },
  senha:           { validar: validarSenha },
  'confirmar-senha': {
    validar: (v) => validarConfirmacaoSenha(
      v, document.getElementById('senha').value
    )
  },
  mensagem: {
    validar: (v) => validarMensagem(v, 50, 500)
  },
};

// Inicializar validação em tempo real para campos de texto
Object.entries(CAMPOS).forEach(([id, cfg]) => {
  const campo = document.getElementById(id);
  if (campo) configurarValidacaoTempoReal(campo, cfg.validar);
});

// Máscara de telefone
aplicarMascaraTelefone(document.getElementById('telefone'));

// Preview de foto
configurarPreviewImagem(
  document.getElementById('foto'),
  document.getElementById('foto-preview')
);

// Contador de caracteres na mensagem
adicionarContadorCaracteres(document.getElementById('mensagem'), 500);

// Indicador de força da senha
document.getElementById('senha').addEventListener('input', (e) => {
  const forca = calcularForcaSenha(e.target.value);
  const el = document.getElementById('senha-forca');
  el.innerHTML = `
    <div class="forca-barra forca-barra--${forca.nivel}"></div>
    <span>Força: ${forca.label}</span>
  `;
});

// Toggle visibilidade de senha
document.querySelectorAll('.campo__toggle-senha').forEach(btn => {
  btn.addEventListener('click', () => {
    const targetId = btn.dataset.target;
    const input = document.getElementById(targetId);
    const visivel = input.type === 'text';
    input.type = visivel ? 'password' : 'text';
    btn.setAttribute('aria-label', visivel ? 'Mostrar senha' : 'Ocultar senha');
    btn.textContent = visivel ? '👁' : '🙈';
  });
});

// Submissão: valida todos os campos
form.addEventListener('submit', (e) => {
  e.preventDefault();

  const erros = [];

  // Validar campos de texto individuais
  Object.entries(CAMPOS).forEach(([id, cfg]) => {
    const campo = document.getElementById(id);
    if (!campo) return;
    const erro = cfg.validar(campo.value);
    exibirErroAcessivel(id, erro);
    if (erro) erros.push({ campoId: id, mensagem: erro });
  });

  // Validar turno (radio)
  const erroTurno = validarRadio('turno');
  const erroTurnoEl = document.getElementById('turno-erro');
  erroTurnoEl.textContent = erroTurno || '';
  erroTurnoEl.hidden = !erroTurno;
  if (erroTurno) erros.push({ campoId: 'turno', mensagem: erroTurno });

  // Validar interesses (checkbox múltiplo — mínimo 2)
  const erroInteresses = validarGrupoCheckbox('interesse', 2);
  const erroInteressesEl = document.getElementById('interesses-erro');
  erroInteressesEl.textContent = erroInteresses || '';
  erroInteressesEl.hidden = !erroInteresses;
  if (erroInteresses) erros.push({ campoId: 'interesse', mensagem: erroInteresses });

  // Validar termos (checkbox único)
  const checkTermos = document.getElementById('termos');
  const erroTermos = validarCheckbox(checkTermos, 'Você deve aceitar os termos.');
  exibirErroAcessivel('termos', erroTermos);
  if (erroTermos) erros.push({ campoId: 'termos', mensagem: erroTermos });

  // Validar foto (opcional, mas com restrições se preenchida)
  const inputFoto = document.getElementById('foto');
  const erroFoto = validarArquivo(inputFoto, {
    tiposPermitidos: ['image/jpeg', 'image/png', 'image/webp'],
    extensoesPermitidas: ['.jpg', '.jpeg', '.png', '.webp'],
    tamanhoMaximoMB: 2
  });
  exibirErroAcessivel('foto', erroFoto);
  if (erroFoto) erros.push({ campoId: 'foto', mensagem: erroFoto });

  // Exibir resumo e focar primeiro erro
  anunciarResumoErros(erros);

  if (erros.length > 0) {
    focarPrimeiroErro(form);
    return;
  }

  // Formulário válido: coletar dados
  const dados = coletarDados();
  console.log('Dados válidos:', dados);
  enviarFormulario(dados);
});

function coletarDados() {
  const fd = new FormData(form);
  return {
    nome:       fd.get('nome'),
    email:      fd.get('email'),
    telefone:   fd.get('telefone'),
    nascimento: fd.get('nascimento'),
    curso:      fd.get('curso'),
    turno:      fd.get('turno'),
    interesses: fd.getAll('interesse'),
    mensagem:   fd.get('mensagem'),
    foto:       fd.get('foto'),
  };
}

async function enviarFormulario(dados) {
  const btnEnviar = form.querySelector('[type="submit"]');
  btnEnviar.disabled = true;
  btnEnviar.textContent = 'Enviando...';

  try {
    // Simulação de envio — substituir por fetch real
    await new Promise(resolve => setTimeout(resolve, 1500));

    form.dispatchEvent(new CustomEvent('cadastro-enviado', {
      detail: dados, bubbles: true
    }));

    exibirSucesso();
  } catch (erro) {
    console.error('Erro ao enviar:', erro);
    exibirErroEnvio();
  } finally {
    btnEnviar.disabled = false;
    btnEnviar.textContent = 'Enviar cadastro';
  }
}

function exibirSucesso() {
  form.innerHTML = `
    <div class="sucesso" role="alert" tabindex="-1">
      <span class="sucesso__icone" aria-hidden="true">✅</span>
      <h2>Cadastro enviado com sucesso!</h2>
      <p>Em breve você receberá um e-mail de confirmação.</p>
      <button type="button" onclick="location.reload()" class="btn btn--primario">
        Novo cadastro
      </button>
    </div>
  `;
  form.querySelector('.sucesso').focus();
}

function exibirErroEnvio() {
  const aviso = document.querySelector('#resumo-erros');
  aviso.hidden = false;
  aviso.innerHTML = `
    <p>Ocorreu um erro ao enviar. Tente novamente em alguns instantes.</p>
  `;
  aviso.focus();
}
```

---

## 15.5 — Componentes interativos com DOM e Eventos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 15.5.1 — Modal: abrir, fechar, foco e acessibilidade

Um modal acessível requer: gestão de foco (ao abrir, focar dentro; ao fechar, retornar ao gatilho), aprisionamento de foco dentro do modal enquanto aberto, fechar com `Escape`, e atributos ARIA corretos:

```html
<!-- Botão que abre o modal -->
<button type="button" class="btn btn--primario" id="btn-abrir-modal"
        aria-haspopup="dialog">
  Abrir modal
</button>

<!-- Modal -->
<div class="modal" id="modal-confirmacao" role="dialog"
     aria-modal="true" aria-labelledby="modal-titulo"
     aria-describedby="modal-descricao" hidden>

  <div class="modal__overlay" data-fechar-modal></div>

  <div class="modal__caixa">
    <header class="modal__cabecalho">
      <h2 class="modal__titulo" id="modal-titulo">Confirmar ação</h2>
      <button type="button" class="modal__fechar"
              aria-label="Fechar modal" data-fechar-modal>
        ✕
      </button>
    </header>

    <div class="modal__corpo">
      <p id="modal-descricao">
        Tem certeza que deseja continuar? Esta ação não pode ser desfeita.
      </p>
    </div>

    <footer class="modal__rodape">
      <button type="button" class="btn btn--secundario" data-fechar-modal>
        Cancelar
      </button>
      <button type="button" class="btn btn--perigo" id="btn-confirmar-modal">
        Confirmar
      </button>
    </footer>
  </div>
</div>
```

```javascript
class Modal {
  constructor(modalId, gatilhoId) {
    this.modal = document.getElementById(modalId);
    this.gatilho = document.getElementById(gatilhoId);
    this.elementoFocavel = null;

    this.inicializar();
  }

  inicializar() {
    // Abrir
    this.gatilho?.addEventListener('click', () => this.abrir());

    // Fechar
    this.modal.addEventListener('click', (e) => {
      if (e.target.dataset.fecharModal !== undefined) this.fechar();
    });

    // Fechar com Escape
    this.modal.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') this.fechar();
      if (e.key === 'Tab') this.gerenciarFoco(e);
    });
  }

  abrir() {
    this.elementoFocavel = document.activeElement;
    this.modal.hidden = false;
    document.body.style.overflow = 'hidden'; // previne scroll do fundo

    // Focar no primeiro elemento focável do modal
    const primeiroPodeFocar = this.obterElementosFocaveis()[0];
    if (primeiroPodeFocar) {
      requestAnimationFrame(() => primeiroPodeFocar.focus());
    }

    this.modal.dispatchEvent(new CustomEvent('modal-aberto', { bubbles: true }));
  }

  fechar() {
    this.modal.hidden = true;
    document.body.style.overflow = '';

    // Retornar foco ao gatilho original
    this.elementoFocavel?.focus();

    this.modal.dispatchEvent(new CustomEvent('modal-fechado', { bubbles: true }));
  }

  gerenciarFoco(e) {
    const focaveis = this.obterElementosFocaveis();
    if (!focaveis.length) return;

    const primeiro = focaveis[0];
    const ultimo = focaveis[focaveis.length - 1];

    if (e.shiftKey) {
      if (document.activeElement === primeiro) {
        e.preventDefault();
        ultimo.focus();
      }
    } else {
      if (document.activeElement === ultimo) {
        e.preventDefault();
        primeiro.focus();
      }
    }
  }

  obterElementosFocaveis() {
    return [...this.modal.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )].filter(el => !el.disabled && !el.hidden);
  }
}

const modalConfirmacao = new Modal('modal-confirmacao', 'btn-abrir-modal');

document.getElementById('btn-confirmar-modal').addEventListener('click', () => {
  modalConfirmacao.fechar();
  executarAcaoConfirmada();
});
```

### 15.5.2 — Dropdown: abrir, fechar ao clicar fora e navegação por teclado

```html
<div class="dropdown" id="dropdown-usuario">
  <button type="button" class="dropdown__gatilho btn"
          aria-haspopup="true" aria-expanded="false"
          aria-controls="menu-usuario" id="btn-dropdown-usuario">
    Maria Silva ▾
  </button>

  <ul class="dropdown__menu" id="menu-usuario"
      role="menu" aria-labelledby="btn-dropdown-usuario" hidden>
    <li role="none">
      <a class="dropdown__item" href="/perfil" role="menuitem">Meu perfil</a>
    </li>
    <li role="none">
      <a class="dropdown__item" href="/configuracoes" role="menuitem">
        Configurações
      </a>
    </li>
    <li role="separator" aria-hidden="true"></li>
    <li role="none">
      <button class="dropdown__item" type="button" role="menuitem"
              id="btn-sair">
        Sair
      </button>
    </li>
  </ul>
</div>
```

```javascript
function inicializarDropdown(dropdownSelector) {
  const dropdown = document.querySelector(dropdownSelector);
  const gatilho = dropdown.querySelector('.dropdown__gatilho');
  const menu    = dropdown.querySelector('.dropdown__menu');
  const itens   = () => [...menu.querySelectorAll('[role="menuitem"]')];

  function abrir() {
    menu.hidden = false;
    gatilho.setAttribute('aria-expanded', 'true');
    const primeiroItem = itens()[0];
    primeiroItem?.focus();
  }

  function fechar(retornarFoco = true) {
    menu.hidden = true;
    gatilho.setAttribute('aria-expanded', 'false');
    if (retornarFoco) gatilho.focus();
  }

  function estaAberto() {
    return !menu.hidden;
  }

  // Toggle ao clicar no gatilho
  gatilho.addEventListener('click', () => {
    estaAberto() ? fechar() : abrir();
  });

  // Fechar ao clicar fora
  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target)) fechar(false);
  });

  // Navegação por teclado (padrão WAI-ARIA para menu)
  dropdown.addEventListener('keydown', (e) => {
    const lista = itens();
    const ativo = document.activeElement;
    const indice = lista.indexOf(ativo);

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        if (!estaAberto()) { abrir(); return; }
        lista[Math.min(indice + 1, lista.length - 1)]?.focus();
        break;

      case 'ArrowUp':
        e.preventDefault();
        if (!estaAberto()) { abrir(); return; }
        if (indice <= 0) { fechar(); return; }
        lista[indice - 1]?.focus();
        break;

      case 'Home':
        if (estaAberto()) { e.preventDefault(); lista[0]?.focus(); }
        break;

      case 'End':
        if (estaAberto()) {
          e.preventDefault();
          lista[lista.length - 1]?.focus();
        }
        break;

      case 'Escape':
        fechar();
        break;

      case 'Tab':
        fechar(false); // fecha sem roubar o foco do tab
        break;
    }
  });

  return { abrir, fechar };
}

inicializarDropdown('#dropdown-usuario');
```

### 15.5.3 — Accordion: expandir e colapsar seções

```html
<div class="accordion" id="accordion-faq">

  <div class="accordion__item">
    <h3 class="accordion__titulo">
      <button class="accordion__botao" type="button"
              aria-expanded="false"
              aria-controls="painel-1" id="botao-1">
        <span>O que é HTML semântico?</span>
        <span class="accordion__icone" aria-hidden="true">+</span>
      </button>
    </h3>
    <div class="accordion__painel" id="painel-1"
         role="region" aria-labelledby="botao-1" hidden>
      <div class="accordion__conteudo">
        <p>HTML semântico refere-se ao uso de elementos HTML que
           transmitem significado sobre o conteúdo que envolvem...</p>
      </div>
    </div>
  </div>

  <div class="accordion__item">
    <h3 class="accordion__titulo">
      <button class="accordion__botao" type="button"
              aria-expanded="false"
              aria-controls="painel-2" id="botao-2">
        <span>Qual a diferença entre Flexbox e Grid?</span>
        <span class="accordion__icone" aria-hidden="true">+</span>
      </button>
    </h3>
    <div class="accordion__painel" id="painel-2"
         role="region" aria-labelledby="botao-2" hidden>
      <div class="accordion__conteudo">
        <p>Flexbox é unidimensional (linha ou coluna);
           Grid é bidimensional (linhas e colunas)...</p>
      </div>
    </div>
  </div>

</div>
```

```javascript
function inicializarAccordion(selector, opcoes = {}) {
  const accordion = document.querySelector(selector);
  const { apenasUm = true } = opcoes; // true: fecha outros ao abrir um

  accordion.addEventListener('click', (e) => {
    const botao = e.target.closest('.accordion__botao');
    if (!botao) return;

    const expandido = botao.getAttribute('aria-expanded') === 'true';
    const painelId = botao.getAttribute('aria-controls');
    const painel = document.getElementById(painelId);
    const icone = botao.querySelector('.accordion__icone');

    if (apenasUm && !expandido) {
      // Fecha todos os outros
      accordion.querySelectorAll('.accordion__botao[aria-expanded="true"]')
        .forEach(outroBotao => {
          if (outroBotao !== botao) {
            outroBotao.setAttribute('aria-expanded', 'false');
            const outroIcone = outroBotao.querySelector('.accordion__icone');
            if (outroIcone) outroIcone.textContent = '+';
            const outroPainel = document.getElementById(
              outroBotao.getAttribute('aria-controls')
            );
            if (outroPainel) outroPainel.hidden = true;
          }
        });
    }

    // Toggle do item clicado
    const novoEstado = !expandido;
    botao.setAttribute('aria-expanded', novoEstado);
    painel.hidden = !novoEstado;
    if (icone) icone.textContent = novoEstado ? '−' : '+';
  });

  // Navegação por teclado entre cabeçalhos
  accordion.addEventListener('keydown', (e) => {
    const botoes = [...accordion.querySelectorAll('.accordion__botao')];
    const indice = botoes.indexOf(e.target);
    if (indice === -1) return;

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      botoes[Math.min(indice + 1, botoes.length - 1)].focus();
    }
    if (e.key === 'ArrowUp') {
      e.preventDefault();
      botoes[Math.max(indice - 1, 0)].focus();
    }
    if (e.key === 'Home') { e.preventDefault(); botoes[0].focus(); }
    if (e.key === 'End')  { e.preventDefault(); botoes[botoes.length - 1].focus(); }
  });
}

inicializarAccordion('#accordion-faq', { apenasUm: true });
```

### 15.5.4 — Exercício prático: página de FAQ com accordion acessível

Combinar o accordion, o sistema de abas e a busca com teclado em uma página de FAQ completa:

```javascript
// FAQ com busca integrada ao accordion
const termoBusca = document.querySelector('#busca-faq');

termoBusca?.addEventListener('input', () => {
  const termo = termoBusca.value.trim().toLowerCase();
  const itens = document.querySelectorAll('.accordion__item');

  itens.forEach(item => {
    const pergunta = item.querySelector('.accordion__botao span:first-child')
      .textContent.toLowerCase();
    const resposta = item.querySelector('.accordion__conteudo')
      .textContent.toLowerCase();

    const corresponde = !termo ||
      pergunta.includes(termo) ||
      resposta.includes(termo);

    item.hidden = !corresponde;

    // Expandir automaticamente se há termo de busca e corresponde
    if (termo && corresponde) {
      const botao = item.querySelector('.accordion__botao');
      const painel = document.getElementById(botao.getAttribute('aria-controls'));
      botao.setAttribute('aria-expanded', 'true');
      painel.hidden = false;
    }
  });

  // Anunciar resultados para leitores de tela
  const visiveis = [...itens].filter(i => !i.hidden).length;
  document.querySelector('#faq-contagem').textContent =
    `${visiveis} pergunta${visiveis !== 1 ? 's' : ''} encontrada${visiveis !== 1 ? 's' : ''}`;
});
```

---

## 15.6 — Projeto integrador do capítulo

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

### 15.6.1 — Especificação

O projeto integrador do Capítulo 15 consolida todos os conceitos em uma aplicação coesa: um **formulário de matrícula com validação completa**, modal de confirmação e feedback visual de sucesso.

**Funcionalidades obrigatórias:**
- Validação em tempo real de todos os campos (texto, email, senha, select, radio, checkbox, textarea)
- Indicador de força de senha
- Modal de confirmação antes de enviar
- Feedback visual de sucesso após envio
- Acessibilidade: navegação por teclado, ARIA, foco gerenciado

**Estrutura sugerida:**

```
projeto-cap15/
├── index.html          ← formulário completo
├── css/
│   ├── style.css       ← estilos do formulário e componentes
│   └── modal.css       ← estilos do modal
└── js/
    ├── validacao.js    ← funções de validação (reutilizáveis)
    ├── componentes.js  ← Modal, Dropdown, Accordion
    └── app.js          ← lógica principal e inicialização
```

### 15.6.2 — Extensões sugeridas para prática autônoma

Após concluir o projeto base, experimente estender com:

1. **Salvamento automático em `localStorage`:** preservar os dados do formulário ao fechar acidentalmente a página e restaurá-los ao reabrir
2. **Validação assíncrona:** simular verificação de e-mail já cadastrado com `setTimeout` e exibir estado de "verificando..."
3. **Multi-step form:** dividir o formulário em etapas com barra de progresso e navegação entre passos
4. **Temas claro/escuro:** toggle de tema com persistência em `localStorage`

---

## 15.7 — Laboratório de jogos: aprofundando com DOM e Eventos

> **Vídeo curto explicativo**
> *(link será adicionado posteriormente)*

> **Conteúdo avançado e opcional.** Esta seção é uma extensão do laboratório de jogos iniciado no Capítulo 14. Os conceitos aqui introduzidos — física com gravidade, detecção de colisão AABB e gerenciamento de estados de jogo — são pré-requisitos comuns a praticamente todo jogo 2D e servem de base para frameworks como Phaser.

### 15.7.1 — Revisão: o que temos e o que falta

No Capítulo 14 construímos três jogos que demonstraram:

| Jogo | Conceitos demonstrados |
|---|---|
| Adivinhe o número | Lógica, DOM, estado simples |
| Clique no alvo | Posicionamento dinâmico, timer, níveis |
| Snake | Canvas, game loop, colisão por grade |

O que ainda não abordamos — e que abre o universo de jogos 2D mais ricos:

- **Física:** objetos que se movem com velocidade, aceleração e gravidade
- **Colisão AABB:** detecção precisa de sobreposição entre retângulos em posições contínuas
- **Estados de jogo:** máquina de estados para gerenciar telas (menu → jogo → pausa → game over)

### 15.7.2 — Física básica: gravidade, velocidade e aceleração

No Snake, cada segmento se movia por uma grade discreta. Em jogos de plataforma, os objetos se movem em espaço contínuo com física simulada:

```javascript
// Modelo de entidade física
function criarEntidade(x, y, largura, altura) {
  return {
    // Posição
    x, y,
    // Dimensões
    largura, altura,
    // Velocidade (pixels por segundo)
    vx: 0,
    vy: 0,
    // Flags de estado
    noChao: false,
  };
}

// Constantes de física
const FISICA = {
  GRAVIDADE:        1800,  // pixels/s²  — aceleração para baixo
  FORCA_PULO:      -600,   // pixels/s   — velocidade inicial do pulo (negativo = cima)
  VELOCIDADE_MAX_QUEDA: 800, // pixels/s — velocidade terminal
  FRICCAO:          0.85,  // fator multiplicativo — desacelera movimento horizontal
};

// Atualizar física de uma entidade
function atualizarFisica(entidade, deltaTime) {
  const dt = deltaTime / 1000; // converter ms para segundos

  // Aplicar gravidade (acelera a queda)
  entidade.vy += FISICA.GRAVIDADE * dt;

  // Limitar velocidade de queda
  entidade.vy = Math.min(entidade.vy, FISICA.VELOCIDADE_MAX_QUEDA);

  // Atualizar posição com base na velocidade
  entidade.x += entidade.vx * dt;
  entidade.y += entidade.vy * dt;

  // Aplicar fricção horizontal (desacelera quando não há input)
  entidade.vx *= FISICA.FRICCAO;

  // Zerear velocidade mínima (evita deslizamento infinito)
  if (Math.abs(entidade.vx) < 0.5) entidade.vx = 0;
}

// Pulo — só permite se estiver no chão
function pular(entidade) {
  if (!entidade.noChao) return;
  entidade.vy = FISICA.FORCA_PULO;
  entidade.noChao = false;
}
```

### 15.7.3 — Detecção de colisão AABB

**AABB** (*Axis-Aligned Bounding Box*) é o método mais simples e eficiente de detecção de colisão entre retângulos alinhados aos eixos (sem rotação). Dois retângulos se sobrepõem se e somente se há sobreposição em **ambos** os eixos simultaneamente:

```javascript
// Verificar se dois retângulos se sobrepõem
function colidem(a, b) {
  return (
    a.x < b.x + b.largura &&
    a.x + a.largura > b.x &&
    a.y < b.y + b.altura &&
    a.y + a.altura > b.y
  );
}

// Resolver colisão com plataforma — empurra o objeto para fora
// e determina de qual direção a colisão ocorreu
function resolverColisaoPlataforma(jogador, plataforma) {
  if (!colidem(jogador, plataforma)) return false;

  // Calcular profundidade de sobreposição em cada eixo
  const overlapX = Math.min(
    jogador.x + jogador.largura - plataforma.x,
    plataforma.x + plataforma.largura - jogador.x
  );
  const overlapY = Math.min(
    jogador.y + jogador.altura - plataforma.y,
    plataforma.y + plataforma.altura - jogador.y
  );

  // Resolver pelo eixo de menor sobreposição
  if (overlapX < overlapY) {
    // Colisão lateral
    if (jogador.x < plataforma.x) {
      jogador.x = plataforma.x - jogador.largura; // empurra para esquerda
    } else {
      jogador.x = plataforma.x + plataforma.largura; // empurra para direita
    }
    jogador.vx = 0;
  } else {
    // Colisão vertical
    if (jogador.y < plataforma.y) {
      // Veio de cima — pousa no chão
      jogador.y = plataforma.y - jogador.altura;
      jogador.vy = 0;
      jogador.noChao = true;
    } else {
      // Veio de baixo — bate na cabeça
      jogador.y = plataforma.y + plataforma.altura;
      jogador.vy = 0;
    }
  }

  return true;
}
```

### 15.7.4 — Máquina de estados de jogo

Jogos com múltiplas telas (menu, jogo, pausa, game over) se beneficiam de uma **máquina de estados** explícita — evitando condicionais aninhados e tornando as transições previsíveis:

```javascript
// Definição dos estados possíveis
const ESTADOS = {
  MENU:      'menu',
  JOGANDO:   'jogando',
  PAUSADO:   'pausado',
  GAME_OVER: 'game_over',
  VITORIA:   'vitoria',
};

// Máquina de estados
const maquinaEstados = {
  atual: ESTADOS.MENU,

  // Transições válidas
  transicoes: {
    [ESTADOS.MENU]:      [ESTADOS.JOGANDO],
    [ESTADOS.JOGANDO]:   [ESTADOS.PAUSADO, ESTADOS.GAME_OVER, ESTADOS.VITORIA],
    [ESTADOS.PAUSADO]:   [ESTADOS.JOGANDO, ESTADOS.MENU],
    [ESTADOS.GAME_OVER]: [ESTADOS.MENU, ESTADOS.JOGANDO],
    [ESTADOS.VITORIA]:   [ESTADOS.MENU],
  },

  // Callbacks executados ao entrar em cada estado
  aoEntrar: {
    [ESTADOS.MENU]:      () => exibirTela('tela-menu'),
    [ESTADOS.JOGANDO]:   () => { ocultarTodasTelas(); resumirLoop(); },
    [ESTADOS.PAUSADO]:   () => { pausarLoop(); exibirTela('tela-pausa'); },
    [ESTADOS.GAME_OVER]: () => { pausarLoop(); exibirTela('tela-game-over'); },
    [ESTADOS.VITORIA]:   () => { pausarLoop(); exibirTela('tela-vitoria'); },
  },

  // Tentar transição para novo estado
  ir(novoEstado) {
    const transacoesValidas = this.transicoes[this.atual] || [];
    if (!transacoesValidas.includes(novoEstado)) {
      console.warn(`Transição inválida: ${this.atual} → ${novoEstado}`);
      return false;
    }

    this.atual = novoEstado;
    this.aoEntrar[novoEstado]?.();
    return true;
  },

  eh(estado) { return this.atual === estado; },
};

// Uso
maquinaEstados.ir(ESTADOS.JOGANDO);  // menu → jogando ✓
maquinaEstados.ir(ESTADOS.PAUSADO);  // jogando → pausado ✓
maquinaEstados.ir(ESTADOS.VITORIA);  // pausado → vitoria ✗ (inválido)
```

### 15.7.5 — Jogo 4: Plataformer simples

Integrando física, colisão AABB e máquina de estados em um plataformer completo:

> **Imagem sugerida:** captura do jogo em execução mostrando o personagem (quadrado verde com olhos) sobre plataformas coloridas, moedas para coletar, HUD com pontuação e timer, e a tela do nível com fundo degradê.
>
> *(imagem será adicionada posteriormente)*

```html
<div class="jogo-plataformer">
  <div class="hud">
    <span>⭐ <strong id="pf-pontos">0</strong></span>
    <span>❤️ <strong id="pf-vidas">3</strong></span>
    <span>⏱ <strong id="pf-tempo">60</strong></span>
    <span>Nível <strong id="pf-nivel">1</strong></span>
  </div>

  <canvas id="canvas-plataformer" width="600" height="400"
          tabindex="0"
          aria-label="Jogo de plataforma — use setas para mover e espaço para pular">
  </canvas>

  <!-- Telas de estado -->
  <div class="pf-tela" id="tela-menu">
    <h2>🎮 Plataformer</h2>
    <p>Colete todas as moedas antes do tempo acabar!</p>
    <p class="controles">
      ← → Mover &nbsp;|&nbsp; Espaço ou ↑ Pular
    </p>
    <button type="button" id="pf-btn-iniciar">Iniciar</button>
  </div>

  <div class="pf-tela oculto" id="tela-pausa">
    <h2>⏸ Pausado</h2>
    <button type="button" id="pf-btn-retomar">Retomar</button>
    <button type="button" id="pf-btn-menu-pausa">Menu</button>
  </div>

  <div class="pf-tela oculto" id="tela-game-over">
    <h2>💀 Game Over</h2>
    <p>Pontuação: <strong id="pf-pontuacao-final">0</strong></p>
    <button type="button" id="pf-btn-reiniciar">Tentar novamente</button>
  </div>

  <div class="pf-tela oculto" id="tela-vitoria">
    <h2>🏆 Você venceu!</h2>
    <p>Pontuação: <strong id="pf-pontuacao-vitoria">0</strong></p>
    <button type="button" id="pf-btn-proximo">Próximo nível</button>
  </div>
</div>
```

```javascript
// ── Configuração ────────────────────────────────────────────
const canvas = document.querySelector('#canvas-plataformer');
const ctx    = canvas.getContext('2d');

const LARGURA  = canvas.width;
const ALTURA   = canvas.height;

// ── Estado global ───────────────────────────────────────────
let jogador, moedas, plataformas, particulas;
let pontos, vidas, tempo, nivel;
let loopId, timerInterval, ultimoTimestamp;

const teclas = new Set();

// ── Definição dos níveis ────────────────────────────────────
const NIVEIS_CONFIG = [
  {
    cor: '#1a1a2e',
    plataformas: [
      { x: 0,   y: 360, largura: 600, altura: 40  }, // chão
      { x: 80,  y: 280, largura: 120, altura: 16  },
      { x: 280, y: 220, largura: 140, altura: 16  },
      { x: 460, y: 160, largura: 100, altura: 16  },
      { x: 160, y: 140, largura: 100, altura: 16  },
    ],
    moedas: [
      { x: 120, y: 250 }, { x: 160, y: 250 },
      { x: 320, y: 190 }, { x: 360, y: 190 },
      { x: 490, y: 130 }, { x: 190, y: 110 },
      { x: 530, y: 130 },
    ],
    posicaoInicial: { x: 30, y: 300 },
    tempoLimite: 60,
  },
  {
    cor: '#0d1b2a',
    plataformas: [
      { x: 0,   y: 360, largura: 600, altura: 40  },
      { x: 50,  y: 300, largura: 80,  altura: 16  },
      { x: 200, y: 250, largura: 80,  altura: 16  },
      { x: 350, y: 200, largura: 80,  altura: 16  },
      { x: 480, y: 150, largura: 80,  altura: 16  },
      { x: 300, y: 120, largura: 80,  altura: 16  },
      { x: 100, y: 160, largura: 80,  altura: 16  },
    ],
    moedas: [
      { x: 70,  y: 270 }, { x: 220, y: 220 },
      { x: 370, y: 170 }, { x: 500, y: 120 },
      { x: 320, y: 90  }, { x: 120, y: 130 },
      { x: 150, y: 130 },
    ],
    posicaoInicial: { x: 30, y: 310 },
    tempoLimite: 50,
  },
];

// ── Inicialização ───────────────────────────────────────────
function inicializarNivel(n) {
  const cfg = NIVEIS_CONFIG[(n - 1) % NIVEIS_CONFIG.length];

  jogador = criarEntidade(
    cfg.posicaoInicial.x,
    cfg.posicaoInicial.y,
    28, 36
  );

  plataformas = cfg.plataformas.map(p => ({ ...p }));

  moedas = cfg.moedas.map((m, i) => ({
    id: i,
    x: m.x,
    y: m.y,
    raio: 10,
    coletada: false,
    angulo: Math.random() * Math.PI * 2, // para animação
  }));

  particulas = [];
  tempo = cfg.tempoLimite;
  ultimoTimestamp = 0;

  document.getElementById('pf-nivel').textContent = n;
  document.getElementById('pf-tempo').textContent = tempo;
}

// ── Game Loop ───────────────────────────────────────────────
function gameLoop(timestamp) {
  if (!estado.eh(ESTADOS.JOGANDO)) return;

  const dt = ultimoTimestamp ? Math.min(timestamp - ultimoTimestamp, 50) : 16;
  ultimoTimestamp = timestamp;

  procesarInput();
  atualizarFisica(jogador, dt);
  resolverColisoes();
  verificarMoedas();
  atualizarParticulas(dt);
  verificarCondicoes();
  desenhar(timestamp);

  loopId = requestAnimationFrame(gameLoop);
}

function pausarLoop() { cancelAnimationFrame(loopId); }
function resumirLoop() { ultimoTimestamp = 0; loopId = requestAnimationFrame(gameLoop); }

// ── Input ───────────────────────────────────────────────────
canvas.addEventListener('keydown', (e) => {
  teclas.add(e.code);
  e.preventDefault();

  if (e.code === 'KeyP' || e.code === 'Escape') {
    if (estado.eh(ESTADOS.JOGANDO)) estado.ir(ESTADOS.PAUSADO);
    else if (estado.eh(ESTADOS.PAUSADO)) estado.ir(ESTADOS.JOGANDO);
  }
});

canvas.addEventListener('keyup', (e) => teclas.delete(e.code));

function procesarInput() {
  const VELOCIDADE_HORIZONTAL = 200;

  if (teclas.has('ArrowLeft')  || teclas.has('KeyA')) {
    jogador.vx = -VELOCIDADE_HORIZONTAL;
  }
  if (teclas.has('ArrowRight') || teclas.has('KeyD')) {
    jogador.vx =  VELOCIDADE_HORIZONTAL;
  }
  if (
    (teclas.has('ArrowUp') || teclas.has('KeyW') || teclas.has('Space')) &&
    jogador.noChao
  ) {
    pular(jogador);
    criarParticulasPulo();
  }
}

// ── Colisão ─────────────────────────────────────────────────
function resolverColisoes() {
  jogador.noChao = false;

  plataformas.forEach(p => resolverColisaoPlataforma(jogador, p));

  // Limites laterais do canvas
  if (jogador.x < 0) { jogador.x = 0; jogador.vx = 0; }
  if (jogador.x + jogador.largura > LARGURA) {
    jogador.x = LARGURA - jogador.largura;
    jogador.vx = 0;
  }

  // Cair fora do canvas = perder vida
  if (jogador.y > ALTURA + 50) {
    perderVida();
  }
}

function verificarMoedas() {
  moedas.forEach(moeda => {
    if (moeda.coletada) return;

    // Colisão círculo com retângulo (simplificada para quadrado)
    const dx = (jogador.x + jogador.largura  / 2) - moeda.x;
    const dy = (jogador.y + jogador.altura / 2) - moeda.y;
    const distancia = Math.sqrt(dx * dx + dy * dy);

    if (distancia < moeda.raio + 18) {
      moeda.coletada = true;
      pontos += 10;
      criarParticulasMoeda(moeda.x, moeda.y);
      document.getElementById('pf-pontos').textContent = pontos;
    }
  });
}

function verificarCondicoes() {
  // Vitória: todas as moedas coletadas
  if (moedas.every(m => m.coletada)) {
    pontos += tempo * 5; // bônus de tempo
    document.getElementById('pf-pontuacao-vitoria').textContent = pontos;
    estado.ir(ESTADOS.VITORIA);
  }
}

// ── Partículas ──────────────────────────────────────────────
function criarParticulasMoeda(x, y) {
  for (let i = 0; i < 8; i++) {
    const angulo = (i / 8) * Math.PI * 2;
    particulas.push({
      x, y,
      vx: Math.cos(angulo) * (80 + Math.random() * 80),
      vy: Math.sin(angulo) * (80 + Math.random() * 80),
      vida: 1,
      cor: `hsl(${45 + Math.random() * 30}, 100%, 60%)`,
      raio: 3 + Math.random() * 3,
    });
  }
}

function criarParticulasPulo() {
  for (let i = 0; i < 5; i++) {
    particulas.push({
      x: jogador.x + jogador.largura / 2,
      y: jogador.y + jogador.altura,
      vx: (Math.random() - 0.5) * 100,
      vy: 50 + Math.random() * 100,
      vida: 1,
      cor: 'rgba(255,255,255,0.6)',
      raio: 3,
    });
  }
}

function atualizarParticulas(dt) {
  const dt_s = dt / 1000;
  particulas = particulas.filter(p => p.vida > 0);
  particulas.forEach(p => {
    p.x    += p.vx * dt_s;
    p.y    += p.vy * dt_s;
    p.vy   += 400 * dt_s; // gravidade nas partículas
    p.vida -= 2 * dt_s;
  });
}

function perderVida() {
  vidas--;
  document.getElementById('pf-vidas').textContent = vidas;

  if (vidas <= 0) {
    document.getElementById('pf-pontuacao-final').textContent = pontos;
    estado.ir(ESTADOS.GAME_OVER);
    return;
  }

  // Reposicionar jogador
  const cfg = NIVEIS_CONFIG[(nivel - 1) % NIVEIS_CONFIG.length];
  jogador.x  = cfg.posicaoInicial.x;
  jogador.y  = cfg.posicaoInicial.y;
  jogador.vx = 0;
  jogador.vy = 0;
}

// ── Renderização ────────────────────────────────────────────
function desenhar(timestamp) {
  const cfg = NIVEIS_CONFIG[(nivel - 1) % NIVEIS_CONFIG.length];

  // Fundo com gradiente
  const grad = ctx.createLinearGradient(0, 0, 0, ALTURA);
  grad.addColorStop(0, cfg.cor);
  grad.addColorStop(1, '#0a0a1a');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, LARGURA, ALTURA);

  // Plataformas
  plataformas.forEach((p, i) => {
    // Gradiente para cada plataforma
    const pGrad = ctx.createLinearGradient(p.x, p.y, p.x, p.y + p.altura);
    pGrad.addColorStop(0, i === 0 ? '#2d5a27' : '#4a7c59');
    pGrad.addColorStop(1, i === 0 ? '#1a3a15' : '#2d4f38');
    ctx.fillStyle = pGrad;
    ctx.beginPath();
    ctx.roundRect(p.x, p.y, p.largura, p.altura, 4);
    ctx.fill();

    // Brilho no topo
    ctx.fillStyle = 'rgba(255,255,255,0.15)';
    ctx.fillRect(p.x + 2, p.y + 2, p.largura - 4, 3);
  });

  // Moedas (animadas)
  moedas.forEach(moeda => {
    if (moeda.coletada) return;
    moeda.angulo += 0.05;

    // Sombra
    ctx.beginPath();
    ctx.ellipse(moeda.x, moeda.y + 12, moeda.raio * 0.8, 4, 0, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(0,0,0,0.3)';
    ctx.fill();

    // Efeito de achatamento (simula rotação 3D)
    const escalaX = Math.abs(Math.cos(moeda.angulo));
    ctx.save();
    ctx.translate(moeda.x, moeda.y);
    ctx.scale(escalaX + 0.1, 1);

    ctx.beginPath();
    ctx.arc(0, 0, moeda.raio, 0, Math.PI * 2);
    ctx.fillStyle = `hsl(${45 + Math.sin(moeda.angulo * 2) * 10}, 100%, 55%)`;
    ctx.fill();

    // Brilho
    ctx.beginPath();
    ctx.arc(-2, -3, 3, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(255,255,255,0.5)';
    ctx.fill();

    ctx.restore();
  });

  // Partículas
  particulas.forEach(p => {
    ctx.globalAlpha = Math.max(0, p.vida);
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.raio * p.vida, 0, Math.PI * 2);
    ctx.fillStyle = p.cor;
    ctx.fill();
  });
  ctx.globalAlpha = 1;

  // Jogador
  const jx = jogador.x, jy = jogador.y;
  const jl = jogador.largura, ja = jogador.altura;

  // Sombra do jogador
  ctx.beginPath();
  ctx.ellipse(jx + jl / 2, jy + ja + 4, jl * 0.4, 5, 0, 0, Math.PI * 2);
  ctx.fillStyle = 'rgba(0,0,0,0.3)';
  ctx.fill();

  // Corpo
  const corCorpo = jogador.noChao ? '#4CAF50' : '#66BB6A';
  const jGrad = ctx.createLinearGradient(jx, jy, jx + jl, jy + ja);
  jGrad.addColorStop(0, corCorpo);
  jGrad.addColorStop(1, '#2E7D32');
  ctx.fillStyle = jGrad;
  ctx.beginPath();
  ctx.roundRect(jx, jy, jl, ja, 6);
  ctx.fill();

  // Olhos — apontam para a direção do movimento
  const olhoY = jy + ja * 0.3;
  const olhoRaio = 4;
  const pupillaOffset = jogador.vx > 0 ? 1.5 : jogador.vx < 0 ? -1.5 : 0;

  [jx + jl * 0.3, jx + jl * 0.7].forEach(ox => {
    ctx.beginPath();
    ctx.arc(ox, olhoY, olhoRaio, 0, Math.PI * 2);
    ctx.fillStyle = 'white';
    ctx.fill();

    ctx.beginPath();
    ctx.arc(ox + pupillaOffset, olhoY + (jogador.noChao ? 0 : 1), 2, 0, Math.PI * 2);
    ctx.fillStyle = '#1a1a1a';
    ctx.fill();
  });
}

// ── Telas de estado (implementação simplificada) ─────────────
function exibirTela(id) {
  document.querySelectorAll('.pf-tela').forEach(t => t.classList.add('oculto'));
  document.getElementById(id)?.classList.remove('oculto');
}

function ocultarTodasTelas() {
  document.querySelectorAll('.pf-tela').forEach(t => t.classList.add('oculto'));
}

// ── Event listeners de UI ────────────────────────────────────
document.getElementById('pf-btn-iniciar').addEventListener('click', () => {
  pontos = 0;
  vidas  = 3;
  nivel  = 1;
  document.getElementById('pf-pontos').textContent = 0;
  document.getElementById('pf-vidas').textContent  = 3;
  inicializarNivel(nivel);
  estado.ir(ESTADOS.JOGANDO);
  canvas.focus();

  // Timer
  clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    if (!estado.eh(ESTADOS.JOGANDO)) return;
    tempo--;
    document.getElementById('pf-tempo').textContent = tempo;
    if (tempo <= 0) {
      clearInterval(timerInterval);
      document.getElementById('pf-pontuacao-final').textContent = pontos;
      estado.ir(ESTADOS.GAME_OVER);
    }
  }, 1000);
});

document.getElementById('pf-btn-retomar')?.addEventListener('click', () => {
  estado.ir(ESTADOS.JOGANDO);
  canvas.focus();
});

document.getElementById('pf-btn-menu-pausa')?.addEventListener('click', () => {
  clearInterval(timerInterval);
  estado.ir(ESTADOS.MENU);
});

document.getElementById('pf-btn-reiniciar')?.addEventListener('click', () => {
  document.getElementById('pf-btn-iniciar').click();
});

document.getElementById('pf-btn-proximo')?.addEventListener('click', () => {
  nivel++;
  if (nivel > NIVEIS_CONFIG.length) {
    nivel = 1; // reinicia os níveis
  }
  inicializarNivel(nivel);
  estado.ir(ESTADOS.JOGANDO);
  canvas.focus();

  clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    if (!estado.eh(ESTADOS.JOGANDO)) return;
    tempo--;
    document.getElementById('pf-tempo').textContent = tempo;
    if (tempo <= 0) {
      clearInterval(timerInterval);
      document.getElementById('pf-pontuacao-final').textContent = pontos;
      estado.ir(ESTADOS.GAME_OVER);
    }
  }, 1000);
});

// ── Inicializar o jogo ───────────────────────────────────────
// Desenhar tela de título antes de qualquer interação
(function desenharTelaInicial() {
  const grad = ctx.createLinearGradient(0, 0, 0, ALTURA);
  grad.addColorStop(0, '#1a1a2e');
  grad.addColorStop(1, '#0a0a1a');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, LARGURA, ALTURA);

  ctx.fillStyle = 'rgba(255,255,255,0.05)';
  for (let i = 0; i < 50; i++) {
    ctx.beginPath();
    ctx.arc(
      Math.random() * LARGURA,
      Math.random() * ALTURA,
      Math.random() * 2,
      0, Math.PI * 2
    );
    ctx.fill();
  }
})();
```

### 15.7.6 — Persistência de recordes com `localStorage`

```javascript
// Sistema de recordes por nível
const Recordes = {
  obter(nivel) {
    const dados = JSON.parse(localStorage.getItem('pf-recordes') || '{}');
    return dados[nivel] || 0;
  },

  salvar(nivel, pontuacao) {
    const dados = JSON.parse(localStorage.getItem('pf-recordes') || '{}');
    if (pontuacao > (dados[nivel] || 0)) {
      dados[nivel] = pontuacao;
      localStorage.setItem('pf-recordes', JSON.stringify(dados));
      return true; // novo recorde
    }
    return false;
  },

  listar() {
    return JSON.parse(localStorage.getItem('pf-recordes') || '{}');
  },

  limpar() {
    localStorage.removeItem('pf-recordes');
  }
};

// Integração com a tela de game over e vitória
function verificarRecorde(pontuacaoFinal) {
  const novoRecorde = Recordes.salvar(nivel, pontuacaoFinal);
  const recordeAtual = Recordes.obter(nivel);

  if (novoRecorde) {
    return `🏆 Novo recorde! ${recordeAtual} pontos`;
  }
  return `Recorde do nível ${nivel}: ${recordeAtual} pontos`;
}
```

### 15.7.7 — Desafios de extensão

Para praticar de forma autônoma, experimente estender o plataformer com:

1. **Inimigos patrulheiros:** um inimigo que se move entre dois pontos e reinicia o nível ao tocar o jogador
2. **Plataformas móveis:** plataformas que se movem horizontalmente, alterando a dificuldade
3. **Power-ups:** itens especiais que dobram os pontos por 10 segundos ou tornam o jogador invulnerável
4. **Efeitos sonoros:** usar a Web Audio API para gerar sons proceduralmente (sem arquivos externos) ao pular e coletar moedas
5. **Parallax scrolling:** fundo com camadas que se movem em velocidades diferentes para criar profundidade

---

**Referências:**
- [MDN — Pointer Events](https://developer.mozilla.org/pt-BR/docs/Web/API/Pointer_events)
- [MDN — HTML Drag and Drop API](https://developer.mozilla.org/pt-BR/docs/Web/API/HTML_Drag_and_Drop_API)
- [MDN — Constraint Validation](https://developer.mozilla.org/en-US/docs/Web/HTML/Constraint_validation)
- [W3C — WAI-ARIA Authoring Practices — Dialog Modal](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)
- [W3C — WAI-ARIA Authoring Practices — Tabs](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/)
- [W3C — WAI-ARIA Authoring Practices — Accordion](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/)

---

#### **Atividades — Capítulo 15**

<div class="quiz" data-answer="c">
  <p><strong>1.</strong> Qual é a ordem correta das fases de propagação de eventos no DOM?</p>
  <button data-option="a">Alvo → Borbulhamento → Captura</button>
  <button data-option="b">Borbulhamento → Alvo → Captura</button>
  <button data-option="c">Captura → Alvo → Borbulhamento</button>
  <button data-option="d">Captura → Borbulhamento → Alvo</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="b">
  <p><strong>2.</strong> Por que é preferível usar <code>e.code</code> em vez de <code>e.key</code> para atalhos de teclado em jogos?</p>
  <button data-option="a">Porque <code>e.key</code> é depreciado no HTML5.</button>
  <button data-option="b">Porque <code>e.code</code> identifica a posição física da tecla independentemente do layout do teclado, garantindo que o atalho funcione igual em teclados QWERTY, AZERTY e outros layouts internacionais.</button>
  <button data-option="c">Porque <code>e.code</code> tem melhor desempenho que <code>e.key</code>.</button>
  <button data-option="d">Não há diferença — ambos retornam o mesmo valor.</button>
  <p class="feedback"></p>
</div>

<div class="quiz" data-answer="d">
  <p><strong>3.</strong> O que é detecção de colisão AABB e por que ela é adequada para jogos 2D simples?</p>
  <button data-option="a">AABB é uma técnica que usa o Canvas para detectar sobreposição de pixels entre sprites.</button>
  <button data-option="b">AABB detecta colisão entre círculos usando a distância entre seus centros.</button>
  <button data-option="c">AABB é uma forma de detecção de colisão que usa raios para verificar intersecções.</button>
  <button data-option="d">AABB verifica sobreposição entre retângulos alinhados aos eixos comparando suas coordenadas em X e Y. É adequada para jogos 2D simples por ser computacionalmente barata e suficientemente precisa para objetos retangulares sem rotação.</button>
  <p class="feedback"></p>
</div>

- **GitHub Classroom — Projeto principal:** Implementar o formulário de cadastro completo da seção 15.6 com: validação de todos os tipos de componentes (text, email, password, tel, date, select, radio, checkbox, textarea, file), mensagens de erro acessíveis com ARIA, modal de confirmação com gestão de foco e feedback visual de sucesso. *(link será adicionado)*

- **GitHub Classroom — Desafio de jogos (opcional):** Estender o plataformer da seção 15.7 adicionando pelo menos dois dos seguintes: inimigos patrulheiros, plataformas móveis, power-ups ou efeitos sonoros com Web Audio API. *(link será adicionado)*

---

[:material-arrow-left: Voltar ao Capítulo 14 — Manipulação do DOM](14-dom.md)
[:material-arrow-right: Ir ao Capítulo 16 — Consumo de APIs](16-apis.md)
