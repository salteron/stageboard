FactoryGirl.define do
  factory :lock do
    association :stage
    sequence(:initiated_by) { |n| "user#{n}" }
    expired_at Time.now.utc
    branch_whitelist 'develop,master'
  end
end
