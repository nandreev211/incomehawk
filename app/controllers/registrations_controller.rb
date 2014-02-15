class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    flash[:notice] = 'Thank you for signing up, we have sent a validation email to your email address, please click the validation link to login.'
    '/users/sign_in'
  end
end