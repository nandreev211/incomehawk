class ProjectsController < ApplicationController
  inherit_resources
  before_filter :fetch_tabs
  respond_to :js, :html

  rescue_from ActiveRecord::RecordNotFound do |ex|
    redirect_to '/'
  end

  layout 'garden'
  nested_belongs_to :organization

  def show
    @project = Project.includes(:category, :notes => :user).find(params[:id])
    @organization = @project.organization
  end

  def index
    max_projects = Project::MAX_LIMIT
    @status = params[:status] || "Active"
    @page = params[:page] ? params[:page].to_i : 0
    @projects = @organization.projects.includes(:payments, :notes, :category).where(["status = ?", @status])
    unless @page == 0
      @projects = @projects.limit(max_projects).offset(@page*max_projects)
    end

    # expand collapse
    @projects_count = @organization.projects.where(["status = ?", @status]).count
    @diff = @projects_count - (@page+1)*max_projects
    if @diff == max_projects
      @has_next_page = true
      @page += 1
    elsif @diff < max_projects && @diff > 1
      @has_next_page = true
      @projects_left = @diff
      @page += 1
    elsif @diff > max_projects
      @has_next_page = true
      @page += 1
    elsif @diff < 1
      @has_next_page = false
    end
    @projects = @projects.to_a
  end

  def update_status
    status = params[:status]
    update_payments = params[:update_payments]
    @project = Project.find(params[:project_id])
    @project.update_status(status, update_payments == '1')
    respond_to do |format|
      format.js
    end
  end

  def create
    @project = @organization.projects.build(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project }
      else
        format.html { render :new }
      end
    end
  end
end
