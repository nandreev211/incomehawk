class FeedbacksMailer < ActionMailer::Base
  default :from => "info@garden.com"

  def mail_contact(contact)
    @contact = contact
    mail(:to => "info@garden.com",
         :from => "\"#{contact.name} #{contact.last_name}\" <#{contact.email}>",
         :subject => @contact.subject) do |format|
      format.html
    end
  end
end