# coding: utf-8
module Deploys
  class Upcoming < ::Deploy
    self.table_name = :deploys

    validates :finished_at, absence: true
    validate :stage_not_locked

    private

    def stage_not_locked
      return unless stage.locked?(branch)
      errors.add(:base, :stage_locked)
    end
  end
end
