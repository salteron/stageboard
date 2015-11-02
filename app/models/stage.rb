class Stage < ActiveRecord::Base
  validates :name, :url, presence: true, uniqueness: true

  before_create :generate_uuid

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
