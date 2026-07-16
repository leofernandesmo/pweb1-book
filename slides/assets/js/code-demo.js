/*
 * code-demo.js — componente "código + resultado no navegador" para os slides.
 *
 * Uso em um slide:
 *   <div class="demo" data-lang="html" data-altura="260px">
 *     <script type="text/plain">
 *       <style> .btn { ... } </style>
 *       <button class="btn">Enviar</button>
 *     </script>
 *   </div>
 *
 * O helper lê o código-fonte (fonte única de verdade), mostra-o num bloco de
 * código à esquerda e renderiza EXATAMENTE o mesmo código num <iframe> à direita,
 * com uma moldura de "janela de navegador". Assim o código e o resultado nunca
 * divergem, e tudo funciona offline.
 *
 * Deve ser incluído ANTES da chamada Reveal.initialize() para que o plugin de
 * realce de sintaxe processe os blocos de código gerados.
 */
(function () {
  // Remove a indentação comum de todas as linhas (dedent).
  function dedent(texto) {
    const linhas = texto.replace(/^\n/, "").replace(/\s+$/, "").split("\n");
    let minIndent = Infinity;
    linhas.forEach((l) => {
      if (l.trim() === "") return;
      const indent = l.match(/^\s*/)[0].length;
      if (indent < minIndent) minIndent = indent;
    });
    if (!isFinite(minIndent)) minIndent = 0;
    return linhas.map((l) => l.slice(minIndent)).join("\n");
  }

  document.querySelectorAll(".demo").forEach((demo) => {
    const fonte = demo.querySelector('script[type="text/plain"]');
    if (!fonte) return;

    const codigo = dedent(fonte.textContent);
    const lang = demo.dataset.lang || "html";
    const altura = demo.dataset.altura || "300px";
    // Demos que precisam de JavaScript devem declarar data-lang="js" ou data-scripts.
    const permiteScripts = lang === "js" || demo.hasAttribute("data-scripts");

    // ── Painel de código (esquerda) ──────────────────────────────
    const pre = document.createElement("pre");
    const code = document.createElement("code");
    code.className = "language-" + (lang === "js" ? "javascript" : lang);
    code.setAttribute("data-trim", "");
    code.textContent = codigo; // textContent escapa < > & automaticamente
    pre.appendChild(code);

    // ── Painel de resultado (direita): janela de navegador ───────
    const janela = document.createElement("div");
    janela.className = "demo-navegador";
    janela.innerHTML =
      '<div class="demo-barra"><span></span><span></span><span></span></div>';

    const iframe = document.createElement("iframe");
    iframe.className = "demo-frame";
    iframe.style.height = altura;
    iframe.setAttribute("loading", "lazy");
    iframe.setAttribute(
      "sandbox",
      permiteScripts ? "allow-scripts allow-same-origin" : ""
    );
    iframe.setAttribute("title", "Resultado no navegador");
    iframe.srcdoc =
      "<!doctype html><html lang=\"pt-BR\"><head><meta charset=\"utf-8\">" +
      "<style>html{color-scheme:light}body{font-family:system-ui,-apple-system,'Segoe UI',sans-serif;margin:14px;color:#1a1a2e;background:#fff}</style>" +
      "</head><body>" +
      codigo +
      "</body></html>";
    janela.appendChild(iframe);

    // ── Monta a demo lado a lado ─────────────────────────────────
    demo.textContent = "";
    demo.appendChild(pre);
    demo.appendChild(janela);
  });
})();
