# frozen_string_literal: true

module Octo
  class WebhooksController < ApplicationController
    before_action :fetch_booking, only: %i[create]

    attr_reader :booking

    def create
      case event.type
      when 'payment_intent.processing'
        # What would normally happen here?
        #  Could send an email to the user to let them know that the payment is being processed.
      when 'payment_intent.succeeded'
        booking.confirm!
      when 'payment_intent.payment_failed'
        # What would normally happen here?
        #  Could send an email to the user to let them know that the payment failed.
      else
        # What would normally happen here?
        #  It may be that a full application would support more event types.
        #  Perhaps we would want to raise an exception here to ensure that we don't miss any events.
        #  raise "Unhandled event type: #{event.type}"
      end

      head :ok
    end

    private

    def event
      @event ||=
        begin
          payload   = request.body.read
          signature = request.env['HTTP_STRIPE_SIGNATURE']
          key       = ENV.fetch('STRIPE_WEBHOOK_SECRET', Rails.application.credentials.stripe_webhook_secret)
          Stripe::Webhook.construct_event(payload, signature, key)
        end
    end

    def fetch_booking
      @booking ||= Booking.find_by(client_secret: event.data.object.client_secret)
      raise ActiveRecord::RecordNotFound if @booking.blank?
    rescue JSON::ParserError, Stripe::SignatureVerificationError => _e
      head :bad_request
    rescue ActiveRecord::RecordNotFound => _e
      head :not_found
    end
  end
end
