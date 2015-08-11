require 'spec_helper'

RSpec.describe Digestifier::Setting, type: :model do
  describe '.for' do
    let(:setting)   { double 'Setting' }
    let(:recipient) { double 'Recipient', id: 389 }

    it 'returns an existing setting' do
      allow(Digestifier::Setting).to receive(:where).and_return([setting])

      expect(Digestifier::Setting.for(recipient)).to eq(setting)
    end

    it 'creates a new setting if it does not exist' do
      allow(Digestifier::Setting).to receive(:where).and_return([])
      allow(Digestifier::Setting).to receive(:create).and_return(setting)

      expect(Digestifier::Setting.for(recipient)).to eq(setting)
    end

    it 'retries find if create raises an exception' do
      attempts = 0
      allow(Digestifier::Setting).to receive(:where).and_return([])
      allow(Digestifier::Setting).to receive(:create) do |attributes|
        attempts += 1
        raise ActiveRecord::RecordNotUnique, 'fail' if attempts <= 1
        setting
      end

      expect(Digestifier::Setting.for(recipient)).to eq(setting)
    end

    it 'raises an error if create fails twice' do
      attempts = 0
      allow(Digestifier::Setting).to receive(:where).and_return([])
      allow(Digestifier::Setting).to receive(:create) do |attributes|
        attempts += 1
        raise ActiveRecord::RecordNotUnique, 'fail' if attempts <= 2
        setting
      end

      expect { Digestifier::Setting.for(recipient) }.
        to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
