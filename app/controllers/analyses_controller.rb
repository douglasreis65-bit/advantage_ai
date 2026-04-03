class AnalysesController < ApplicationController
  before_action :authenticate_user!

  def select_type
  # Apenas renderiza a página de escolha
  end
  def show
    # Busca pelo ID ou pelo Token Público
    @analysis = Analysis.find_by(id: params[:id]) || Analysis.find_by!(public_token: params[:id])
  end

  def new
    @analysis = Analysis.new

    # Se o tipo for performance, renderiza a view de performance,
    # caso contrário, a de criativos.
    if params[:type] == 'performance'
      render :new_performance
    else
      render :new_creative
    end
  end

  def create
    @analysis = current_user.analyses.build(analysis_params)

    if @analysis.save
      # Integramos o Synkra aqui.
      # Se o processamento for rápido, chamamos direto.
      # Se for pesado, futuramente usamos um Job (Sidekiq/SolidQueue).
      SynkraAiService.new(@analysis).call

      redirect_to analysis_path(@analysis), notice: "Análise criada! O SynkraAI está gerando seu diagnóstico..."
    else
      # Se der erro, precisamos saber qual view re-renderizar
      render @analysis.analysis_type == 'performance' ? :new_performance : :new_creative, status: :unprocessable_entity
    end
  end

  private

  def analysis_params
    params.require(:analysis).permit(
      :analysis_type,
      :business_profile_id, # Importante para vincular à empresa cadastrada
      :campaign_objective,
      :campaign_csv,        # O arquivo de métricas para o aiox-core
      ad_artworks: [],      # As artes para análise de criativos
      event_manager_screenshots: [] # Prints do Gerenciador de Eventos
    )
  end
end
