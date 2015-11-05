class Stage < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true

  before_create :generate_uuid

  has_one :recent_deploy, -> { where.not finished_at: nil }, class_name: 'Deploy', dependent: :destroy
  has_one :upcoming_deploy, -> { where finished_at: nil }, class_name: 'Deploy', dependent: :destroy

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
