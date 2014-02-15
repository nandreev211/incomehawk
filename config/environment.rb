# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bacon::Application.initialize!

# Set the smtp settings for mailer
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address              => "smtp.mandrillapp.com",
    :port                 => 587,
    :domain               => "incomehawk.com",
    :user_name            => "idan@pixelwrapped.com",
    :password             => "yzCEaNQdpLNITk1pt2jPWQ",
    :authentication       => "plain",
    :enable_starttls_auto => true
}