document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".quiz button").forEach(button => {
    button.addEventListener("click", event => {
      const quiz = event.target.closest(".quiz")
      const correct = quiz.dataset.answer
      const chosen = event.target.dataset.option
      const feedback = quiz.querySelector(".feedback")

      if (chosen === correct) {
        feedback.textContent = "✔️ Correto!"
        feedback.style.color = "green"
      } else {
        feedback.textContent = "❌ Tente novamente."
        feedback.style.color = "red"
      }
    })
  })
})
