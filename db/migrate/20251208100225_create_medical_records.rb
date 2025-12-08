class CreateMedicalRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_records do |t|
      t.references :household, null: false, foreign_key: true, index: true
      t.references :household_member, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.integer :record_type, null: false
      t.date :record_date
      t.text :notes
      t.jsonb :attachments, default: []

      t.timestamps
    end
  end
end
