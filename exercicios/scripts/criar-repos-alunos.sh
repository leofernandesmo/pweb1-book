#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Cria um repositório por aluno a partir do template do exercício.
# Substitui o "aceitar a atividade" do GitHub Classroom.
#
#   ./criar-repos-alunos.sh <slug> <org> <alunos.txt>
#
# alunos.txt: um usuário do GitHub por linha (linhas com # são ignoradas).
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: criar-repos-alunos.sh <slug> <org> <alunos.txt>}"
ORG="${2:?informe a organização}"
LISTA="${3:?informe o arquivo com os usuários}"
[[ -f "$LISTA" ]] || { echo "✖ lista não encontrada: $LISTA"; exit 1; }

TEMPLATE="$ORG/$SLUG-template"

# Leitura portátil (mapfile só existe no bash 4+; o /bin/bash do macOS é 3.2)
ALUNOS=()
while IFS= read -r usuario; do
  [ -n "$usuario" ] && ALUNOS+=("$usuario")
done < <(grep -vE '^[[:space:]]*(#|$)' "$LISTA" | tr -d '\r' | awk '{print $1}')

echo "▸ Template : $TEMPLATE"
echo "▸ Alunos   : ${#ALUNOS[@]}"
read -rp "Criar ${#ALUNOS[@]} repositórios em $ORG? [s/N] " ok
[[ "$ok" =~ ^[sS]$ ]] || { echo "cancelado."; exit 0; }

for ALUNO in "${ALUNOS[@]}"; do
  REPO="$ORG/$SLUG-$ALUNO"
  if gh repo view "$REPO" &>/dev/null; then
    echo "• $REPO — já existe, pulando"
    continue
  fi
  gh repo create "$REPO" --private --template "$TEMPLATE" \
     --description "$SLUG — $ALUNO" >/dev/null
  # dá acesso de escrita só ao próprio aluno
  gh api -X PUT "repos/$REPO/collaborators/$ALUNO" -f permission=push >/dev/null \
    && echo "✔ $REPO — criado e liberado para @$ALUNO" \
    || echo "⚠ $REPO — criado, mas falhou ao convidar @$ALUNO (usuário existe?)"
done
