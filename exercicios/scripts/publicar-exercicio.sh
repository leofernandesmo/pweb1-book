#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Monta e publica o repositório-TEMPLATE de um exercício no GitHub.
#
#   ./publicar-exercicio.sh <slug> <org> [--publico]
#   ex.: ./publicar-exercicio.sh 01-cartao-curso engsoft-ifal
#
# O template contém: arquivos iniciais do aluno + enunciado (README) +
# corretor + workflow de correção automática.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: publicar-exercicio.sh <slug> <org> [--publico]}"
ORG="${2:?informe a organização do GitHub}"
VISIBILIDADE="--private"
[[ "${3:-}" == "--publico" ]] && VISIBILIDADE="--public"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXERCICIO="$RAIZ/$SLUG"
[[ -d "$EXERCICIO" ]] || { echo "✖ exercício não encontrado: $EXERCICIO"; exit 1; }

TITULO=$(node -p "require('$EXERCICIO/meta.json').titulo")
REPO="$ORG/$SLUG-template"

echo "▸ Exercício : $TITULO"
echo "▸ Template  : $REPO ($([[ $VISIBILIDADE == --public ]] && echo público || echo privado))"
read -rp "Criar/atualizar esse repositório no GitHub? [s/N] " ok
[[ "$ok" =~ ^[sS]$ ]] || { echo "cancelado."; exit 0; }

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

# 1. arquivos iniciais do aluno
cp -R "$EXERCICIO/starter/." "$TMP/"
# 2. enunciado vira o README do repositório
cp "$EXERCICIO/enunciado.md" "$TMP/README.md"
# 3. corretor (o aluno pode rodar com `npm test` antes de entregar)
cp "$EXERCICIO/avaliar.mjs" "$TMP/avaliar.mjs"
mkdir -p "$TMP/lib" && cp "$RAIZ/lib/avaliador.js" "$TMP/lib/"
sed -i.bak 's|"../lib/avaliador.js"|"./lib/avaliador.js"|' "$TMP/avaliar.mjs" && rm -f "$TMP/avaliar.mjs.bak"
# 4. workflow de correção automática
mkdir -p "$TMP/.github/workflows"
cp "$RAIZ/lib/template-workflow.yml" "$TMP/.github/workflows/correcao.yml"
# 5. package.json do aluno
cat > "$TMP/package.json" <<JSON
{
  "name": "$SLUG",
  "private": true,
  "type": "module",
  "scripts": { "test": "node avaliar.mjs ." },
  "devDependencies": { "playwright": "^1.49.0" }
}
JSON

( cd "$TMP"
  git init -q -b main
  git add .
  git -c user.email=noreply@ifal.edu.br -c user.name="PWeb1" \
      commit -qm "Exercício: $TITULO"
  gh repo create "$REPO" $VISIBILIDADE --source=. --push --description "$TITULO — Programação Web 1"
)

gh repo edit "$REPO" --template 2>/dev/null || echo "  (marque como template manualmente se necessário)"
echo "✔ Publicado: https://github.com/$REPO"
