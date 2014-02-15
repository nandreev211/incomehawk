# coding: utf-8
require 'spec_helper'

describe Project do

  before(:each) do
    User.delete_all
  end

  ## Factory
  it 'should have a valid factory' do
    build(:project).should be_valid
  end

  # Validations ##

  %w{name organization status}.each do |field|
    it "should validate presence of #{field}" do
      project = build(:project, field.to_sym => nil)
      project.should_not be_valid
      project.errors[field.to_sym].include?("can't be blank").should be_true
    end
  end

  it "should validate inclusion of status in constant" do
    project = build(:project, :status => 'dummy')
    project.should_not be_valid
    project.errors[:status].include?("is not included in the list").should be_true
  end


  # Named scopes ##

  # Associations ##

  # Methods ##
end