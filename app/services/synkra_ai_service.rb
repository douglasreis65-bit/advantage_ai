# /home/dcreis/code/douglasreis65-bit/advantage_ai/app/services/synkra_ai_service.rb
require 'csv'
require 'faraday'
require 'json'
require 'base64'

class SynkraAiService
  # --- CONSTANTES DE CONFIGURAÇÃO (AIOX L1 LAYER) ---
  MAX_VISUAL_ASSETS = 5
  GEMINI_MODEL = "gemini-1.5-flash"

  def initialize(analysis)
    @analysis = analysis
    @segmento = analysis.business_segment || "Geral/Não Informado"
    @objetivo = analysis.campaign_objective || "Conversão"
    @meta_performance = analysis.performance_goal || "ROI Positivo"
    @api_key = ENV['GEMINI_API_KEY']
  end

  def call
    # 1. Início da Orquestração e Observabilidade
    @analysis.update(status: 'processing', ai_feedback: "Iniciando Squad de Agentes SynkraAI...")
    Rails.logger.info "[AIOX-START] Iniciando análise ID: #{@analysis.id} | Tipo: #{@analysis.analysis_type}"

    begin
      # 2. Roteamento de Agentes Especialistas
      case @analysis.analysis_type
      when 'performance'
        run_performance_and_audit_squad
      when 'creative_pre_launch'
        run_creative_lab_and_strategy_squad
      else
        raise "Tipo de análise inválido: #{@analysis.analysis_type}"
      end

    rescue Faraday::Error => e
      handle_error("Erro de conexão com o cérebro da IA (API): #{e.message}")
    rescue CSV::MalformedCSVError => e
      handle_error("O arquivo CSV enviado está corrompido ou em formato inválido: #{e.message}")
    rescue StandardError => e
      handle_error("Erro crítico na orquestração: #{e.message}")
    end
  end

  private

  # =========================================================
  # AGENTE 1: PERFORMANCE & AUDIT (ANÁLISE DE CAMPANHA VIVA)
  # =========================================================
  def run_performance_and_audit_squad
    # Verificação de segurança (Guard Clause)
    return unless validate_attachment(@analysis.campaign_csv, "CSV de Métricas")

    # Extração e Sumarização (Spec Pipeline)
    raw_csv = @analysis.campaign_csv.download
    table = CSV.parse(raw_csv, headers: true, header_converters: :symbol)
    metrics = summarize_metrics(table)

    # Preparação de contexto visual (Cruzamento de Dados)
    visual_assets = prepare_visual_assets # Opcional na performance, mas poderoso se houver
    technical_audit = run_technical_health_check(metrics)

    prompt = <<~PROMPT
      [ROLE: SENIOR PERFORMANCE ARCHITECT & DATA ANALYST]
      [MISSION: SALVAR O ROI DO ANUNCIANTE]
      [CONTEXTO: Segmento #{@segmento} | Objetivo #{@objetivo}]

      --- DADOS REAIS DO GERENCIADOR DE ANÚNCIOS ---
      #{metrics.to_json}

      --- AUDITORIA TÉCNICA DE SINAIS ---
      #{technical_audit}

      --- TAREFAS DE ELITE (CRUZAMENTO OBRIGATÓRIO) ---
      1. ANÁLISE DE SATURAÇÃO: Com base na frequência (se disponível) e no CTR de #{metrics[:ctr]}%, determine se o criativo saturou ou se o público está fadigado.
      2. PÚBLICO VS CRIATIVO: Se o CPC é alto, o problema é o público ou a imagem? Analise os criativos anexados (se houver) e julgue se a comunicação está "conversando" com o nicho #{@segmento}.
      3. DIMENSÕES E POSICIONAMENTO: Verifique se os criativos enviados respeitam as dimensões para Reels/Stories (9:16) ou Feed (4:5/1:1). Aponte erros de posicionamento que causam desperdício de verba.
      4. O VEREDITO (SCORE 0-100): Dê uma nota para a campanha atual.
      5. PLANO DE RESGATE: Liste 3 ações críticas (Ex: "Troque o público X", "Mude o Hook do vídeo Y").

      ESTILO: Seja o "Lobo de Wall Street" do tráfego pago brasileiro: direto, agressivo com os erros e focado em lucro.
    PROMPT

    execute_ai_task(prompt, visual_assets)
  end

  # =========================================================
  # AGENTE 2: CREATIVE LAB & STRATEGY (PRÉ-LANÇAMENTO)
  # =========================================================
  def run_creative_lab_and_strategy_squad
    return unless validate_attachment(@analysis.ad_artworks, "Criativos (Imagens/Vídeos)")

    visual_assets = prepare_visual_assets

    prompt = <<~PROMPT
      [ROLE: CREATIVE DIRECTOR & CAMPAIGN STRATEGIST]
      [MISSION: PLANEJAR O LANÇAMENTO PERFEITO]
      [NICHO: #{@segmento} | FOCO: #{@objetivo}]

      --- TAREFAS DE ELITE (CREATIVE LAB) ---
      1. CREATIVE PRE-SCORE (0-100): Qual a chance real deste material converter antes de gastar 1 real?
      2. AUDITORIA VISUAL: Analise contraste, legibilidade e "Safe Zones". O texto vai ser cortado pela interface do Instagram/TikTok?
      3. SUGESTÕES DE MELHORIA: O que falta para ser um anúncio "High-End"? (Melhorar gancho, iluminação, CTA).

      --- ESTRATÉGIA DE CONFIGURAÇÃO (O DIFERENCIAL) ---
      4. PÚBLICOS SUGERIDOS: Com base no visual, quem compraria isso? Liste 3 tipos de interesses ou públicos lookalike.
      5. POSICIONAMENTO IDEAL: Onde esse anúncio performa melhor? (Ex: Somente Reels, Somente Feed, etc).
      6. ESTIMATIVA DE ORÇAMENTO: Qual o "Budget de Teste" recomendado para validar esse criativo em #{@segmento}?
      7. COPYWRITING MASTER: Gere 2 variações de Headline e Legenda (1 Curta/Direta e 1 Storytelling).

      RECOMENDAÇÃO: Use termos como 'Escala', 'Público Frio' e 'Fase de Aprendizado'.
    PROMPT

    execute_ai_task(prompt, visual_assets)
  end

  # =========================================================
  # INFRAESTRUTURA DE COMUNICAÇÃO (THE CORE)
  # =========================================================

  def execute_ai_task(prompt_text, visual_assets)
    url = "https://generativelanguage.googleapis.com/v1beta/models/#{GEMINI_MODEL}:generateContent?key=#{@api_key}"

    system_instruction = "Você é o Mentor SynkraAI. Você não dá respostas genéricas. Você analisa dados e imagens com precisão técnica alemã e paixão brasileira por vendas."

    payload = {
      contents: [{
        parts: [
          { text: "#{system_instruction}\n\n#{prompt_text}" },
          *visual_assets
        ]
      }],
      generationConfig: { temperature: 0.7, topP: 0.95, maxOutputTokens: 2048 }
    }.to_json

    response = Faraday.post(url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = payload
    end

    if response.success?
      parsed_response = JSON.parse(response.body)
      content = parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
      @analysis.update(ai_feedback: content, status: 'completed')
      Rails.logger.info "[AIOX-SUCCESS] Análise #{@analysis.id} concluída."
    else
      log_api_error(response)
      raise "Erro na API da IA: #{response.status}"
    end
  end

  # =========================================================
  # TOOLKIT DE PROCESSAMENTO DE DADOS (DATA ANALYST)
  # =========================================================

  def summarize_metrics(table)
    headers = table.headers.map(&:to_s)

    {
      spend: extract_metric(table, headers, ["valor usado", "amount spent", "investimento", "custo", "cost"]),
      impressions: extract_metric(table, headers, ["impressões", "impressions", "impressoes"]).to_i,
      clicks: extract_metric(table, headers, ["cliques no link", "link clicks", "cliques", "clicks"]).to_i,
      conversions: extract_metric(table, headers, ["resultados", "results", "compras", "purchases", "leads", "conversões"]),
      ctr: extract_metric(table, headers, ["ctr", "taxa de cliques"]),
      cpc: extract_metric(table, headers, ["cpc", "custo por clique"]),
      roas: extract_metric(table, headers, ["roas", "retorno sobre o investimento", "retorno sobre anúncio"]),
      cpm: extract_metric(table, headers, ["cpm", "custo por mil"]),
      page_views: extract_metric(table, headers, ["visualizações de página", "page views", "visualizacoes"])
    }
  end

  def extract_metric(table, headers, keywords)
    # Busca a coluna que melhor se encaixa nas palavras-chave
    column = headers.find { |h| keywords.any? { |kw| h.downcase.strip.include?(kw) } }
    return 0.0 unless column

    values = table.map { |row| parse_numeric_value(row[column.to_sym]) }.compact

    # Médias para taxas/custos unitários; Soma para volumes
    is_average = keywords.any? { |k| ["ctr", "cpc", "roas", "cpm"].include?(k) }
    is_average ? (values.sum / [values.size, 1].max).round(2) : values.sum
  end

  def parse_numeric_value(val)
    return nil if val.blank? || val.to_s.match?(/[a-zA-Z]{3,}/) # Ignora strings longas

    v = val.to_s.dup
    # Lógica de Moeda/Número (BR vs US)
    if v.match?(/\d+\.\d+,\d+/) # Formato 1.000,50
      v.gsub!('.', ''); v.gsub!(',', '.')
    elsif v.match?(/\d+,\d+/) && !v.include?('.') # Formato 10,50
      v.gsub!(',', '.')
    elsif v.include?(',') # Formato 1,000.50
      v.gsub!(',', '')
    end
    v.gsub(/[^0-9.\-]/, '').to_f
  end

  def run_technical_health_check(m)
    checks = []
    checks << "DADO CRÍTICO: Menos de 10 PageViews (Pixel/API fora do ar ou mal configurado)." if m[:page_views].to_f < 10
    checks << "ALERTA: Poucos dados de conversão (#{m[:conversions]}) para otimização de IA da Meta." if m[:conversions].to_f < 5
    checks << "ROI: ROAS abaixo de 1.0. Campanha operando em prejuízo direto." if m[:roas].to_f < 1.0 && m[:roas].to_f > 0
    checks << "CPM: Analise se o CPM está muito alto para o nicho #{@segmento}." if m[:cpm].to_f > 30
    checks.any? ? checks.join(" | ") : "Conexão de dados e rastreio estáveis."
  end

  # =========================================================
  # AUXILIARES (VISUAL & ERRORS)
  # =========================================================

  def prepare_visual_assets
    return [] unless @analysis.ad_artworks.attached?

    @analysis.ad_artworks.limit(MAX_VISUAL_ASSETS).map do |artwork|
      {
        inline_data: {
          mime_type: artwork.content_type,
          data: Base64.strict_encode64(artwork.download)
        }
      }
    end
  end

  def validate_attachment(attachment, label)
    return true if attachment.attached?
    @analysis.update(ai_feedback: "### ❌ Erro de Input\nO agente não encontrou o #{label}. Por favor, anexe o arquivo para continuar.", status: 'failed')
    false
  end

  def handle_error(msg)
    Rails.logger.error "[AIOX-ERROR] ID: #{@analysis.id} | #{msg}"
    @analysis.update(ai_feedback: "### 🚨 Falha no Processamento\n#{msg}", status: 'failed')
  end

  def log_api_error(resp)
    Rails.logger.error "[AIOX-API-FAIL] Status: #{resp.status} | Body: #{resp.body}"
  end
end
