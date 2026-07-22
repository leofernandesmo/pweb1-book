#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Cria um repositório por aluno a partir do template do exercício.
#
#   ./criar-repos-alunos.sh <slug> <turma.conf>
#   ex.: ./criar-repos-alunos.sh 01-cartao-curso turmas/pweb1-2026.1-911a.conf
#
# Nomes seguem a convenção de lib/convencao.sh:
#   pweb1-2026.1-911a-cartao-curso-fulanodasilva
#
# Acesso (importante):
#   • cada aluno recebe push APENAS no próprio repositório;
#   • o Time da turma NÃO recebe acesso aos repositórios individuais — isso
#     exporia a solução de um aluno aos demais. O Time serve para organizar a
#     turma e dar leitura ao template.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SLUG="${1:?uso: criar-repos-alunos.sh <slug> <turma.conf>}"
CONF="${2:?informe o arquivo de configuração da turma}"

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/convencao.sh
source "$RAIZ/lib/convencao.sh"
carregar_turma "$CONF"

EXERCICIO="$RAIZ/$SLUG"
[[ -d "$EXERCICIO" ]] || { echo "✖ exercício não encontrado: $EXERCICIO"; exit 1; }
CURTO=$(nome_curto_exercicio "$EXERCICIO")
TEMPLATE=$(repo_template "$CURTO")
ler_alunos

echo "▸ Turma      : $DISCIPLINA $PERIODO / $TURMA  (time: $TIME)"
echo "▸ Template   : $TEMPLATE"
echo "▸ Exemplo    : $(repo_aluno "$CURTO" "fulanodasilva")"
echo "▸ Visibilidade: $VISIBILIDADE"
echo "▸ Alunos     : ${#ALUNOS_LISTA[@]}"
read -rp "Criar ${#ALUNOS_LISTA[@]} repositórios em $ORG? [s/N] " ok
[[ "$ok" =~ ^[sS]$ ]] || { echo "cancelado."; exit 0; }

# ── Time da turma (organização de membros; leitura no template) ──────────────
if ! gh api "orgs/$ORG/teams/$TIME" &>/dev/null; then
  gh api -X POST "orgs/$ORG/teams" -f name="$TIME" -f privacy=closed \
     -f description="Turma $TURMA — $DISCIPLINA $PERIODO" >/dev/null
  echo "✔ time $TIME criado"
fi
gh api -X PUT "orgs/$ORG/teams/$TIME/repos/$TEMPLATE" -f permission=pull >/dev/null 2>&1 || true

# ── Repositórios individuais ─────────────────────────────────────────────────
for ALUNO in "${ALUNOS_LISTA[@]}"; do
  REPO=$(repo_aluno "$CURTO" "$ALUNO")

  if gh repo view "$REPO" &>/dev/null; then
    echo "• $REPO — já existe, pulando"
    continue
  fi

  gh repo create "$REPO" "$FLAG_VISIBILIDADE" --template "$TEMPLATE" \
     --description "$DISCIPLINA $PERIODO/$TURMA — $CURTO — @$ALUNO" >/dev/null

  # push só para o próprio aluno
  if gh api -X PUT "repos/$REPO/collaborators/$ALUNO" -f permission=push >/dev/null 2>&1; then
    echo "✔ $REPO — criado, @$ALUNO convidado"
  else
    echo "⚠ $REPO — criado, mas falhou ao convidar @$ALUNO (usuário existe?)"
  fi

  # membro do time da turma
  gh api -X PUT "orgs/$ORG/teams/$TIME/memberships/$ALUNO" -f role=member >/dev/null 2>&1 || true
done
