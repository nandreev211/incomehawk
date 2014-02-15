module HelperMethods

  def log_in_with(user)
    visit "/"
    fill_in "user_email",     :with => user.email
    fill_in "user_password", :with => user.password
    click_button "login"
  end
  
  [:notice, :error, :alert].each do |name|
    define_method "should_have_#{name}" do |message|
      page.should have_css(".#{name}", :text => message)
    end
  end
  
  def should_be_on(path)
    page.current_url.should match(Regexp.new(path))
  end
  
  def should_not_be_on(path)
    page.current_url.should_not match(Regexp.new(path))
  end
  
  def should_have_errors(*messages)
    within(:css, ".alert") do
      messages.each { |msg| page.should have_content(msg) }
    end
  end
  alias_method :should_have_error, :should_have_errors
   
  def fill_the_following(fields={})
    fields.each do |field, value|
      fill_in field,  :with => value
    end
  end                                                         
   
  def should_have_the_following(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end
  
  def should_have_table(table_name, *rows)
    within(table_name) do
      rows.each do |columns|
        columns.each { |content| page.should have_content(content) }
      end
    end
  end
  
   
end

RSpec.configuration.include HelperMethods, :type => :acceptance
