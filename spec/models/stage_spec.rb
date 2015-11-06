require 'rails_helper'

RSpec.describe Stage, type: :model do
  subject { create(:stage) }

  describe 'validations' do
    it { is_expected.to be_valid }

    context 'when url blank' do
      before { subject.url = nil }
      it { is_expected.to_not be_valid }
    end
  end

  describe 'callbacks' do
    describe '#generate_uuid' do
      before { subject.save }
      it { expect(subject.uuid).to_not be_nil }
    end
  end

  describe '#locked?' do
    let(:lock) { create(:lock, stage: subject) }

    context 'when lock present and active' do
      before { allow(lock).to receive(:active?).and_return(true) }
      it { is_expected.to be_locked }
    end

    context 'when lock present and not active' do
      before { allow(lock).to receive(:active?).and_return(false) }
      it { is_expected.to_not be_locked }
    end

    context 'when lock absent' do
      it { is_expected.to_not be_locked }
    end
  end
end
