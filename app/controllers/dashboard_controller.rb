class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :fetch_tabs
  layout 'garden'

  def index
    redirect_to current_organization_path
  end

end