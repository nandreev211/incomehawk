class ApplicationController < ActionController::Base

  protect_from_forgery

  layout :layout_by_resource

  before_filter :authenticate_app
  before_filter :init_organization
  before_filter :init_sidebar

  helper :all

  #if users sign in for the first time, then redirects to tour page
  def after_sign_in_path_for(resource)
    if current_user.sign_in_count == 1
      '/welcome'
    else
      current_organization_path
    end
  end

  def after_sign_out_path_for(resource)
    '/users/sign_in'
  end


  private

  def authenticate_app
    authenticate_user! unless staff_path?
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user
      "login"
    else
      "application"
    end
  end

  def http_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "idan" && password == "cylonsonly"
    end
  end

  def init_organization
    if current_user
      @organization ||= Organization.find_by_admin_id(current_user.id)
    end
  end

  def staff_path?
    request.path_parameters[:controller] =~ /(devise|admin|dashboard)/
  end

  def current_organization
    fetch_organization
  end

  def current_organization_path
    return organization_path(:id => current_user.own_organization) if current_user
  end

  def load_categories
    @categories ||= current_organization.categories if current_user
  end

  def fetch_tabs
    @current_tab ||= controller_name
  end

  def init_sidebar
    if @organization
      init_sidebar_upcoming_payments
      init_sidebar_overdue_payments
    end
  end

  def init_sidebar_upcoming_payments
    @upcoming_today_payments     = @organization.payments.upcoming_today.to_a
    @upcoming_tomorrow_payments  = @organization.payments.upcoming_tomorrow.to_a
    @upcoming_next_week_payments = @organization.payments.upcoming_next_week.to_a
  end

  def init_sidebar_billed_payments
    @billed_payments = @organization.payments.paid.order("completed_date DESC").limit(5)
  end

  def init_sidebar_overdue_payments
    @overdue_payments = @organization.payments.sidebar_overdue
  end
end
