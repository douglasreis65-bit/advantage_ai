class MetaKpiMapper
  # Estrutura: { "objetivo_local_meta" => [Lista de Colunas] }
  MAP = {
    # RECONHECIMENTO
    "reconhecimento_página_alcance" => ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "CPM (custo por 1.000 impressões)", "Frequência"],
    "reconhecimento_página_impressões" => ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "CPM (custo por 1.000 impressões)"],
    "reconhecimento_página_thruplay" => ["Nome da campanha", "Valor usado", "ThruPlays", "Reproduções do vídeo contínuas por no mínimo 2 segundos", "Custo por ThruPlay"],

    # TRÁFEGO
    "trafego_site_visualizacoes" => ["Nome da campanha", "Valor usado", "Cliques no link", "CTR (taxa de cliques no link)", "CPC (custo por clique no link)", "Visualizações da página de destino", "Custo por visualização da página de destino"],
    "trafego_site_cliques" => ["Nome da campanha", "Valor usado", "Cliques no link", "CTR (taxa de cliques no link)", "CPC (custo por clique no link)"],
    "trafego_mensagens_conversas" => ["Nome da campanha", "Valor usado", "Cliques no link", "Mensagens iniciadas", "Custo por conversa por mensagem iniciada"],

    # ENGAJAMENTO
    "engajamento_anuncio_video" => ["Nome da campanha", "Valor usado", "ThruPlays", "Reproduções do vídeo contínuas por no mínimo 2 segundos", "Custo por ThruPlay"],
    "engajamento_anuncio_post" => ["Nome da campanha", "Valor usado", "Engajamentos com o post", "Reações ao post", "Comentários no post", "Compartilhamentos do post", "Custo por engajamento com o post"],
    "engajamento_site_conversoes" => ["Nome da campanha", "Valor usado", "Cliques no link", "Visualizações da página de destino", "Resultados", "Custo por resultado"],

    # LEADS
    "leads_formularios_leads" => ["Nome da campanha", "Valor usado", "Cliques no link", "Leads (no formulário)", "Custo por Lead", "Taxa de conversão de leads"],
    "leads_site_leads" => ["Nome da campanha", "Valor usado", "Cliques no link", "Visualizações da página de destino", "Leads", "Custo por Lead"],
    "leads_whatsapp_conversas" => ["Nome da campanha", "Valor usado", "Cliques no link", "Conversas por mensagem iniciadas", "Custo por conversa por mensagem iniciada"],

    # VENDAS
    "vendas_site_conversoes" => ["Nome da campanha", "Valor usado", "Visualizações da página de destino", "Adições ao carrinho", "Finalizações de compra iniciadas", "Compras", "Valor de conversão da compra", "ROAS de compras", "Custo por compra (CPA)"],
    "vendas_site_valor" => ["Nome da campanha", "Valor usado", "Compras", "Valor de conversão da compra", "ROAS de compras", "Custo por compra (CPA)"],
    "vendas_mensagens_conversas" => ["Nome da campanha", "Valor usado", "Mensagens iniciadas", "Compras", "Valor de conversão da compra", "Custo por compra (CPA)"]
  }.freeze

  def self.get_columns(objective, location, performance_goal)
    key = "#{objective.downcase}_#{location.downcase}_#{performance_goal.downcase}".gsub(" ", "_")
    MAP[key] || default_columns
  end

  def self.default_columns
    ["Nome da campanha", "Valor usado", "Alcance", "Impressões", "Cliques no link", "Resultados", "Custo por resultado"]
  end
end
