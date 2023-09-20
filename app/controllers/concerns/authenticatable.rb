# frozen_string_literal: true

module Authenticatable
  extend ActiveSupport::Concern

  included do |_base|
    before_action :authenticate_user!
  end
end
