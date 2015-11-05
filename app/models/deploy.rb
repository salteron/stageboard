class Deploy < ActiveRecord::Base
  belongs_to :stage
  validates :stage_id, :branch, presence: true
end
