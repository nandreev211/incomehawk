class NotesController < ApplicationController
  respond_to :js
  inherit_resources
  def create
    @project = Project.find(params[:project_id])
    # @organization = Organization.find(params[:organization_id])
    params[:note][:user_id] = current_user.id
    @note = @project.notes.create(params[:note])
    respond_to do |format|
      format.js
    end
  end

  def update
    @note = Note.find(params[:id])
    if @note.user.id == current_user.id
      @updated = true
      update!
    else
      @updated = false
      respond_with @note
    end
  end

  def destroy
    @note = Note.find(params[:id])
    if @note.user.id == current_user.id
      @updated = true
      destroy!
    else
      @updated = false
      respond_with @note
    end
  end
end
