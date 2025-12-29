class Household < ApplicationRecord
  belongs_to :user
  has_many :household_members, dependent: :destroy
  has_many :medical_records, dependent: :destroy
  has_many :invitations, class_name: "HouseholdInvitation", dependent: :destroy

  validates :name, presence: true
  validates :user_id, presence: true

  after_create :create_admin_member

  private

  def create_admin_member
    household_members.create!(
      user: user,
      name: user.name || user.email.split("@").first,
      relationship: "self",
      role: :admin
    )
  end
end
