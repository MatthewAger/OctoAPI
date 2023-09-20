# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  it { should be_valid }
  # it { is_expected.to validate_presence_of(:email) }
  # it { is_expected.to validate_uniqueness_of(:email) }
  # it { is_expected.to validate_presence_of(:jti) }
  # it { is_expected.to validate_uniqueness_of(:jti) }

  describe '#jwt_payload' do
    it 'returns the user jti' do
      expect(subject.jwt_payload).to eq({ 'jti' => subject.jti })
    end
  end
end
