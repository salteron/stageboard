FactoryGirl.define do
  factory :stage do
    sequence(:url) { |n| "test#{n}-example.com" }
  end
end
