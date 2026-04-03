require 'csv'

class SynkraAiService
  def initialize(analysis)
    @analysis = analysis
  end

  def call
    if @analysis.analysis_type == 'performance'
      process_performance_metrics
    else
      process_creative_visuals
    end
  end

  private

  def process_performance_metrics
    return unless @analysis.campaign_csv.attached?

    # O Synkra lê o CSV
    csv_data = @analysis.campaign_csv.download
    table = CSV.parse(csv_data, headers: true)

    # Extrai métricas que o aiox-core precisa (CTR, CPM, CPC...)
    # Envia para a lógica de diagnóstico da IA
    # @analysis.update(ai_feedback: "Resultado do processamento aqui")
  end

  def process_creative_visuals
    # Lógica para analisar as artes anexadas em @analysis.ad_artworks
  end
end
