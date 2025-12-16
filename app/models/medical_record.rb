class MedicalRecord < ApplicationRecord
  belongs_to :household
  belongs_to :household_member

  enum :record_type, {
    lab_result: 1,
    prescription: 2,
    visit_note: 3,
    vaccination: 4,
    imaging: 5,
    other: 6,
  }

  encrypts :notes

  validates :title, presence: true
  validates :record_type, presence: true

  scope :recent, -> { order(record_date: :desc, created_at: :desc) }
  scope :by_type, ->(type) { where(record_type: type) }
  scope :for_member, ->(member_id) { where(household_member_id: member_id) }

  def attachments?
    attachments.present? && attachments.any?
  end
end
