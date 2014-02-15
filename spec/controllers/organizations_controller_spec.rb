require 'spec_helper'

describe OrganizationsController do
  before(:all) do
    Organization.delete_all
    User.delete_all
    @user = Factory(:user)
    @organization = @user.own_organization
    @project = Factory(:project, :organization => @organization)
  end
    
  it "should authenticate user" do 
    get :show, :id => @organization.id.to_s
    response.should redirect_to('/users/login')
  end
    
  describe "GET show" do
    before(:each) do 
      sign_in @user
    end
    
    context "owning organization id" do
      it "assign projects by type" do
        get :show, :id => @organization.id.to_s
        assigns(:organization).should eq(@organization)
        # assigns(:projects).should_not be_empty
      end
    end
    
    context "not owning organization id" do
      it "assigns the requested organization as @organization" do
        org = Factory.create :organization
        get :show, :id => org.id.to_s
        response.should redirect_to(@user.own_organization)
      end
    end
  end
  
  # describe "success" do
  #   before(:each) do
  #     @company = Factory(:company)
  #   end
  # 
  #   it "should create a vote" do
  #     lambda do
  #       post :create, :company_id => @company
  #     end.should change(Vote, :count).by(1)
  #   end
  # 
  #   it "should redirect to company profile" do
  #     post :create, :company_id => @company
  #       response.should redirect_to(@company)
  #     end
  #   end
  # end
  
  
end
