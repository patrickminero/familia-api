class Profile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name), allow_nil: true }
  validates :phone, format: { with: /\A[+]?[0-9\s()-]+\z/, allow_blank: true }
end
