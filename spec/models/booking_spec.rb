# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  subject { create(:booking) }

  it { should be_valid }

  it { should belong_to(:user) }
  # it { should belong_to(:product) } Using ActiveHash for this test

  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:product_id) }
  it { should validate_presence_of(:client_secret) }

  describe '#confirm!' do
    it 'sets the status to CONFIRMED' do
      subject.confirm!
      expect(subject.reload.status).to eq('CONFIRMED')
    end
  end
end
