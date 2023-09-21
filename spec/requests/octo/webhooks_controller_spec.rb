# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Octo::WebhooksController, type: :request do
  let(:user) { create(:user) }
  let(:client_secret) { 'pi_123_secret_456' }

  subject { create(:booking, user:, client_secret:) }

  describe 'POST #create' do
    context 'when the payment intent is successful' do
      it 'updates the booking status' do
        event = StripeMock.mock_webhook_event('payment_intent.succeeded', { client_secret: subject.client_secret })
        post '/octo/webhooks', params: event, headers: { 'Stripe-Signature': stripe_signature(event.to_json) }, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.status).to eq(200)
        expect(subject.reload.status).to eq('CONFIRMED')
      end
    end

    context 'when the payment intent fails' do
      it 'does not update the booking status' do
        event = StripeMock.mock_webhook_event('payment_intent.payment_failed', { client_secret: subject.client_secret })
        post '/octo/webhooks', params: event, headers: { 'Stripe-Signature': stripe_signature(event.to_json) }, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.status).to eq(200)
        expect(subject.reload.status).to eq('ON_HOLD')
      end
    end

    context 'when the event contains an invalid stripe signature' do
      it 'returns a bad request' do
        event = StripeMock.mock_webhook_event('payment_intent.payment_failed', { client_secret: subject.client_secret })
        post '/octo/webhooks', params: event, headers: { 'Stripe-Signature': 'invalid' }, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(response.status).to eq(400)
      end
    end

    context 'when the event contains an invalid client secret' do
      it 'returns a not found' do
        event = StripeMock.mock_webhook_event('payment_intent.payment_failed', { client_secret: 'invalid' })
        post '/octo/webhooks', params: event, headers: { 'Stripe-Signature': stripe_signature(event.to_json) }, as: :json

        expect(response).to have_http_status(:not_found)
        expect(response.status).to eq(404)
      end
    end
  end
end
