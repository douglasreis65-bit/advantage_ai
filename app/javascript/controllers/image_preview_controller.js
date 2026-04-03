import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "container"]

  connect() {
    // Lista interna para gerenciar os arquivos selecionados
    this.filesList = []
  }

  preview() {
    const newFiles = Array.from(this.inputTarget.files)

    // Adiciona os novos arquivos à nossa lista interna
    this.filesList = [...this.filesList, ...newFiles]

    this.renderPreviews()
    this.updateInput()
  }

  remove(event) {
    const index = event.currentTarget.dataset.index
    // Remove o arquivo da lista interna pelo índice
    this.filesList.splice(index, 1)

    this.renderPreviews()
    this.updateInput()
  }

  renderPreviews() {
    this.containerTarget.innerHTML = ""

    this.filesList.forEach((file, index) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const html = `
          <div class="position-relative m-2" style="width: 100px;">
            <img src="${e.target.result}" class="rounded shadow-sm" style="height: 100px; width: 100px; object-fit: cover;">
            <button type="button"
                    data-action="click->image-preview#remove"
                    data-index="${index}"
                    class="btn btn-danger btn-sm rounded-circle position-absolute"
                    style="top: -10px; right: -10px; width: 24px; height: 24px; padding: 0; line-height: 1;">
              &times;
            </button>
            <p class="small text-truncate mt-1 mb-0" style="font-size: 10px;">${file.name}</p>
          </div>
        `
        this.containerTarget.insertAdjacentHTML("beforeend", html)
      }
      reader.readAsDataURL(file)
    })
  }

  // Truque de mestre: sincroniza a lista JS com o input de arquivos real
  updateInput() {
    const dataTransfer = new DataTransfer()
    this.filesList.forEach(file => dataTransfer.items.add(file))
    this.inputTarget.files = dataTransfer.files
  }
}
