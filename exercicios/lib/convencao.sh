# shellcheck shell=bash
# ─────────────────────────────────────────────────────────────────────────────
# Convenção de nomes e carregamento da configuração de turma.
# Este arquivo é "sourced" pelos scripts — não execute diretamente.
#
# Convenção:
#   template : <disciplina>-<nomeCurto>-template
#              ex.: pweb1-cartao-curso-template
#   do aluno : <disciplina>-<periodo>-<turma>-<nomeCurto>-<usuario>
#              ex.: pweb1-2026.1-911a-cartao-curso-fulanodasilva
#   time     : <disciplina>-<periodo>-<turma>
#              ex.: pweb1-2026.1-911a
# ─────────────────────────────────────────────────────────────────────────────

# Carrega e valida um arquivo de turma (turmas/*.conf).
carregar_turma() {
  local conf="${1:?informe o arquivo de configuração da turma}"
  [[ -f "$conf" ]] || { echo "✖ configuração não encontrada: $conf" >&2; exit 1; }
  # shellcheck disable=SC1090
  source "$conf"

  local faltando=()
  for var in ORG DISCIPLINA PERIODO TURMA VISIBILIDADE ALUNOS; do
    [[ -n "${!var:-}" ]] || faltando+=("$var")
  done
  if [[ ${#faltando[@]} -gt 0 ]]; then
    echo "✖ faltam variáveis em $conf: ${faltando[*]}" >&2; exit 1
  fi

  case "$VISIBILIDADE" in
    publico|privado) ;;
    *) echo "✖ VISIBILIDADE deve ser 'publico' ou 'privado' (veio: $VISIBILIDADE)" >&2; exit 1 ;;
  esac

  # Caminho de ALUNOS é relativo ao arquivo de conf, se não for absoluto
  [[ "$ALUNOS" = /* ]] || ALUNOS="$(cd "$(dirname "$conf")" && pwd)/$(basename "$ALUNOS")"
  [[ -f "$ALUNOS" ]] || { echo "✖ lista de alunos não encontrada: $ALUNOS" >&2; exit 1; }

  TIME="$DISCIPLINA-$PERIODO-$TURMA"
  FLAG_VISIBILIDADE="--$([[ $VISIBILIDADE == publico ]] && echo public || echo private)"
  export ORG DISCIPLINA PERIODO TURMA VISIBILIDADE ALUNOS TIME FLAG_VISIBILIDADE
}

# Lê o nome curto do exercício a partir do meta.json (cai no slug se não houver).
nome_curto_exercicio() {
  local exercicio="${1:?}"
  node -p "const m=require('$exercicio/meta.json'); m.nomeCurto || m.slug"
}

# Nome do repositório-template do exercício (não depende de turma/período).
repo_template() { echo "$ORG/$DISCIPLINA-$1-template"; }

# Nome do repositório de um aluno.
repo_aluno() { echo "$ORG/$DISCIPLINA-$PERIODO-$TURMA-$1-$2"; }

# Prefixo comum dos repositórios da turma (para buscas/arquivamento).
prefixo_turma() { echo "$DISCIPLINA-$PERIODO-$TURMA-"; }

# Leitura portátil da lista de alunos (mapfile não existe no bash 3.2 do macOS).
ler_alunos() {
  ALUNOS_LISTA=()
  local usuario
  while IFS= read -r usuario; do
    [ -n "$usuario" ] && ALUNOS_LISTA+=("$usuario")
  done < <(grep -vE '^[[:space:]]*(#|$)' "$ALUNOS" | tr -d '\r' | awk '{print $1}')
}
