class ContactsController < ApplicationController
  inherit_resources
  before_filter :fetch_tabs
  layout 'garden'
  nested_belongs_to :organization
  respond_to :html, :js

  def new
    @contact = Contact.new
    respond_to do |format|
      format.html
      format.js { render :new, :layout => false,  :content_type => 'text/html' }
    end
  end

  def index
    filter = if params[:term]
      term = "%#{params[:term].downcase}%"
      ["LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?", term, term, term]
    else
      ''
    end

    @contacts = @organization.contacts.where(filter)
    respond_to do |format|
      format.html
      format.js
      format.json { render :text => @contacts.collect(&[:name, :email, :id]).to_json }
    end
  end

  def filter
    filter = if params[:contact] && params[:contact][:name]
      term = "%#{params[:contact][:name].downcase}%"
      ["LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?", term, term, term]
    else
      ''
    end
    @contacts = @organization.contacts.where(filter)
    respond_to do |format|
      format.html { render :index }
      format.js { render :index }
    end
  end

  def destroy
    @contact = @organization.contacts.find(params[:id])
    @id = @contact.id
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_path }
      format.js
    end
  end

  def create
    super do |format|
      format.html {
          if @contact.errors.messages.length == 0
            if params[:contact][:tmp_upload]
              @contact.avatar = TmpUpload.find(params[:contact][:tmp_upload]).avatar
              @contact.save
            end
            redirect_to contacts_path, :notice => "Contact Successfully added Hooray! "
          else
            flash[:error] = "Following errors prevent contact from saving"
            render :new
          end
        }
      format.js
    end
  end

  def show
    show! {
      @projects             = @contact.projects.includes(:payments, :notes, :category)
      @active_projects      = @projects.select(&:active?)
      @prospective_projects = @projects.select(&:prospective?)
      @lost_projects        = @projects.select(&:lost?)
      @completed_projects   = @projects.select(&:completed?)
    }
  end

  def hover
    @contact = Contact.find(params[:id])
    render :partial => 'projects/contact_hover', :locals => {:contact => @contact}, :layout => false
  end
end