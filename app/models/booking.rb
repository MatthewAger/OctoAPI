# frozen_string_literal: true

class Booking < ApplicationRecord
  STATUSES = {
    ON_HOLD: 'ON_HOLD',
    EXPIRED: 'EXPIRED',
    CONFIRMED: 'CONFIRMED',
    CANCELLED: 'CANCELLED'
  }.freeze

  belongs_to :user

  validates :status, presence: true
  validates :product_id, presence: true
  validates :client_secret, presence: true

  def confirm!
    update!(status: STATUSES[:CONFIRMED])
  end
end
