#!/usr/bin/env python3
"""
Adaptador Classroom 50 → corretor Playwright do PWeb1.

O Classroom 50 executa este arquivo dentro do checkout da entrega do aluno e
espera encontrar, ao final, um `result.json` no schema `classroom50/result/v1`.

Aqui nós apenas:
  1. garantimos as dependências (Playwright + Chromium);
  2. rodamos o corretor Node deste exercício sobre a pasta entregue;
  3. traduzimos o `nota.json` que ele produz para o `result.json` do Classroom 50.

Assim o corretor continua independente de plataforma: o mesmo `avaliar.mjs`
roda no `npm test` do aluno, no nosso `coletar-notas.sh` e aqui.
"""

import datetime
import json
import os
import subprocess
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent          # autograder no repo de config
ENTREGA = Path.cwd()                            # checkout do repo do aluno
SCHEMA = "classroom50/result/v1"


def executar(cmd, **kw):
    """Roda um comando mostrando-o no log do Actions."""
    print(f"$ {' '.join(str(c) for c in cmd)}", flush=True)
    return subprocess.run(cmd, check=False, **kw)


def preparar_dependencias() -> None:
    """Instala o Playwright e o Chromium na pasta do autograder."""
    if not (AQUI / "node_modules" / "playwright").exists():
        executar(["npm", "install", "--silent", "--prefix", str(AQUI)])
    executar(
        ["npx", "--yes", "playwright", "install", "--with-deps", "chromium"],
        cwd=AQUI,
    )


def resultado_vazio(mensagem: str) -> dict:
    """Resultado 0/0 quando a correção não pôde nem começar."""
    return {"score": 0, "max-score": 0,
            "tests": [{"test-name": mensagem, "passed": False,
                       "score": 0, "max-score": 0}]}


def corrigir() -> dict:
    """Roda o corretor Node e devolve score/max-score/tests."""
    saida = AQUI / "nota.json"
    saida.unlink(missing_ok=True)

    proc = executar(
        ["node", str(AQUI / "avaliar.mjs"), str(ENTREGA)],
        cwd=AQUI,  # o corretor grava nota.json no diretório de trabalho
    )

    if not saida.exists():
        print("::error::o corretor não gerou nota.json", flush=True)
        return resultado_vazio(
            f"falha ao executar a correção (código {proc.returncode})"
        )

    nota = json.loads(saida.read_text(encoding="utf-8"))
    testes = [
        {
            "test-name": v["nome"] if v["ok"] else f'{v["nome"]} — {v["motivo"]}',
            "passed": v["ok"],
            "score": v["obtidos"],
            "max-score": v["pontos"],
        }
        for v in nota["verificacoes"]
    ]
    return {"score": nota["obtido"], "max-score": nota["total"], "tests": testes}


def main() -> int:
    preparar_dependencias()
    parcial = corrigir()

    agora = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    commit_url = os.environ.get("COMMIT_URL", "")

    resultado = {
        "schema": SCHEMA,
        "classroom": os.environ.get("CLASSROOM", ""),
        "assignment": os.environ.get("ASSIGNMENT", ""),
        "assignment_type": os.environ.get("ASSIGNMENT_TYPE", "individual"),
        "owner": os.environ.get("OWNER", ""),
        "submission": os.environ.get("SUBMISSION_TAG", ""),
        "commit": commit_url,
        "release": os.environ.get("RELEASE_URL", ""),
        "review": os.environ.get("REVIEW_URL") or commit_url,
        "datetime": agora,
        **parcial,
    }

    (ENTREGA / "result.json").write_text(
        json.dumps(resultado, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print(
        f"\nNota: {resultado['score']}/{resultado['max-score']}"
        f" ({len(resultado['tests'])} verificações)",
        flush=True,
    )
    # Exit 0 = autograder executou com sucesso (a nota em si vai no result.json).
    return 0


if __name__ == "__main__":
    sys.exit(main())
