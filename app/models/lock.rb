class Lock < ActiveRecord::Base
  validates :stage_id, :initiated_by, :expired_at, presence: true

  before_save :normalize_branch_whitelist

  belongs_to :stage

  def active?(branch = nil)
    expired_at >= Time.now.utc && whitelist.exclude?(branch)
  end

  def expired?(branch = nil)
    !active?(branch)
  end

  def whitelist
    branch_whitelist.split(',')
  end

  private

  def normalize_branch_whitelist
    return if branch_whitelist.nil? || !branch_whitelist_changed?
    self.branch_whitelist = branch_whitelist.gsub(/\s+/, '').gsub(/,+/, ',').split(',').compact.uniq.sort!.join(',')
  end
end
