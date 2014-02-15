require 'spec_helper'

describe ProjectsController do
  login_user

  before(:each) do
    @organization = Factory(:organization)
    @project = Factory(:project, :organization => @organization)
  end
  
  describe :index do 
    it "should get index" do
      get :index, :organization_id => @organization.id
      response.should be_success
    end
  end

  describe :new do 
    it "should get new" do
      get :new, :organization_id => @organization.id
      response.should be_success
    end
  end
  
  describe :show do
   it "shows a project" do
     get :show, :id => @project.id.to_s, :organization_id => @organization.id.to_s
     assigns(:project).should eq(@project)
     assigns(:organization).should eq(@project.organization)
     response.should be_success
   end
  end
  
  describe :create do
    let(:valid_project) {Factory.build :project}
    let(:invalid_project) {Factory.build :project, :name => nil}
    
    context "success" do
      it "should redirect to show" do
         post :create, :project => valid_project
         response.should redirect_to(project_path(assigns(:project)))
       end
    end
    
    context "fail" do 
      it "should render new" do
        post :create, :project => invalid_project
        response.should render_template(:new)
      end 
    end
  end
end