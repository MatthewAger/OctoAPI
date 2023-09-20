# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings, id: :uuid do |t|
      t.belongs_to :user, null: false, type: :uuid, foreign_key: true, index: true
      t.string :status, null: false, default: 'ON_HOLD'
      t.string :product_id, null: false
      t.string :client_secret, null: false

      t.timestamps
    end
  end
end
