class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile

  delegate :name, to: :profile, allow_nil: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i

  validates :email, format: {
    with: VALID_EMAIL_REGEX,
    message: "must be a valid email address",
  }
end
