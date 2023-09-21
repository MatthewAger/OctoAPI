# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  subject { create(:user) }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, subject) }

  describe 'POST #create' do
    it 'should be able to create a session' do
      expect(auth_headers['Authorization']).to include('Bearer')

      post user_session_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(201)
      expect(response.parsed_body['email']).to eq(subject.email)
      expect(response.parsed_body['jti']).to eq(subject.jti)
    end
  end

  describe 'DELETE #destroy' do
    it 'should be able to destroy a session' do
      delete destroy_user_session_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(204)
      expect(response.parsed_body['jti']).not_to eq(subject.jti)
    end
  end
end
