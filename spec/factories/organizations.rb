FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Organization#{n}" }
    admin {|a| a.association(:user) }
    plan {|a| a.association(:plan) }
    color_scheme "blue"
    currency "$"
  end
end