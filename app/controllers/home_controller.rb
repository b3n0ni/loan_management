class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to user_dashboard_index_path
    else
      render 'welcome'
    end
  end
end
