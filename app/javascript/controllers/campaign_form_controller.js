import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "locationSelect", "sidebarTitle", "sidebarContent", "instructionBox",
    "kpiList", "step2", "step3", "step4"
  ]

  connect() {
    this.dataTree = {
      reconhecimento: {
        locations: ["Página do Facebook ou Instagram"],
        details: {
          "Página do Facebook ou Instagram": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "CPM (custo por 1.000 impressões)", "Frequência", "Incrementalidade na lembrança do anúncio", "Taxa de incrementalidade na lembrança do anúncio", "ThruPlays", "Reproduções do vídeo contínuas por no mínimo 2 segundos"],
            tip: "Avaliaremos o Brand Lift e a eficiência da entrega de Leilão ou Reserva."
          }
        }
      },
      trafego: {
        locations: ["Site", "Destino das mensagens", "Instagram ou Facebook", "Ligações"],
        details: {
          "Site": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Frequência", "Cliques no link", "CPC (custo por clique no link)", "CTR (taxa de cliques no link)", "Visualizações da página de destino", "Custo por visualização da página de destino", "Taxa de visualizações da página de destino por cliques no link"],
            tip: "Analisaremos a perda de tráfego entre o clique e o carregamento do site."
          },
          "Destino das mensagens": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Conversas por mensagem iniciadas", "Custo por conversa por mensagem iniciada", "CTR (taxa de cliques no link)"],
            tip: "Foco no custo de aquisição de tráfego para canais diretos."
          },
          "Instagram ou Facebook": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Visitas ao perfil do Instagram", "Engajamentos com a Página"],
            tip: "Foco no crescimento de audiência e visitas ao perfil."
          },
          "Ligações": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Ligações feitas", "Custo por ligação feita"],
            tip: "Mediremos a eficiência em gerar chamadas telefônicas."
          }
        }
      },
      engajamento: {
        locations: ["No seu anúncio", "Destino das mensagens", "Site", "Instagram ou Facebook", "Ligações"],
        details: {
          "No seu anúncio": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Engajamentos com o post", "Reações ao post", "Compartilhamentos do post", "Salvamentos do post", "ThruPlays", "Reproduções do vídeo contínuas por no mínimo 2 segundos", "Participações no evento", "Lembretes de rede ativados"],
            tip: "Analisaremos a viralidade e a retenção de vídeo (Hook/Hold Rate)."
          },
          "Destino das mensagens": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Cliques no link", "Conversas por mensagem iniciadas", "Custo por conversa por mensagem iniciada", "Novos contatos de mensagem", "Mensagens de marketing lidas"],
            tip: "Foco na qualidade do engajamento que gera conversas."
          },
          "Site": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Visualizações da página de destino", "Eventos personalizados", "Visualizações do conteúdo"],
            tip: "Foco na interação do usuário com o conteúdo da Landing Page."
          },
          "Instagram ou Facebook": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Curtidas do Facebook", "Seguidores no Instagram", "Visitas ao perfil do Instagram", "Custo por curtida"],
            tip: "Foco na retenção de novos seguidores e curtidas."
          },
          "Ligações": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Ligações feitas", "Custo por ligação feita"],
            tip: "Custo por chamada telefônica a partir de posts."
          }
        }
      },
      leads: {
        locations: ["Site", "Formulários instantâneos", "Mensagens (WhatsApp/Messenger/IG)", "Ligações"],
        details: {
          "Site": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Visualizações da página de destino", "Leads", "Custo por lead", "Valor de conversão de leads"],
            tip: "Cálculo da taxa de conversão da LP (Landing Page)."
          },
          "Formulários instantâneos": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Leads", "Custo por lead", "Taxa de resultados por cliques no link"],
            tip: "Análise da eficiência dos formulários nativos do Facebook."
          },
          "Mensagens (WhatsApp/Messenger/IG)": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Cliques no link", "Conversas por mensagem iniciadas", "Novos contatos de mensagem", "Leads", "Custo por lead"],
            tip: "Foco na taxa de conversão de conversa para lead qualificado."
          },
          "Ligações": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Ligações feitas", "Leads", "Custo por lead"],
            tip: "Foco em contatos telefônicos de alta intenção."
          }
        }
      },
      vendas: {
        locations: ["Site", "Destinos das mensagens", "Ligações"],
        details: {
          "Site": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "CTR (todos)", "CPM (custo por 1.000 impressões)", "Visualizações da página de destino", "Visualizações do conteúdo", "Adições ao carrinho", "Finalizações de compra iniciadas", "Compras", "Custo por compra", "Valor de conversão da compra", "Retorno sobre o investimento em publicidade (ROAS) das compras"],
            tip: "A IA fará a análise completa do funil de e-commerce."
          },
          "Destinos das mensagens": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Conversas por mensagem iniciadas", "Compras", "Valor de conversão da compra", "Retorno sobre o investimento em publicidade (ROAS) das compras", "Custo por compra"],
            tip: "Análise da taxa de fechamento comercial via chat."
          },
          "Ligações": {
            kpis: ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Ligações feitas", "Compras", "Valor de conversão da compra", "Custo por compra", "ROAS"],
            tip: "Foco em vendas assistidas por voz e tickets altos."
          }
        }
      }
    };
  }

  updateTree(e) {
    const objective = e.target.value;
    const select = this.locationSelectTarget;
    select.innerHTML = '<option value="">Selecione o local...</option>';

    if (objective && this.dataTree[objective]) {
      this.dataTree[objective].locations.forEach(loc => {
        select.add(new Option(loc, loc));
      });
    }
  }

  goToStep2() {
    this._toggleStep(this.step2Target, "Dados de Pixel",
      "No Gerenciador de Eventos, exporte o relatório para cruzarmos o comportamento do site com os anúncios.");
  }

  goToStep3() {
    this._toggleStep(this.step3Target, "Análise de Criativos",
      "Envie as mídias originais. Analisaremos ganchos visuais e a qualidade estética dos anúncios.");
  }

  goToStep4() {
    const objective = this.element.querySelector('select[name*="campaign_objective"]')?.value;
    const location = this.locationSelectTarget.value;

    if (!objective || !location) {
      alert("Selecione o Objetivo e o Local no Passo 1.");
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }

    const config = this.dataTree[objective]?.details[location];
    const kpis = config?.kpis || ["Métricas de Performance Gerais"];
    const tip = config?.tip || "Exporte as métricas primárias da sua campanha.";

    this.sidebarTitleTarget.innerText = "Configuração do Relatório";
    this.sidebarContentTarget.innerHTML = `
      <p class="small text-muted mb-3">
        1. No menu esquerdo da Meta, vá em <strong>Relatórios de Anúncios</strong>.<br>
        2. No painel <strong>'Personalizar tabela dinâmica'</strong> (à direita), selecione:
      </p>
      <div class="mt-3 p-3 bg-primary bg-opacity-10 rounded-3 small border border-primary border-opacity-25">
        <i class="fa-solid fa-lightbulb text-primary me-2"></i><strong>Foco IA:</strong> ${tip}
      </div>
      <p class="x-small text-uppercase text-secondary fw-bold mt-3 mb-1">Métricas e Detalhamentos:</p>
    `;

    this._toggleStep(this.step4Target, null, null, false); // Passa sem sobrescrever o HTML acima
    this.instructionBoxTarget.classList.remove("d-none");
    this.kpiListTarget.innerHTML = kpis.map(kpi => `<span class="kpi-tag">${kpi}</span>`).join('');
  }

  _toggleStep(target, title, instruction, updateSidebar = true) {
    if (updateSidebar) {
      this.sidebarTitleTarget.innerText = title;
      this.sidebarContentTarget.innerHTML = `<p class="small text-muted">${instruction}</p>`;
    }

    target.classList.remove("d-none");

    setTimeout(() => {
      window.scrollTo({
        top: target.offsetTop - 120,
        behavior: 'smooth'
      });
    }, 100);
  }
}
