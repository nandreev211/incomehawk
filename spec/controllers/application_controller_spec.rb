require 'spec_helper'

describe ApplicationController do
  before(:all) do
    Organization.delete_all
    User.delete_all
    @user = Factory(:user)
  end
  
  before(:each) do 
    sign_in @user
  end
  
  controller do
    def index
      render :nothing => true
    end
  end

  describe "init_organization" do
    it "should init_organization before every request" do
     controller.should_receive(:init_organization).at_least(:once).and_return(@user.own_organization)
     get :index
     response.should be_success
    end
  end  

  describe "load_categories" do
    it "should load_categories before every request" do
     controller.should_receive(:load_categories).at_least(:once)
     get :index
     response.should be_success
    end
  end  
  
end
