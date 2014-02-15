require 'acceptance/acceptance_helper'

feature 'Authentication' do

  
  let :user do
    Factory(:user)
  end
  
  let :invalid_user do
    mock 'User', :email => "jonhdoe", :password => 'invalid'
  end
  
  before(:each) do
    Factory :organization, :admin_id => user.id
  end
  
  scenario "Valid user" do
    
  end                 
  
  scenario "Invalid user" do
    log_in_with invalid_user
    should_have_alert "Invalid email or password."
  end
  
  scenario "Logout" do
    log_in_with user
    click_link "Sign out"
    should_have_alert "You need to sign in or sign up before continuing."
    should_be_on login_page
  end   
  
end
