module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end   
  
  def dashboard_page
    current_organization_path
  end
  
  def projects_index
    "/projects"
  end           
  
  def login_page
    "/users/login"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance