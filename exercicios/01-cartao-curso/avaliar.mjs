/**
 * Correção automática — Exercício 1: Cartão de curso interativo
 *
 * Uso:  node avaliar.mjs [pastaDoAluno]
 * Padrão: a pasta atual (é assim que roda no repositório do aluno).
 */

import path from "node:path";
import { avaliar, exigir, exigirElemento } from "../lib/avaliador.js";

const pastaAluno = path.resolve(process.argv[2] ?? ".");

/** Converte "rgb(238, 242, 255)" em [238,242,255]; devolve null se transparente. */
function paraRGB(cor) {
  if (!cor || cor === "transparent" || cor.includes("rgba(0, 0, 0, 0)")) return null;
  const n = cor.match(/\d+(\.\d+)?/g);
  return n ? n.slice(0, 3).map(Number) : null;
}

const { nota } = await avaliar({
  titulo: "Exercício 1 — Cartão de curso interativo",
  pastaAluno,
  verificacoes: ({ pagina, errosDeConsole }) => [
    // ── 1. Estrutura (HTML semântico) ─────────────────────────
    {
      nome: 'O <html> declara lang="pt-BR"',
      pontos: 6,
      executar: async () => {
        const lang = await pagina.getAttribute("html", "lang");
        exigir(lang, "o elemento <html> não tem o atributo lang");
        exigir(
          lang.toLowerCase().startsWith("pt"),
          `lang="${lang}" — esperado um idioma português, como "pt-BR"`
        );
      },
    },
    {
      nome: "A página tem exatamente um <h1>",
      pontos: 6,
      executar: async () => {
        const qtd = await pagina.locator("h1").count();
        exigir(qtd !== 0, "nenhum <h1> encontrado na página");
        exigir(qtd === 1, `foram encontrados ${qtd} elementos <h1> — deve haver só um`);
      },
    },
    {
      nome: "O conteúdo principal está em um <main>",
      pontos: 6,
      executar: async () => {
        exigir(
          (await pagina.locator("main").count()) === 1,
          "não há um elemento <main> na página"
        );
      },
    },
    {
      nome: "O cartão é um <article class=\"card\">",
      pontos: 8,
      executar: async () => {
        exigir(
          (await pagina.locator("article.card").count()) > 0,
          'não há um <article> com a classe "card" (encontrou apenas <div>?)'
        );
      },
    },
    {
      nome: "A imagem do cartão tem alt descritivo",
      pontos: 10,
      executar: async () => {
        const img = pagina.locator("article.card img, .card img").first();
        exigir((await img.count()) > 0, "não há <img> dentro do cartão");
        const alt = await img.getAttribute("alt");
        exigir(alt !== null, "a <img> não tem o atributo alt");
        exigir(alt.trim() !== "", "o alt está vazio — descreva o conteúdo da imagem");
        exigir(
          alt.trim().length >= 10,
          `o alt "${alt}" é curto demais para descrever a imagem`
        );
      },
    },

    // ── 2. Apresentação (CSS realmente aplicado) ──────────────
    {
      nome: "O .card tem cor de fundo própria",
      pontos: 10,
      executar: async () => {
        const card = await exigirElemento(pagina, ".card", "o cartão");
        const cor = await card.evaluate((el) => getComputedStyle(el).backgroundColor);
        const rgb = paraRGB(cor);
        exigir(rgb, "o .card está sem cor de fundo (transparente)");
        exigir(
          !(rgb[0] === 255 && rgb[1] === 255 && rgb[2] === 255),
          "o fundo do .card é branco — use uma cor que o destaque da página"
        );
      },
    },
    {
      nome: "O .card tem cantos arredondados",
      pontos: 6,
      executar: async () => {
        const card = await exigirElemento(pagina, ".card", "o cartão");
        const raio = await card.evaluate((el) =>
          parseFloat(getComputedStyle(el).borderTopLeftRadius)
        );
        exigir(raio > 0, "border-radius do .card é 0 — arredonde os cantos");
      },
    },
    {
      nome: "O .card tem espaçamento interno (padding)",
      pontos: 6,
      executar: async () => {
        const card = await exigirElemento(pagina, ".card", "o cartão");
        const p = await card.evaluate((el) =>
          parseFloat(getComputedStyle(el).paddingTop)
        );
        exigir(p > 0, "padding do .card é 0 — afaste o conteúdo da borda");
      },
    },
    {
      nome: "O botão #favoritar está estilizado",
      pontos: 10,
      executar: async () => {
        const botao = pagina.locator("#favoritar");
        exigir((await botao.count()) > 0, "não há um botão com id=\"favoritar\"");
        const estilo = await botao.evaluate((el) => {
          const s = getComputedStyle(el);
          return { fundo: s.backgroundColor, texto: s.color };
        });
        exigir(paraRGB(estilo.fundo), "o botão está sem cor de fundo");
        exigir(paraRGB(estilo.texto), "o botão está sem cor de texto definida");
      },
    },

    // ── 3. Comportamento (JavaScript) ─────────────────────────
    {
      nome: 'O botão começa com aria-pressed="false"',
      pontos: 6,
      executar: async () => {
        const v = await pagina.getAttribute("#favoritar", "aria-pressed");
        exigir(v !== null, "o botão não tem o atributo aria-pressed");
        exigir(v === "false", `aria-pressed inicial é "${v}" — deveria ser "false"`);
      },
    },
    {
      nome: 'Ao clicar, aria-pressed vira "true"',
      pontos: 12,
      executar: async () => {
        await pagina.click("#favoritar");
        const v = await pagina.getAttribute("#favoritar", "aria-pressed");
        exigir(
          v === "true",
          `depois do clique aria-pressed é "${v}" — deveria ser "true"`
        );
      },
    },
    {
      nome: 'Ao clicar, o cartão recebe a classe "favorito"',
      pontos: 12,
      executar: async () => {
        // o clique já ocorreu na verificação anterior
        const card = await exigirElemento(pagina, ".card", "o cartão");
        const temClasse = await card.evaluate((el) =>
          el.classList.contains("favorito")
        );
        exigir(temClasse, 'o cartão não recebeu a classe "favorito" após o clique');
      },
    },
    {
      nome: "O JavaScript roda sem erros",
      pontos: 2,
      executar: async () => {
        exigir(
          errosDeConsole.length === 0,
          `erro de JavaScript: ${errosDeConsole[0]}`
        );
      },
    },
  ],
});

// Falha o job do Actions se a nota for zero (nada entregue)
process.exit(nota === 0 ? 1 : 0);
