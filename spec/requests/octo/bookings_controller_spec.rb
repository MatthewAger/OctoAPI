# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Octo::BookingsController, type: :request do
  let(:user) { create(:user) }
  let(:uuid) { SecureRandom.uuid }
  let(:params) { { booking: { product_id: Product.first.id } } }
  let(:headers) do
    Devise::JWT::TestHelpers.auth_headers(
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Octo-Capabilities' => 'octo/cardPayments'
      },
      user
    )
  end

  describe 'POST #create' do
    context 'when the request is valid' do
      it 'should be able to create a booking and return a payment intent client secret' do
        expect { post octo_bookings_path, params:, headers:, as: :json }.to change(Booking, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.parsed_body['status']).to eq('ON_HOLD')
        expect(response.parsed_body['product_id']).to eq(Product.first.id)
        expect(response.parsed_body['card_payment']['gateway']).to eq('stripe')
        expect(response.parsed_body['card_payment']['stripe']['version']).to eq('latest')
        expect(response.parsed_body['card_payment']['stripe']['payment_intent']['id']).to eq('test_pi_1')
        expect(response.parsed_body['card_payment']['stripe']['payment_intent']['client_secret']).to be_present
        expect(response.parsed_body['card_payment']['stripe']['payment_intent']['amount']).to eq(1000)
        expect(response.parsed_body['card_payment']['stripe']['payment_intent']['currency']).to eq('eur')
      end
    end

    context 'when the product is not found' do
      it 'should not be able to create a booking' do
        expect do
          post octo_bookings_path, params: { booking: { product_id: 'invalid' } }, headers:, as: :json
        end.to change(Booking, :count).by(0)
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.parsed_body['error']).to eq('INVALID_PRODUCT_ID')
        expect(response.parsed_body['error_message']).to eq('The Product ID was invalid or missing')
      end
    end

    context 'when the user is not authenticated' do
      it 'should not be able to create a booking' do
        expect do
          post octo_bookings_path, params:,
                                   headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }, as: :json
        end.to change(Booking, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.parsed_body['error']).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
