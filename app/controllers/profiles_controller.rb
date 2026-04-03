class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    # O Rails vai buscar automaticamente a view em app/views/profiles/show.html.erb
  end
end
