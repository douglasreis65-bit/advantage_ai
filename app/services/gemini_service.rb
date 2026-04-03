class GeminiService
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

  def initialize(analysis)
    @analysis = analysis
    @api_key = ENV['GEMINI_API_KEY']
  end

  def call
    prompt = construct_prompt

    options = {
      query: { key: @api_key },
      headers: { "Content-Type" => "application/json" },
      body: {
        contents: [{ parts: [{ text: prompt }] }]
      }.to_json
    }

    response = self.class.post("", options)

    if response.success?
      response.parsed_response.dig("candidates", 0, "content", "parts", 0, "text")
    else
      "Erro na análise: #{response.code}"
    end
  end

  private

  def construct_prompt
    <<~PROMPT
      Você é um especialista em tráfego pago e CRO.
      Analise os seguintes dados de conversão (Pixel + API) para o negócio #{@analysis.business_name}:
      - Page Views: #{@analysis.events_page_views}
      - Add to Cart: #{@analysis.events_add_to_cart}
      - Purchases: #{@analysis.events_purchase}

      Plataforma: #{@analysis.business_platform}
      Objetivo: #{@analysis.campaign_objective}

      Por favor, forneça um diagnóstico detalhado do funil, identifique gargalos e sugira melhorias nos anúncios.
    PROMPT
  end
end
