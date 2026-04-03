class ApplicationController < ActionController::Base
  # Mantemos as configurações padrão do Rails 8
  allow_browser versions: :modern
  stale_when_importmap_changes

  # Adicionamos o filtro para permitir campos extras no Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permite full_name e photo no Cadastro
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :photo])

    # Permite full_name e photo na Edição de Conta
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :photo])
  end
end
