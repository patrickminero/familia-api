class CreateHouseholdMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :household_members do |t|
      t.references :household, null: false, foreign_key: true, index: true
      t.references :user, null: true, foreign_key: true, index: true
      t.string :name, null: false
      t.string :relationship, null: false
      t.integer :role, null: false, default: 1
      t.date :date_of_birth

      t.timestamps
    end

    add_index :household_members, [:household_id, :user_id], unique: true, where: "user_id IS NOT NULL"
  end
end
