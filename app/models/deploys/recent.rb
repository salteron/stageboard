# coding: utf-8
module Deploys
  class Recent < ::Deploy
    self.table_name = :deploys

    before_validation :refresh_finished_at

    private

    def refresh_finished_at
      self.finished_at = Time.now
    end
  end
end
