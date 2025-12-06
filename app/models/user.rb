class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile

  delegate :name, to: :profile, allow_nil: true
end
