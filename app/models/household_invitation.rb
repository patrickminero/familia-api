class HouseholdInvitation < ApplicationRecord
  belongs_to :household
  belongs_to :household_member

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :household_member_id, uniqueness: true

  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }

  def expired?
    expires_at <= Time.current
  end

  def active?
    !expired?
  end

  def accept!(user)
    raise "Invitation has expired" if expired?
    raise "User already linked to a household member" if user.household_members.where(household: household).exists?

    ActiveRecord::Base.transaction do
      household_member.update!(user: user)
      destroy!
    end
  end

  private

  def generate_token
    self.token ||= SecureRandom.hex(32)
  end

  def set_expiration
    self.expires_at ||= 7.days.from_now
  end
end
