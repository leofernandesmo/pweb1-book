# Exercícios com correção automática — Programação Web 1

Sistema de exercícios em que o aluno recebe um repositório, resolve, dá `git push` e
**recebe a nota automaticamente**. Não depende do GitHub Classroom.

> ⚠️ **O GitHub Classroom será desligado em 28/08/2026** (dados apagados em 04/09/2026).
> Este sistema foi construído para ser independente de plataforma: usa apenas
> **repositórios do GitHub + GitHub Actions + `gh` CLI**.

## Como funciona

```
exercicios/<slug>/           script publicar-exercicio.sh        script criar-repos-alunos.sh
  starter/  ───────────────►  repositório-TEMPLATE no GitHub ───►  um repo por aluno
  enunciado.md                (enunciado + starter + corretor)      │
  avaliar.mjs                                                       │ git push
  solucao/                                                          ▼
                                                        GitHub Actions corrige e
                                                        publica a nota no resumo
                                                                    │
                              script coletar-notas.sh ◄─────────────┘
                                     │
                                     ▼  notas-<slug>.csv (nota oficial)
```

## Estrutura

```
exercicios/
├── lib/
│   ├── avaliador.js           # mini-framework de correção (servidor + Playwright + pontuação)
│   └── template-workflow.yml  # workflow de correção que vai para o repo do aluno
├── scripts/
│   ├── publicar-exercicio.sh  # cria o repositório-template no GitHub
│   ├── criar-repos-alunos.sh  # cria um repo por aluno a partir do template
│   └── coletar-notas.sh       # corrige as entregas e gera o CSV de notas
└── 01-cartao-curso/           # um exercício
    ├── meta.json              # título, unidade, pontuação
    ├── enunciado.md           # vira o README do repo do aluno
    ├── starter/               # arquivos entregues ao aluno (com TODOs)
    ├── solucao/               # gabarito (NÃO vai para o aluno)
    └── avaliar.mjs            # as verificações com pontuação
```

## O que a correção verifica

Tudo roda num **navegador real** (Playwright), então testamos a página como ela de fato
renderiza — não o texto do código:

| Camada | Como é verificado |
|---|---|
| **HTML semântico** | consultas ao DOM real (`<main>`, `<article class="card">`, `alt` da imagem…) |
| **CSS aplicado** | `getComputedStyle` — cor de fundo, `border-radius`, `padding` de verdade |
| **JavaScript** | interação real: clicar no botão e conferir `aria-pressed` e classes |

## Uso

### 1. Testar o exercício localmente

```bash
cd exercicios
npm install && npx playwright install chromium
npm test              # corretor contra a solução  → deve dar 100/100
npm run test:starter  # corretor contra o starter  → deve dar nota baixa
```

Sempre rode os dois ao criar um exercício: é o que garante que o corretor **discrimina**.

### 2. Publicar o template no GitHub

```bash
./scripts/publicar-exercicio.sh 01-cartao-curso engsoft-ifal
```

### 3. Criar os repositórios dos alunos

Monte um `alunos.txt` com um usuário do GitHub por linha:

```
# turma 911A
fulano-silva
ciclana-souza
```

```bash
./scripts/criar-repos-alunos.sh 01-cartao-curso engsoft-ifal alunos.txt
```

### 4. Coletar as notas

```bash
./scripts/coletar-notas.sh 01-cartao-curso engsoft-ifal alunos.txt
# → notas-01-cartao-curso.csv
```

## Integridade da nota

O aluno recebe o corretor no próprio repositório para poder rodar `npm test` e iterar —
isso é ótimo pedagogicamente, mas significa que ele **poderia** editá-lo.

Por isso há duas execuções com papéis diferentes:

- **No Actions do aluno** → *feedback* imediato a cada push.
- **No `coletar-notas.sh`** → **nota oficial**. O script clona a entrega e roda o corretor
  **canônico deste repositório**, ignorando o que estiver no repo do aluno. Editar o
  próprio corretor não muda a nota.

## Criar um novo exercício

1. Copie `01-cartao-curso/` para `NN-novo-exercicio/`.
2. Ajuste `meta.json`, `enunciado.md`, `starter/` e `solucao/`.
3. Escreva as verificações em `avaliar.mjs` (cada uma com `nome`, `pontos` e `executar`).
4. Rode `npm test` e `npm run test:starter` para conferir os dois extremos.
5. Publique com `scripts/publicar-exercicio.sh`.

Helpers disponíveis em `lib/avaliador.js`: `exigir(condicao, mensagem)` e
`exigirElemento(pagina, seletor, descricao)` — este último falha rápido e com mensagem
amigável quando o elemento não existe.
