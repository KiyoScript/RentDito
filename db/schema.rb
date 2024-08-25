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

ActiveRecord::Schema[7.1].define(version: 2024_08_25_060146) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caretakers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_caretakers_on_property_id"
    t.index ["user_id"], name: "index_caretakers_on_user_id"
  end

  create_table "maintainers", force: :cascade do |t|
    t.integer "city"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_maintainers_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer "city"
    t.integer "barangay"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "property_units", force: :cascade do |t|
    t.string "name"
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_property_units_on_property_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "number"
    t.integer "upper_deck"
    t.integer "lower_deck"
    t.bigint "property_unit_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_rooms_on_property_id"
    t.index ["property_unit_id"], name: "index_rooms_on_property_unit_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.datetime "check_in"
    t.integer "deck"
    t.integer "age"
    t.date "date_of_birth"
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.bigint "property_unit_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_tenants_on_property_id"
    t.index ["property_unit_id"], name: "index_tenants_on_property_unit_id"
    t.index ["room_id"], name: "index_tenants_on_room_id"
    t.index ["user_id"], name: "index_tenants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "phone_number"
    t.integer "gender"
    t.integer "role"
    t.integer "status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "caretakers", "properties"
  add_foreign_key "caretakers", "users"
  add_foreign_key "maintainers", "users"
  add_foreign_key "properties", "users"
  add_foreign_key "property_units", "properties"
  add_foreign_key "rooms", "properties"
  add_foreign_key "rooms", "property_units"
  add_foreign_key "tenants", "properties"
  add_foreign_key "tenants", "property_units"
  add_foreign_key "tenants", "rooms"
  add_foreign_key "tenants", "users"
end
