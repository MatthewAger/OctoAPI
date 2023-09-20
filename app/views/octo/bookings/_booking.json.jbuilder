# frozen_string_literal: true

json.extract! booking, :status, :id, :product_id
json.card_payment do
  json.gateway 'stripe'
  json.stripe do
    json.version 'latest'
    json.payment_intent do
      json.id payment_intent.id
      # json.publishable_key ''
      json.client_secret payment_intent.client_secret
      json.amount payment_intent.amount
      json.currency payment_intent.currency
    end
  end
end
