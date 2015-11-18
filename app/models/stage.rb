class Stage < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true

  before_create :generate_uuid

  has_one :recent_deploy, -> { where.not finished_at: nil }, class_name: 'Deploys::Recent', dependent: :destroy
  has_one :upcoming_deploy, -> { where finished_at: nil }, class_name: 'Deploys::Upcoming', dependent: :destroy

  has_one :lock, dependent: :destroy

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def locked?(branch = nil)
    lock.present? && lock.active?(branch)
  end
end
