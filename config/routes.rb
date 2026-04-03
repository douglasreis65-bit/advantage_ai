Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Certifique-se de que o :new está incluído no only:
  resources :analyses, only: [:index, :show, :create, :new] do
    collection do
      get :select_type
    end
  end

  resources :business_profiles, except: [:show, :index]
  get '/profile', to: 'profiles#show', as: :profile
end
