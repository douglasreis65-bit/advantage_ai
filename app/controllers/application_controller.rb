class ApplicationController < ActionController::Base
  # Mantemos as configurações padrão do Rails 8
  allow_browser versions: :modern
  stale_when_importmap_changes

  # Filtro para campos extras no Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permite full_name e photo no Cadastro
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :photo])

    # Permite full_name e photo na Edição de Conta
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :photo])
  end

  # Redirecionamento após o LOGIN (Sign In)
  def after_sign_in_path_for(resource)
    # Limpa qualquer redirecionamento armazenado para garantir o destino
    stored_location_for(resource) || select_type_analyses_path
  end

  # Redirecionamento após o CADASTRO (Sign Up)
  def after_sign_up_path_for(resource)
    # Forçamos o destino para a edição de perfil
    edit_user_registration_path
  end

  # Caso você venha a usar confirmação por e-mail, este método garante o mesmo destino
  def after_inactive_sign_up_path_for(resource)
    edit_user_registration_path
  end
end
