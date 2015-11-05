require 'rails_helper'

RSpec.describe Stage, type: :model do
  subject { Stage.new(url: 'url') }

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
end
