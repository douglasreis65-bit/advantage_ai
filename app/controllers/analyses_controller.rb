class AnalysesController < ApplicationController
  before_action :authenticate_user!

  def select_type
    # Apenas renderiza a página de escolha (index ou similar)
  end

  def show
    # Busca pelo ID ou pelo Token Público de forma segura
    @analysis = current_user.analyses.find_by(id: params[:id]) ||
                Analysis.find_by!(public_token: params[:id])
  end

  def new
    # Inicializa o objeto com o tipo já definido para que o simple_form saiba o que exibir
    @analysis = current_user.analyses.build(analysis_type: params[:type])

    # Renderização condicional baseada no parâmetro
    if @analysis.analysis_type == 'performance'
      render :new_performance
    else
      render :new_creative
    end
  end

  def index
    @analyses = current_user.analyses.order(created_at: :desc)

    # Aplica o filtro se o parâmetro :type estiver presente
    if params[:type].present?
      @analyses = @analyses.where(analysis_type: params[:type])
    end
  end

  def create
    @analysis = current_user.analyses.build(analysis_params)

    if @analysis.save
      # Dispara o Motor SynkraAI
      # Nota: Como o arquivo pode ser grande, o .call deve ser otimizado ou movido para Job
      SynkraAiService.new(@analysis).call

      redirect_to analysis_path(@analysis), notice: "Análise iniciada! O SynkraAI está processando seus dados..."
    else
      # IMPORTANTE: Se o save falhar (ex: faltou o CSV), precisamos manter o estado na View
      view_to_render = @analysis.analysis_type == 'performance' ? :new_performance : :new_creative
      render view_to_render, status: :unprocessable_entity
    end
  end

  private

  def analysis_params
    params.require(:analysis).permit(
      :analysis_type,
      :business_profile_id,
      :campaign_objective,
      :purchase_type,
      :conversion_location,
      :performance_goal,
      :campaign_csv,
      ad_artworks: [],
      event_manager_screenshots: []
    )
  end
end
