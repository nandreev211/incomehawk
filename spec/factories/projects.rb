FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project#{n}" }
    organization {|a| a.association(:organization)}
    status Project::STATUSES.sample
  end
end