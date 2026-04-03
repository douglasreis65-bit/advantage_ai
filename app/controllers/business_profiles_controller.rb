class BusinessProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business_profile, only: [:edit, :update, :destroy]

  def new
    if current_user.business_profiles.count >= 5
      redirect_to profile_path, alert: "Você atingiu o limite de 5 empresas cadastradas."
    else
      @business_profile = BusinessProfilesController.new # Ou BusinessProfile.new se o model estiver correto
      @business_profile = current_user.business_profiles.build
    end
  end

  def create
    @business_profile = current_user.business_profiles.build(business_profile_params)
    if @business_profile.save
      redirect_to profile_path, notice: "Empresa cadastrada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @business_profile.update(business_profile_params)
      redirect_to profile_path, notice: "Dados atualizados!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @business_profile.destroy
    redirect_to profile_path, notice: "Empresa removida.", status: :see_other
  end

  private

  def set_business_profile
    @business_profile = current_user.business_profiles.find(params[:id])
  end

  def business_profile_params
    params.require(:business_profile).permit(:name, :segment, :platform, :website_url, :is_whatsapp_lead)
  end
end
