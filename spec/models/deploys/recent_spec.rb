require 'rails_helper'

RSpec.describe Deploys::Recent, type: :model do
  describe 'callbacks' do
    describe 'refresh_finished_at' do
      context 'when finished_at is not set' do
        let(:deploy) { build(:recent_deploy, finished_at: nil) }
        it { expect { deploy.valid? }.to change { deploy.finished_at.present? }.from(false).to(true) }
      end

      context 'when finished_at is set' do
        let(:deploy) { build(:recent_deploy) }
        it { expect { deploy.valid? }.to change { deploy.finished_at } }
      end
    end
  end
end
