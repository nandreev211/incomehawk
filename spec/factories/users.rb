FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "user#{n}" }
    sequence(:email) {|n| "user#{n}@gmail.com" }
    password "123456"
  end
end