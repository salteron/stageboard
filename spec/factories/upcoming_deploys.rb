FactoryGirl.define do
  factory :upcoming_deploy, class: Deploys::Upcoming do
    association :stage
    sequence(:branch) { |n| "feature#{n}" }
    sequence(:initiated_by) { |n| "user#{n}" }
  end
end
