import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Inicia o temporizador de 5 segundos
    setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  dismiss() {
    // Adiciona uma transição suave antes de remover
    this.element.style.transition = "opacity 0.5s ease, transform 0.5s ease"
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(100px)"

    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
