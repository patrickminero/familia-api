class HouseholdMember < ApplicationRecord
  belongs_to :household
  belongs_to :user, optional: true
  has_many :medical_records, dependent: :destroy
  has_one :invitation, class_name: "HouseholdInvitation", dependent: :destroy

  enum :role, { member: 1, admin: 2 }

  RELATIONSHIPS = %w[self spouse partner child parent sibling grandparent grandchild other].freeze

  validates :name, presence: true
  validates :relationship, presence: true, inclusion: { in: RELATIONSHIPS }
  validates :role, presence: true
  validates :household_id, presence: true
  validates :user_id, uniqueness: { scope: :household_id }, if: :user_id?

  scope :registered, -> { where.not(user_id: nil) }
  scope :unregistered, -> { where(user_id: nil) }
  scope :admins, -> { where(role: :admin) }
  scope :members_only, -> { where(role: :member) }

  def registered?
    user_id.present?
  end

  def unregistered?
    user_id.nil?
  end
end
