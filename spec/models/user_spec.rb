# coding: utf-8
require 'spec_helper'

describe User do

  before(:each) do
    User.delete_all
  end

  ## Factory
  it 'should have a valid factory' do
    build(:user).should be_valid
  end

  # Validations ##

  it "should validate presence of email" do
    user = create(:user, :email => 'bryan@gmail.com')
    user.should be_valid
    user2 = build(:user, :email => 'bryan@gmail.com')
    user2.should_not be_valid
  end

  ## callbacks ##
  describe :ac_build_own_organization do
    before(:each) do
      Organization.delete_all
    end

    it "should create organization after user was created" do
      Organization.count.should == 0
      user = create(:user)
      Organization.count.should == 1
    end

    it "should not create organization if user already have one" do
      build(:organization)
      Organization.count.should == 1
    end

  end


  # Methods ##
  it "default_company_name should return organization name based on user email name" do
    user = build(:user, :email => 'bryan@gmail.com')
    user.default_company_name.should == 'bryan organization'
  end
end
