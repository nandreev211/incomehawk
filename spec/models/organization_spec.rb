# coding: utf-8
require 'spec_helper'

describe Organization do

  before(:each) do
    User.delete_all
  end

  ## Factory
  it 'should have a valid factory' do
    build(:organization).should be_valid
  end

  # Validations ##

  %w{name color_scheme currency admin plan}.each do |field|
    it "should validate presence of #{field}" do
      organization = build(:organization, field.to_sym => nil)
      organization.should_not be_valid
      organization.errors[field.to_sym].include?("can't be blank").should == true
    end
  end

  # Named scopes ##

  # Associations ##

  it 'should own many projects' do
    organization = create(:organization)
    project_1 = create(:project, :organization => organization)
    project_2 = create(:project, :organization => organization)
    organization.projects.should == [project_1, project_2]
  end


  # Methods ##

  describe "color_schemes" do
    it "should return array of color_schemes" do
      cs = Organization.color_schemes
      cs.should be_kind_of Array
      cs.should_not be_empty
    end
  end

  describe "currencies" do
    it "should return array of currencies " do
      cs = Organization.currencies
      cs.should be_kind_of Array
      cs.should_not be_empty
    end
  end
end