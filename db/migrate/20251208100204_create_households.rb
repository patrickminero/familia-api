class CreateHouseholds < ActiveRecord::Migration[7.1]
  def change
    create_table :households do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
