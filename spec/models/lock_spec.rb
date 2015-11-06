require 'rails_helper'

RSpec.describe Lock, type: :model do
  let(:lock) { build(:lock) }

  describe '#normalize_branch_whitelist' do
    context 'when nil' do
      before { lock.branch_whitelist = nil }
      it { expect { lock.save }.to_not change { lock.branch_whitelist }  }
    end

    context 'when not changed' do
      it { expect { lock.save }.to_not change { lock.branch_whitelist }  }
    end

    context 'when whitespaces, duplicates, unsorted' do
      before { lock.branch_whitelist = 'b  , c ,,   a, d,a,a,d' }
      it { expect { lock.save }.to change { lock.branch_whitelist }.to('a,b,c,d') }
    end
  end

  describe '#active? & #expired?' do
    context 'when expired earlier' do
      let(:lock) { create(:lock, expired_at: 12.hours.ago) }

      it { expect(lock.active?).to be_falsey }
      it { expect(lock.active?('develop')).to be_falsey }
      it { expect(lock.active?('feature')).to be_falsey }

      it { expect(lock.expired?).to be_truthy }
      it { expect(lock.expired?('develop')).to be_truthy }
      it { expect(lock.expired?('feature')).to be_truthy }
    end

    context 'when expiring in future' do
      let(:lock) { create(:lock, expired_at: 12.hours.from_now) }

      it { expect(lock.active?).to be_truthy }
      it { expect(lock.active?('develop')).to be_falsey }
      it { expect(lock.active?('feature')).to be_truthy }

      it { expect(lock.expired?).to be_falsey }
      it { expect(lock.expired?('develop')).to be_truthy }
      it { expect(lock.expired?('feature')).to be_falsey }
    end
  end
end
