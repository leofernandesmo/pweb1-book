#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Instala o corretor deste repositório como autograder de um exercício no
# repositório de configuração do Classroom 50.
#
#   ./instalar-autograder-c50.sh <slug> <repo-de-config> <classroom>
#   ex.: ./instalar-autograder-c50.sh 01-cartao-curso ~/classroom50 pweb1
#
# O Classroom 50 busca a lógica de correção do repo de config em tempo de
# execução — por isso o corretor NÃO fica no repositório do aluno (e não pode
# ser adulterado por ele).
#
# Layout resultante:
#   <repo-de-config>/<classroom>/autograders/<slug>/
#     ├── autograder.py     ponto de entrada chamado pelo Classroom 50
#     ├── avaliar.mjs       as verificações do exercício
#     ├── lib/avaliador.js  o mini-framework de correção
#     └── package.json      dependência do Playwright
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: instalar-autograder-c50.sh <slug> <repo-de-config> <classroom>}"
CONFIG="${2:?informe o caminho do repositório de config do Classroom 50}"
CLASSROOM="${3:?informe o slug da turma (classroom)}"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXERCICIO="$RAIZ/$SLUG"
[[ -d "$EXERCICIO" ]] || { echo "✖ exercício não encontrado: $EXERCICIO"; exit 1; }
[[ -d "$CONFIG" ]]    || { echo "✖ repo de config não encontrado: $CONFIG"; exit 1; }

DESTINO="$CONFIG/$CLASSROOM/autograders/$SLUG"
TITULO=$(node -p "require('$EXERCICIO/meta.json').titulo")

echo "▸ Exercício : $TITULO"
echo "▸ Destino   : $DESTINO"
mkdir -p "$DESTINO/lib"

# 1. ponto de entrada esperado pelo Classroom 50
cp "$RAIZ/classroom50/autograder.py" "$DESTINO/autograder.py"

# 2. corretor (fonte única: o mesmo usado no npm test e no coletar-notas.sh)
cp "$EXERCICIO/avaliar.mjs" "$DESTINO/avaliar.mjs"
cp "$RAIZ/lib/avaliador.js" "$DESTINO/lib/avaliador.js"
# no repo de config o avaliador fica ao lado, não um nível acima
sed -i.bak 's|"../lib/avaliador.js"|"./lib/avaliador.js"|' "$DESTINO/avaliar.mjs"
rm -f "$DESTINO/avaliar.mjs.bak"

# 3. dependência do corretor
cat > "$DESTINO/package.json" <<JSON
{
  "name": "autograder-$SLUG",
  "private": true,
  "type": "module",
  "dependencies": { "playwright": "^1.49.0" }
}
JSON

echo "✔ Autograder instalado."
echo
echo "Próximos passos:"
echo "  cd $CONFIG"
echo "  git add $CLASSROOM/autograders/$SLUG"
echo "  git commit -m 'Autograder: $TITULO'"
echo "  git push"
