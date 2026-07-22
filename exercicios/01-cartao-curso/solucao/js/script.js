/* Solução de referência — Exercício 1 */

const botao = document.querySelector("#favoritar");
const cartao = document.querySelector(".card");

// Estado inicial: não favoritado
botao.setAttribute("aria-pressed", "false");

botao.addEventListener("click", () => {
  const favoritado = botao.getAttribute("aria-pressed") === "true";
  const novoEstado = !favoritado;

  botao.setAttribute("aria-pressed", String(novoEstado));
  cartao.classList.toggle("favorito", novoEstado);
  botao.textContent = novoEstado ? "★ Favoritado" : "★ Favoritar";
});
