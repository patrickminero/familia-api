class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :name, null: false
      t.string :phone
      t.string :timezone, default: "UTC"
      t.text :bio
      t.jsonb :notification_preferences, default: {}
      t.jsonb :app_preferences, default: {}

      t.timestamps
    end
  end
end
