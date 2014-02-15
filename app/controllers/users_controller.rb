class UsersController < ApplicationController
  inherit_resources
  layout 'garden'

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    #@user.build
    if @user.update_attributes(user_params)
      # Sign in the user by passing validation in case his password changed
      @user.own_organization.update_attributes(params[:organization])
      sign_in @user, :bypass => true
      flash[:notice] = "Organization was successfully updated"
      redirect_to :action => 'show', :controller => 'organizations', :id => @user.own_organization
    else
      render "edit"
    end
  end

  def delete_account
    @user = current_user
    @user.destroy
    #flash[:notice] = "User account deleted successfully"
    redirect_to logout_path
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    #params.required(:user).permit(:current_password, :password, :password_confirmation, :email)
    params.required(:user).permit(:password, :password_confirmation, :email)
  end
end