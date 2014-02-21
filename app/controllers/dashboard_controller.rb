class DashboardController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :check_user_logged_in!
  before_filter :fetch_tabs
  layout 'garden'

  def index
    redirect_to current_organization_path
  end

  private

  def check_user_logged_in!
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
  end
end