# frozen_string_literal: true

module Requests
  module StripeHelpers
    def stripe_signature(payload)
      secret = ENV.fetch('STRIPE_WEBHOOK_SECRET', Rails.application.credentials.stripe_webhook_secret)
      time = Time.zone.now
      signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
      Stripe::Webhook::Signature.generate_header(
        time,
        signature,
        scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
      )
    end
  end
end
