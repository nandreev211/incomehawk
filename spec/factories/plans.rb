FactoryGirl.define do
  factory :plan do
    sequence(:name) { |n| "Plan #{n}" }
    max_projects 15
    amount 9
  end
end