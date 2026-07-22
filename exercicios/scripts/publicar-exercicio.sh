#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Monta e publica o repositório-TEMPLATE de um exercício no GitHub.
#
#   ./publicar-exercicio.sh <slug> <turma.conf>
#   ex.: ./publicar-exercicio.sh 01-cartao-curso turmas/pweb1-2026.1-911a.conf
#
# O template não depende de período/turma — o nome é:
#   <disciplina>-<nomeCurto>-template   (ex.: pweb1-cartao-curso-template)
# Ele é reutilizado por todas as turmas e semestres da disciplina.
#
# Conteúdo: arquivos iniciais do aluno + enunciado (README) + corretor +
# workflow de correção automática.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: publicar-exercicio.sh <slug> <turma.conf>}"
CONF="${2:?informe o arquivo de configuração da turma}"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/convencao.sh
source "$RAIZ/lib/convencao.sh"
carregar_turma "$CONF"

EXERCICIO="$RAIZ/$SLUG"
[[ -d "$EXERCICIO" ]] || { echo "✖ exercício não encontrado: $EXERCICIO"; exit 1; }

CURTO=$(nome_curto_exercicio "$EXERCICIO")
TITULO=$(node -p "require('$EXERCICIO/meta.json').titulo")
REPO=$(repo_template "$CURTO")

echo "▸ Exercício    : $TITULO"
echo "▸ Template     : $REPO"
echo "▸ Visibilidade : $VISIBILIDADE"
read -rp "Criar/atualizar esse repositório no GitHub? [s/N] " ok
[[ "$ok" =~ ^[sS]$ ]] || { echo "cancelado."; exit 0; }

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

# 1. arquivos iniciais do aluno
cp -R "$EXERCICIO/starter/." "$TMP/"
# 2. enunciado vira o README do repositório
cp "$EXERCICIO/enunciado.md" "$TMP/README.md"
# 3. corretor (o aluno roda `npm test` antes de entregar)
cp "$EXERCICIO/avaliar.mjs" "$TMP/avaliar.mjs"
mkdir -p "$TMP/lib" && cp "$RAIZ/lib/avaliador.js" "$TMP/lib/"
sed -i.bak 's|"../lib/avaliador.js"|"./lib/avaliador.js"|' "$TMP/avaliar.mjs" && rm -f "$TMP/avaliar.mjs.bak"
# 4. workflow de correção automática
mkdir -p "$TMP/.github/workflows"
cp "$RAIZ/lib/template-workflow.yml" "$TMP/.github/workflows/correcao.yml"
# 5. package.json do aluno
cat > "$TMP/package.json" <<JSON
{
  "name": "$CURTO",
  "private": true,
  "type": "module",
  "scripts": { "test": "node avaliar.mjs ." },
  "devDependencies": { "playwright": "^1.49.0" }
}
JSON

( cd "$TMP"
  git init -q -b main
  git add .
  git -c user.email=noreply@ifal.edu.br -c user.name="$DISCIPLINA" \
      commit -qm "Exercício: $TITULO"
  gh repo create "$REPO" "$FLAG_VISIBILIDADE" --source=. --push \
     --description "$TITULO — $DISCIPLINA"
)

gh repo edit "$REPO" --template 2>/dev/null || echo "  (marque como template manualmente se necessário)"
echo "✔ Publicado: https://github.com/$REPO"
