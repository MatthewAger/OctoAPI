# frozen_string_literal: true

module Octo
  class BookingsController < ApplicationController
    include Authenticatable

    attr_reader :product, :payment_intent

    before_action :fetch_product, only: %i[create]
    before_action :create_payment_intent!, only: %i[create], if: -> { @error.blank? }

    def create
      if @error.blank? && booking.save
        render :show, status: :ok
      else
        @error ||= Error::CODES[:UNPROCESSABLE_ENTITY]
        render 'shared/messages', status: :bad_request
      end

      # TODO: Handle webhook on confirmation (to be triggered in spec)
    end

    private

    def fetch_product
      @product ||= Product.find_by(id: params.dig(:booking, :product_id))
      raise ActiveRecord::RecordNotFound if @product.blank?
    rescue ActiveRecord::RecordNotFound => _e
      @error = Error::CODES[:INVALID_PRODUCT_ID]
    end

    # TODO: Handle request error
    def create_payment_intent!
      @payment_intent ||= Stripe::PaymentIntent.create(
        {
          amount: product&.amount,
          currency: 'eur',
          automatic_payment_methods: { enabled: true }
        }
      )
    rescue Stripe::InvalidRequestError => _e
      @error = Error::CODES[:UNPROCESSABLE_ENTITY]
    end

    def booking
      @booking = Booking.new(
        user: current_user,
        status: Booking::STATUSES[:ON_HOLD],
        product_id: product&.id,
        client_secret: payment_intent&.client_secret
      )
    end
  end
end
