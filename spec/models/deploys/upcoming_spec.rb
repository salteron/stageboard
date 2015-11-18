require 'rails_helper'

RSpec.describe Deploys::Recent, type: :model do
  describe 'validation' do
    describe 'finished_at' do
      context 'when not empty' do
        let(:deploy) { build(:upcoming_deploy) }
        before { deploy.finished_at = Time.now }
        it { expect(deploy).to_not be_valid }
      end

      context 'when empty' do
        let(:deploy) { build(:upcoming_deploy) }
        it { expect(deploy).to be_valid }
      end
    end

    describe '#stage_not_locked' do
      context 'when stage is not locked' do
        let(:deploy) { build(:upcoming_deploy) }
        before { allow(deploy.stage).to receive(:locked?).with(any_args).and_return(false) }
        it { expect(deploy).to be_valid }
      end

      context 'when stage is not locked' do
        let(:deploy) { build(:upcoming_deploy) }
        before { allow(deploy.stage).to receive(:locked?).with(any_args).and_return(true) }
        it do
          expect(deploy).to_not be_valid
        end
      end
    end
  end
end
