class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, :authenticate_user!, :authenticate_app
  before_filter :authenticate_api

  rescue_from ActiveRecord::RecordNotFound do |e|
    render :text => {:errors => e.message}.to_json, :status => :bad_request
  end

  rescue_from IncomeHawk::ApiAuthenticationError do |e|
    render :text => {:errors => "authentication fail"}.to_json, :status => :bad_request
  end
  rescue_from IncomeHawk::ParametersError do |e|
    render :text => {:errors => "insufficient parameters: #{e.message}"}.to_json, :status => :bad_request
  end

  # Parameters:
  #   user[email]
  #   user[password]
  #   user[own_organization_attributes][name]
  #   user[own_organization_attributes][currency]
  #   user[own_organization_attributes][url]
  def create_user
    validate_params :user
    @user = User.new(params[:user])
    if @user.save
      render :text => {:status => 'ok', :id => @user.id}.to_json
    else
      render :text => {:status => 'fail', :errors => @user.errors}.to_json, :status => :bad_request
    end
  end

  # Parameters:
  #   url
  def check_url
    validate_params :url
    url = params[:url]
    ex = Organization.exists?(:url => url)
    render :text => ex ? 'yes' : 'no'
  end

  # Parameters:
  #   id
  #   user fields, see create_user
  def update_user
    validate_params :id, :user
    @user = User.find(params[:id])
    org = params[:user].delete(:own_organization_attributes)
    @user.update_attributes(params[:user])
    @user.own_organization.update_attributes(org) if org
    if @user.save
      render :text => {:status => 'ok', :id => @user.id}.to_json
    else
      render :text => {:status => 'fail', :errors => @user.errors}.to_json, :status => :bad_request
    end
  end

  # Parameters:
  #   id
  def delete_user
    validate_params :id
    @user = User.find(params[:id])
    @user.destroy
    render :text => {:status => 'ok'}.to_json
  end

  def validate_user
    validate_params :user
    if params[:id]
      @user = User.find(params[:id])
      @user.update_attributes(params[:user])
    else
      @user = User.new(params[:user])
    end

    if @user.valid?
      render :text => {:status => 'ok'}.to_json
    else
      render :text => {:status => 'fail', :errors => @user.errors}.to_json, :status => :bad_request
    end

  end

  private
    def authenticate_api
      unless params[:login] == 'idan' && params[:password] == 'cylonsonly'
        raise IncomeHawk::ApiAuthenticationError
      end
      params[:footnotes] = 'false'
    end

    def validate_params(*fields)
      errs = fields.select{|p|
        p if params[p].nil?
      }
      raise IncomeHawk::ParametersError.new(errs.join(', ')) unless errs.empty?
    end
end