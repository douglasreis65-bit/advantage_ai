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
    @analysis = Analysis.new(analysis_params)
    @analysis.user = current_user

    if @analysis.save
      # Aqui chamaremos o GeminiService.call(@analysis) em breve!
      redirect_to analysis_path(@analysis), notice: "Análise criada! Processando diagnóstico..."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def analysis_params
    params.require(:analysis).permit(
      :business_name, :business_platform, :product_category,
      :campaign_objective, :events_page_views, :events_add_to_cart,
      :events_purchase, :campaign_csv, ad_artworks: []
    )
  end
end
