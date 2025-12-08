class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :profile, dependent: :destroy
  has_many :owned_households, class_name: "Household", dependent: :destroy
  has_many :household_members, dependent: :nullify
  has_many :households, through: :household_members

  accepts_nested_attributes_for :profile

  delegate :name, to: :profile, allow_nil: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i

  validates :email, format: {
    with: VALID_EMAIL_REGEX,
    message: "must be a valid email address",
  }
end
