# Exercício 1 — Cartão de curso interativo

**Vale 100 pontos** · Correção automática a cada `git push`.

Você vai construir um **cartão de curso** que junta as três camadas da Web: estrutura
(HTML), apresentação (CSS) e comportamento (JavaScript).

## O que entregar

Edite apenas estes três arquivos (já existem no repositório):

```
index.html
css/style.css
js/script.js
```

## Requisitos

### 1. Estrutura (HTML semântico) — 36 pontos

- [ ] O `<html>` declara o idioma: `lang="pt-BR"` **(6 pts)**
- [ ] A página tem **exatamente um** `<h1>` **(6 pts)**
- [ ] O conteúdo principal está dentro de um `<main>` **(6 pts)**
- [ ] O cartão é um `<article>` com a classe `card` **(8 pts)**
- [ ] Dentro do cartão há uma `<img>` com atributo `alt` **descritivo e não vazio** **(10 pts)**

### 2. Apresentação (CSS) — 32 pontos

- [ ] O `.card` tem **cor de fundo** própria (diferente do padrão da página) **(10 pts)**
- [ ] O `.card` tem **cantos arredondados** (`border-radius` maior que zero) **(6 pts)**
- [ ] O `.card` tem **espaçamento interno** (`padding` maior que zero) **(6 pts)**
- [ ] O botão `#favoritar` tem cor de fundo própria e cor de texto definida **(10 pts)**

### 3. Comportamento (JavaScript) — 32 pontos

- [ ] O botão começa com `aria-pressed="false"` **(6 pts)**
- [ ] Ao **clicar**, o `aria-pressed` passa para `"true"` **(12 pts)**
- [ ] Ao **clicar**, o cartão recebe a classe `favorito` **(12 pts)**
- [ ] O JavaScript roda **sem erros** no console **(2 pts)**

> 💡 O `aria-pressed` é o que comunica o estado do botão a leitores de tela — é
> acessibilidade, não enfeite (capítulo 6).

## Como testar antes de entregar

```bash
npm install
npm test
```

Você verá o mesmo relatório que a correção automática vai gerar, item por item.

## Como entregar

```bash
git add .
git commit -m "Resolve o exercício do cartão de curso"
git push
```

Ao terminar o push, abra a aba **Actions** do seu repositório: a correção roda sozinha e
mostra sua **nota de 0 a 100** com o detalhe de cada item.
