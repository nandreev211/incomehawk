class ProjectContactsController < ApplicationController
  respond_to :js
  
  def destroy
    @project = @organization.projects.find(params[:project_id])
    @contact = @organization.contacts.find(params[:id])
    if @project.contact_ids.include? params[:id].to_i
      @project.contact_ids = @project.contact_ids - [params[:id].to_i]
      @project.save
      @updated = true
    else 
      @updated = false
    end
    
    respond_to do |format|
      format.js
    end
  end
end