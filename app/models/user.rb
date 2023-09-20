# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true, uniqueness: true
  # validates :jti, presence: true, uniqueness: true
end
