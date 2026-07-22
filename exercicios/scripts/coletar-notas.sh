#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Coleta as entregas e gera as notas OFICIAIS.
#
#   ./coletar-notas.sh <slug> <turma.conf> [saida.csv]
#   ex.: ./coletar-notas.sh 01-cartao-curso turmas/pweb1-2026.1-911a.conf
#
# O corretor que roda aqui é o CANÔNICO deste repositório — o que estiver no
# repo do aluno é ignorado. Editar o corretor da própria entrega não muda a nota.
# A execução no Actions serve como feedback rápido; esta é a nota que vale.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: coletar-notas.sh <slug> <turma.conf> [saida.csv]}"
CONF="${2:?informe o arquivo de configuração da turma}"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/convencao.sh
source "$RAIZ/lib/convencao.sh"
carregar_turma "$CONF"

EXERCICIO="$RAIZ/$SLUG"
[[ -d "$EXERCICIO" ]] || { echo "✖ exercício não encontrado: $EXERCICIO"; exit 1; }
CURTO=$(nome_curto_exercicio "$EXERCICIO")
SAIDA="${3:-notas-$DISCIPLINA-$PERIODO-$TURMA-$CURTO.csv}"
ler_alunos

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

echo "aluno,nota,pontos,total,ultimo_commit" > "$SAIDA"
echo "▸ Turma: $DISCIPLINA $PERIODO/$TURMA — corrigindo ${#ALUNOS_LISTA[@]} entregas de $CURTO"

for ALUNO in "${ALUNOS_LISTA[@]}"; do
  REPO=$(repo_aluno "$CURTO" "$ALUNO")
  DEST="$TMP/$ALUNO"

  if ! gh repo clone "$REPO" "$DEST" -- -q --depth 1 &>/dev/null; then
    echo "$ALUNO,,,,sem-repositorio" >> "$SAIDA"
    echo "• @$ALUNO — sem repositório"
    continue
  fi

  COMMIT=$(git -C "$DEST" log -1 --format=%cI 2>/dev/null || echo "")

  # Subshell com cd faz o nota.json cair em $TMP (e não no diretório atual).
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
