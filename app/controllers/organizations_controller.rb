class OrganizationsController < ApplicationController
  inherit_resources
  layout 'dashboard'

  before_filter :fetch_tabs
  before_filter :authenticate_user!, :except => :show
  #before_filter :organization_admin, :only => [:show]
  skip_before_filter :authenticate_user!, :only => [:check_url, :upload]
  before_filter :filter_plan_id, :only => :update

  def show
    unless user_signed_in?
      redirect_to login_path
    else
      current_month

      load_header_bars
      @projects = @organization.projects.includes(:payments, :notes, :category)
      @active_projects = @projects.select(&:active?)
      @prospective_projects = @projects.select(&:prospective?)
      @lost_projects = @projects.select(&:lost?)
      @completed_projects = @projects.select(&:completed?)
      @this_month_payments = @organization.this_month_payments(@year, @month)
      @next_month_payments = @organization.next_month_payments(@year, @month)
    end
  end

  def update
    if params[:organization][:notice_demo]
      @organization.update_attributes(params[:organization])
    end
  end

  def welcome
    unless user_signed_in?
      redirect_to login_path
    else
      current_month

      load_header_bars
      @projects = @organization.projects.includes(:payments, :notes, :category)
      @active_projects = @projects.select(&:active?)
      @prospective_projects = @projects.select(&:prospective?)
      @lost_projects = @projects.select(&:lost?)
      @completed_projects = @projects.select(&:completed?)
      @this_month_payments = @organization.this_month_payments(@year, @month)
      @next_month_payments = @organization.next_month_payments(@year, @month)
    end
  end

  def switch_month
    current_month

    load_header_bars
    @projects = @organization.projects.includes(:payments, :notes, :category)
    @active_projects = @projects.select(&:active?)
    @prospective_projects = @projects.select(&:prospective?)
    @lost_projects = @projects.select(&:lost?)
    @completed_projects = @projects.select(&:completed?)
    @this_month_payments = @organization.this_month_payments(@year, @month)
    @next_month_payments = @organization.next_month_payments(@year, @month)
  end

  def search
    term = params[:term]
    @contacts = @organization.contacts.search_for(term)
    @projects = @organization.projects.search_for(term)
    @categories = @organization.categories.search_for(term)

    respond_to do |format|
      format.js {
        json = Project.json_data(@projects)
        json.concat(Contact.json_data(@contacts))
        json.concat(Category.json_data(@categories))
        render :json => json.to_json
      }
    end
  end

  def upload
    @tmp = TmpUpload.new({:avatar => params[:Filedata]})
    if @tmp.save
      render :json => {:customer_logo => @tmp.avatar.url(:thumb), :tmp_id => @tmp.id}.to_json
    else
      render :json => {:errors => @tmp.errors.full_messages}, :status => :bad_request
    end
  end

  #delete demo projects
  def delete_demo_projects
    @organization.demo_projects.each {|x|
      x.destroy
    }

    @organization.demo_contacts.each {|x|
      x.destroy
    }

    flash[:notice] = "Demo projects are deleted successfully"
    redirect_to :action => 'show', :controller => 'organizations', :id => @organization
  end

  private
  # def organization_admin
  #   # redirect_to root_path(:subdomain => @organization.url) unless @organization.id == params[:id].to_i
  #   redirect_to root_path(:subdomain => @organization.url) if params[:id]
  # end

  def load_header_bars
    last_5_months_payments = @organization.last_5_months_payments(@year, @month).to_a
    @five_months_total = last_5_months_payments.sum(&:total_value)
    @last_5_months_totals = {}
    (-3..1).to_a.each{|i|
      start = (Date.new(@year, @month) + i.months).beginning_of_month
      ends = (Date.new(@year, @month) + i.months).end_of_month
      payments = last_5_months_payments.select{|x| x.start_date >= start && x.start_date <= ends}
      total = if payments
                payments.sum(&:total_value)
              else
                0
              end
      @last_5_months_totals[i] = total
    }
    #@year.admin
  end

  def filter_plan_id
    params[:organization].delete(:plan_id)
  end

  def current_month
    @year = params[:year] ? params[:year].to_i : Time.now.year
    @month = params[:month] ? params[:month].to_i : Time.now.month
    @month_str = Date::MONTHNAMES[@month]
    @lastmonth = Date.new(@year, @month) - 1.month
    @lastmonth_year = @lastmonth.year
    @lastmonth_month = @lastmonth.month
    @nextmonth = Date.new(@year, @month) + 1.month
    @nextmonth_year = @nextmonth.year
    @nextmonth_month = @nextmonth.month
    @nextmonth_monthstr = Date::MONTHNAMES[@nextmonth_month]
  end
end
