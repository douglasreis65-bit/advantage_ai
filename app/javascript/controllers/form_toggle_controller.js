import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["siteInput"]

  toggleSite(event) {
    if (event.target.checked) {
      this.siteInputTarget.style.opacity = "0.3"
      this.siteInputTarget.style.pointerEvents = "none"
      this.siteInputTarget.querySelector('input').value = "" // Limpa o campo
    } else {
      this.siteInputTarget.style.opacity = "1"
      this.siteInputTarget.style.pointerEvents = "auto"
    }
  }
}
