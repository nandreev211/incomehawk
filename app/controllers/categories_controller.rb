class CategoriesController < ApplicationController
  inherit_resources
  before_filter :fetch_tabs
  layout 'garden'
  nested_belongs_to :organization


  def index
    @categories = @organization.categories
    respond_to do |format|
      format.html
      format.js {
        render :index, :layout => false,  :content_type => 'text/html'
      }
    end
  end

  def show
    @category = @organization.categories.find(params[:id])
  end

  def new
    @categories = @organization.categories
    @category = Category.new
    respond_to do |format|
      format.html
      format.js { render :index, :layout => false,  :content_type => 'text/html' }
    end
  end

  def create
    params[:category][:color] ||= '#cc2222'
    @category = @organization.categories.build(params[:category])
    if @category.save
      @categories = @organization.categories
      respond_to do |format|
        format.html
        format.js
      end
    else
      respond_to do |format|
        format.js { render :json => 'fail'}
      end
    end
  end

  def edit
    @category = @organization.categories.find(params[:id])
  end

  def update
    @category = @organization.categories.find(params[:id])
    if params[:category][:color]
      params[:category][:color] = Category.colorname2color(params[:category][:color])
      @update_color = 1
    elsif params[:category][:name]
      @update_name = 1
    end
    if @category.update_attributes(params[:category])
      respond_to do |format|
        format.js
      end
    else
      render :action => 'edit'
    end
  end

  def update_color
    @category = @organization.categories.find(params[:id])
    @category.update_attributes(params[:category])
    if @category.save
      respond_to do |format|
        format.js
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = @organization.categories.find(params[:id])
    if @category.projects.count == 0
      @id = @category.id
      @category.destroy
    else
      @id = false
    end

    respond_to do |format|
      format.html {redirect_to categories_url}
      format.js
    end

  end
end
