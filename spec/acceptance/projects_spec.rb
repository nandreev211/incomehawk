require 'acceptance/acceptance_helper'

feature 'Projects' do

  # scenario "Project index" do
  #   Project.create!(:name => 'One')
  #   Project.create!(:name => 'Two')
  #   visit Project_index
  #   page.should have_content('One')
  #   page.should have_content('Two')
  # end
  
  # scenario "Subscribing to a thread" do
  # 
  #   #Given I've commented in a thread
  #   thread = Factory(:discussion)
  #   me = Factory(:hacker)
  #   reply = Factory(:reply, :author => me.username, :author_email => me.email)
  #   thread.replies << reply
  # 
  #   Pony.should_receive(:deliver) do |mail|
  #     mail.to.should == [ me.email ]
  #     mail.body.to_s.should =~ /\/forums\/#{thread.forum}\/#{thread.slug}/
  #   end
  # 
  #   #When someone else makes a comment
  #   somebody = Factory(:hacker)
  #   log_in somebody
  #   visit "/forums/#{thread.forum}/#{thread.slug}"
  #   click_link "Reply"
  #   fill_in "Body", :with => "Here's my take on things: Dream big!"
  #   click_button "Create Reply"
  # 
  #   #   Then I should receive an email
  #   #   (see pony block above)
  #   #   And it should have a link to that thread
  #   #   (see pony block above)
  # end                
end
