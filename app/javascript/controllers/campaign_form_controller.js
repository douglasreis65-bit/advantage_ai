import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "stepPurchase", "stepLocation", "locationSelect",
    "stepGoal", "goalSelect", "stepUpload",
    "instructionBox", "kpiList", "initialInstruction"
  ]

  // Mantendo sua dataTree idêntica...
  dataTree = {
    vendas: {
      locations: ["Site", "Destino das mensagens", "Ligações"],
      goals: {
        "Site": ["Maximizar número de conversões", "Maximizar valor das conversões", "Maximizar visualizações da página"],
        "Destino das mensagens": ["Maximizar conversões", "Maximizar conversas"],
        "Ligações": ["Maximizar número de ligações"]
      },
      kpis: ["Nome da campanha", "Valor usado", "Compras", "Valor de conversão", "ROAS", "Finalizações de compra", "Visualizações da página"]
    },
    leads: {
      locations: ["Formulários Instantâneos", "Site", "WhatsApp", "Messenger", "Instagram"],
      goals: {
        "Formulários Instantâneos": ["Maximizar número de leads", "Maximizar leads convertidos"],
        "Site": ["Maximizar número de leads", "Maximizar visualizações da página"],
        "WhatsApp": ["Maximizar número de conversas"]
      },
      kpis: ["Nome da campanha", "Valor usado", "Leads", "Custo por Lead (CPL)", "Cliques no link", "Taxa de conversão"]
    },
    trafego: {
      locations: ["Site", "Destino das mensagens", "Instagram ou Facebook"],
      goals: {
        "Site": ["Maximizar visualizações da página de destino", "Maximizar cliques no link"],
        "Destino das mensagens": ["Maximizar conversas", "Maximizar cliques no link"],
        "Instagram ou Facebook": ["Maximizar visitas à Página", "Maximizar ligações"]
      },
      kpis: ["Nome da campanha", "Valor usado", "Cliques no link", "CTR", "CPC", "Visualizações da página"]
    },
    engajamento: {
      locations: ["No seu anúncio", "Destino das mensagens", "Ligações", "Site", "Instagram ou Facebook"],
      goals: {
        "No seu anúncio": ["Maximizar visualizações ThruPlay", "Maximizar engajamento com post", "Maximizar participações no evento"],
        "Site": ["Maximizar número de conversões", "Maximizar visualizações da página"],
        "Instagram ou Facebook": ["Maximizar visitas à Página", "Maximizar curtidas na Página"]
      },
      kpis: ["Nome da campanha", "Valor usado", "Engajamentos", "ThruPlays", "Alcance", "Impressões"]
    },
    reconhecimento: {
      locations: ["Página do Facebook ou Instagram"],
      goals: {
        "Página do Facebook ou Instagram": ["Maximizar o alcance", "Maximizar o número de impressões", "Maximizar visualizações ThruPlay"]
      },
      kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "CPM", "Frequência"]
    }
  }

  // 1. Libera o Tipo de Compra ou pula direto para Local
  showPurchaseType(e) {
    const objective = e.target.value
    // Busca o select de purchase_type de forma mais segura dentro do form
    const purchaseSelect = this.element.querySelector('select[name*="purchase_type"]')
    const allowsReservation = ['reconhecimento', 'engajamento']

    this._resetSubsequentSteps("stepPurchase")

    if (objective === "") return

    if (allowsReservation.includes(objective)) {
      this.stepPurchaseTarget.classList.remove("d-none")
      if (purchaseSelect) purchaseSelect.value = ""
    } else {
      if (purchaseSelect) purchaseSelect.value = "leilao"
      this.stepPurchaseTarget.classList.add("d-none")
      this.showLocation() // Chama o próximo passo
    }
  }

  // 2. Libera e popula o Local da Conversão
  showLocation() {
    const objectiveSelect = this.element.querySelector('select[name*="campaign_objective"]')
    if (!objectiveSelect) return

    const objective = objectiveSelect.value
    const select = this.locationSelectTarget

    this._resetSubsequentSteps("stepLocation")

    select.innerHTML = '<option value="">Selecione o local...</option>'
    const locations = this.dataTree[objective]?.locations || []
    locations.forEach(loc => {
      const option = new Option(loc, loc)
      select.add(option)
    })

    this.stepLocationTarget.classList.remove("d-none")
  }

  // 3. Libera e popula a Meta de Desempenho
  showGoal(e) {
    const objective = this.element.querySelector('select[name*="campaign_objective"]').value
    const location = e.target.value
    const select = this.goalSelectTarget

    this._resetSubsequentSteps("stepGoal")
    if (location === "") return

    select.innerHTML = '<option value="">Selecione a meta...</option>'

    // Ajuste na navegação da dataTree
    const objectiveData = this.dataTree[objective]
    const goals = (objectiveData && objectiveData.goals) ? objectiveData.goals[location] : []

    if (goals) {
      goals.forEach(goal => select.add(new Option(goal, goal)))
    }

    this.stepGoalTarget.classList.remove("d-none")
  }

  // 4. Finaliza: mostra Instruções e campo de Upload
  finalStep(e) {
    const objective = this.element.querySelector('select[name*="campaign_objective"]').value
    if (e.target.value === "") return

    const kpis = this.dataTree[objective]?.kpis || []
    // Adicionando classe de badge para ficar bonito
    this.kpiListTarget.innerHTML = kpis.map(kpi =>
      `<span class="badge rounded-pill border border-info text-info me-1 mb-1" style="font-size: 0.65rem; padding: 5px 10px;">${kpi}</span>`
    ).join('')

    this.initialInstructionTarget.classList.add("d-none")
    this.instructionBoxTarget.classList.remove("d-none")
    this.stepUploadTarget.classList.remove("d-none")
  }

  _resetSubsequentSteps(currentStep) {
    const steps = ["stepPurchase", "stepLocation", "stepGoal", "stepUpload"]
    const index = steps.indexOf(currentStep)

    steps.slice(index).forEach(step => {
      if (this.hasTarget(step) && step !== currentStep) {
        this[`${step}Target`].classList.add("d-none")
      }
    })
  }
}
