class CreateHouseholdInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :household_invitations do |t|
      t.references :household, null: false, foreign_key: true, index: true
      t.references :household_member, null: false, foreign_key: true, index: { unique: true }
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :household_invitations, :token, unique: true
    add_index :household_invitations, :email
  end
end
