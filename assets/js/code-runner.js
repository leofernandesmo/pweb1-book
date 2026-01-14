document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".code-runner").forEach(block => {
    const button = block.querySelector(".run-code")
    const input = block.querySelector(".code-input")
    const output = block.querySelector(".code-output")

    button.addEventListener("click", () => {
      const code = input.value
      const doc = output.contentDocument || output.contentWindow.document
      doc.open()
      doc.write(code)
      doc.close()
    })
  })
})
