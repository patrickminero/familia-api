# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_12_08_100234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "household_invitations", force: :cascade do |t|
    t.bigint "household_id", null: false
    t.bigint "household_member_id", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_household_invitations_on_email"
    t.index ["household_id"], name: "index_household_invitations_on_household_id"
    t.index ["household_member_id"], name: "index_household_invitations_on_household_member_id", unique: true
    t.index ["token"], name: "index_household_invitations_on_token", unique: true
  end

  create_table "household_members", force: :cascade do |t|
    t.bigint "household_id", null: false
    t.bigint "user_id"
    t.string "name", null: false
    t.string "relationship", null: false
    t.integer "role", default: 1, null: false
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["household_id", "user_id"], name: "index_household_members_on_household_id_and_user_id", unique: true, where: "(user_id IS NOT NULL)"
    t.index ["household_id"], name: "index_household_members_on_household_id"
    t.index ["user_id"], name: "index_household_members_on_user_id"
  end

  create_table "households", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_households_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "medical_records", force: :cascade do |t|
    t.bigint "household_id", null: false
    t.bigint "household_member_id", null: false
    t.string "title", null: false
    t.integer "record_type", null: false
    t.date "record_date"
    t.text "notes"
    t.jsonb "attachments", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["household_id"], name: "index_medical_records_on_household_id"
    t.index ["household_member_id"], name: "index_medical_records_on_household_member_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "timezone", default: "UTC"
    t.text "bio"
    t.jsonb "notification_preferences", default: {}
    t.jsonb "app_preferences", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "household_invitations", "household_members"
  add_foreign_key "household_invitations", "households"
  add_foreign_key "household_members", "households"
  add_foreign_key "household_members", "users"
  add_foreign_key "households", "users"
  add_foreign_key "medical_records", "household_members"
  add_foreign_key "medical_records", "households"
  add_foreign_key "profiles", "users"
end
