FactoryGirl.define do
  factory :recent_deploy, class: Deploys::Recent do
    association :stage
    sequence(:branch) { |n| "feature#{n}" }
    sequence(:initiated_by) { |n| "user#{n}" }
    finished_at Time.now.utc
  end
end
