# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :octo do
    resources :webhooks, only: %i[create]
    resources :bookings, only: %i[create]
  end

  devise_for :users, defaults: { format: :json }
end
