# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    user       { build(:user) }
    status     { 'ON_HOLD' }
    product_id { Product.first.id }
  end
end
