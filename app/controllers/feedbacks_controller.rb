class FeedbacksController < ApplicationController
  layout 'garden'
  
  def index
    if request.get?
      @contact = Contact.new
    else                             
      @contact = Contact.new(params[:contact])
      Rails.logger.info @contact.email

      if @contact.valid?
        ContactsMailer.mail_contact(@contact).deliver
        flash[:notice] = "Your message was sent"
        redirect_to "/"
      end
    end
  end
  
end