#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Arquiva os repositórios de uma turma ao fim do semestre.
#
#   ./arquivar-turma.sh <turma.conf> [--executar]
#   ex.: ./arquivar-turma.sh turmas/pweb1-2026.1-911a.conf
#
# Sem --executar, apenas LISTA o que seria arquivado (simulação).
#
# Arquivar deixa o repositório somente-leitura: some da lista de repos ativos,
# o aluno mantém o acesso de leitura (portfólio) e nada é apagado. É reversível.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

CONF="${1:?uso: arquivar-turma.sh <turma.conf> [--executar]}"
EXECUTAR="${2:-}"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/convencao.sh
source "$RAIZ/lib/convencao.sh"
carregar_turma "$CONF"

PREFIXO=$(prefixo_turma)
echo "▸ Turma   : $DISCIPLINA $PERIODO/$TURMA"
echo "▸ Prefixo : $PREFIXO"

# Lista os repositórios ativos da turma (portátil: sem mapfile)
REPOS=()
while IFS= read -r nome; do
  [ -n "$nome" ] && REPOS+=("$nome")
done < <(gh repo list "$ORG" --limit 1000 --no-archived --json name \
           --jq ".[] | select(.name | startswith(\"$PREFIXO\")) | .name")

if [[ ${#REPOS[@]} -eq 0 ]]; then
  echo "Nenhum repositório ativo com esse prefixo."; exit 0
fi

echo "▸ Encontrados: ${#REPOS[@]}"
printf '   %s\n' "${REPOS[@]}" | head -10
[[ ${#REPOS[@]} -gt 10 ]] && echo "   … e mais $(( ${#REPOS[@]} - 10 ))"

if [[ "$EXECUTAR" != "--executar" ]]; then
  echo
  echo "(simulação — nada foi alterado). Para arquivar de fato:"
  echo "  $0 $CONF --executar"
  exit 0
fi

read -rp "Arquivar ${#REPOS[@]} repositórios? [s/N] " ok
[[ "$ok" =~ ^[sS]$ ]] || { echo "cancelado."; exit 0; }

for NOME in "${REPOS[@]}"; do
  if gh repo archive "$ORG/$NOME" --yes >/dev/null 2>&1; then
    echo "✔ $NOME arquivado"
  else
    echo "⚠ $NOME — falha ao arquivar"
  fi
done
