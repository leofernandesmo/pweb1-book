#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Coleta as entregas e gera as notas OFICIAIS.
#
#   ./coletar-notas.sh <slug> <org> <alunos.txt> [saida.csv]
#
# Importante: o corretor que roda aqui é o CANÔNICO deste repositório — o que
# estiver no repo do aluno é ignorado. Assim, editar o corretor da própria
# entrega não altera a nota. A execução no Actions serve como feedback rápido;
# esta é a nota que vale.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: coletar-notas.sh <slug> <org> <alunos.txt> [saida.csv]}"
ORG="${2:?informe a organização}"
LISTA="${3:?informe o arquivo com os usuários}"
SAIDA="${4:-notas-$SLUG.csv}"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXERCICIO="$RAIZ/$SLUG"
[[ -d "$EXERCICIO" ]] || { echo "✖ exercício não encontrado: $EXERCICIO"; exit 1; }

# Leitura portátil (mapfile só existe no bash 4+; o /bin/bash do macOS é 3.2)
ALUNOS=()
while IFS= read -r usuario; do
  [ -n "$usuario" ] && ALUNOS+=("$usuario")
done < <(grep -vE '^[[:space:]]*(#|$)' "$LISTA" | tr -d '\r' | awk '{print $1}')

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

echo "aluno,nota,pontos,total,ultimo_commit" > "$SAIDA"
echo "▸ Corrigindo ${#ALUNOS[@]} entregas de $SLUG…"

for ALUNO in "${ALUNOS[@]}"; do
  REPO="$ORG/$SLUG-$ALUNO"
  DEST="$TMP/$ALUNO"

  if ! gh repo clone "$REPO" "$DEST" -- -q --depth 1 &>/dev/null; then
    echo "$ALUNO,,,,sem-repositorio" >> "$SAIDA"
    echo "• @$ALUNO — sem repositório"
    continue
  fi

  COMMIT=$(git -C "$DEST" log -1 --format=%cI 2>/dev/null || echo "")

  # Roda o corretor canônico contra a pasta entregue.
  # O subshell com cd faz o nota.json cair em $TMP (e não no diretório atual).
  ( cd "$TMP" && node "$EXERCICIO/avaliar.mjs" "$DEST" ) >"$TMP/$ALUNO.log" 2>&1 || true

  if [[ -f "$TMP/nota.json" ]]; then
    read -r NOTA PONTOS TOTAL < <(node -p "
      const n=require('$TMP/nota.json'); n.nota+' '+n.obtido+' '+n.total")
    echo "$ALUNO,$NOTA,$PONTOS,$TOTAL,$COMMIT" >> "$SAIDA"
    printf '✔ @%-20s %3s/100\n' "$ALUNO" "$NOTA"
    rm -f "$TMP/nota.json"
  else
    echo "$ALUNO,0,0,0,$COMMIT" >> "$SAIDA"
    echo "⚠ @$ALUNO — correção falhou (ver $TMP/$ALUNO.log)"
  fi
done

echo "▸ Notas gravadas em: $SAIDA"
