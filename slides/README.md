# Slides (Reveal.js)

Slides de aula da disciplina **Programação Web 1** (Técnico em Desenvolvimento de Sistemas,
IFAL), em HTML/CSS/JS com [Reveal.js](https://revealjs.com). O Reveal está **embutido** em
`assets/reveal/` — não depende de internet, pode apresentar offline em sala.

Seguem o padrão visual **Presentation Zen**: fundo escuro, tipografia grande, uma ideia por
slide, pouco texto e notas do apresentador.

## Estrutura

```
slides/
  index.html              # página inicial com a lista de decks
  README.md               # este arquivo
  assets/
    reveal/               # Reveal.js 5.1 (vendorizado: dist + plugins notes/highlight)
    css/course-theme.css  # identidade visual do curso (indigo/lavanda/âmbar)
  unidade-0/index.html    # deck da Unidade 0 (um deck por unidade temática)
  ...
```

Um deck por **unidade temática** (não por capítulo):

| Unidade | Capítulos do livro |
|---------|--------------------|
| 0 — Fundamentos da Web | 0, 1 |
| 1 — HTML | 2, 3, 4, 5, 6 |
| 2 — CSS | 7, 8, 9, 10, 11, 12 |
| 3 — JavaScript | 13, 14, 15, 16 |
| 4 — Integração e Projeto | 17, 18 |

## Como apresentar

Abra o `index.html` do deck no navegador. Navegação:

- **Setas** / **Espaço** — avançar e voltar
- **Esc** ou **O** — visão geral (grade de slides)
- **S** — modo apresentador (notas + cronômetro)
- **F** — tela cheia
- **B** ou **.** — escurecer a tela (pausa)

Alguns decks têm slides **verticais** (aprofundamentos): use as setas para baixo.

## Publicação

O workflow do GitHub Actions copia esta pasta para `site/slides/` ao publicar, ficando
acessível em `https://leofernandesmo.github.io/pweb1-book/slides/`.

## Demos "código + resultado no navegador"

Para mostrar um trecho de código e o resultado renderizado lado a lado (ideal para HTML e
CSS), use o componente `.demo`. Inclua o script **antes** de `Reveal.initialize()`:

```html
<script src="../assets/js/code-demo.js"></script>
```

E no slide:

```html
<div class="demo" data-lang="html" data-altura="280px">
  <script type="text/plain">
    <style> .btn { background: #5C6BC0; color: #fff; padding: .5em 1em } </style>
    <button class="btn">Enviar</button>
  </script>
</div>
```

O helper lê o código (fonte única de verdade), mostra-o com realce à esquerda e renderiza
**exatamente o mesmo código** num `<iframe>` com moldura de navegador à direita — funciona
offline. Atributos: `data-lang` (`html`/`css`/`js`), `data-altura` (altura do resultado) e
`data-scripts`/`data-lang="js"` para habilitar JavaScript no iframe (demos interativas).

## Criar um novo deck

Copie `unidade-0/index.html` para uma nova pasta `unidade-N/` e edite o conteúdo. Os caminhos
`../assets/...` continuam válidos por estar um nível abaixo de `slides/`. Notas do apresentador:

```html
<aside class="notes">Texto que só aparece no modo apresentador (tecla S).</aside>
```
