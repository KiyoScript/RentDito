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

ActiveRecord::Schema[7.1].define(version: 2024_09_27_025457) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "billings", force: :cascade do |t|
    t.string "number"
    t.integer "status", default: 0
    t.decimal "electricity_bill_partial_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "electricity_bill_total_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "water_bill_total_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "charges_total_amount", precision: 6, scale: 2, default: "0.0"
    t.date "electricity_bill_start_date"
    t.date "electricity_bill_end_date"
    t.date "water_bill_start_date"
    t.date "water_bill_end_date"
    t.date "wifi_and_rental_start_date", default: "2024-09-01"
    t.date "wifi_and_rental_end_date", default: "2024-09-30"
    t.datetime "due_date"
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "electricity_bill_partial_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "electricity_bill_partial_amount_currency", default: "PHP", null: false
    t.decimal "electricity_bill_total_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "electricity_bill_total_amount_currency", default: "PHP", null: false
    t.decimal "water_bill_total_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "water_bill_total_amount_currency", default: "PHP", null: false
    t.decimal "charges_total_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "charges_total_amount_currency", default: "PHP", null: false
    t.index ["property_id"], name: "index_billings_on_property_id"
    t.index ["user_id"], name: "index_billings_on_user_id"
  end

  create_table "charges", force: :cascade do |t|
    t.decimal "extra_charge_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "electricity_share_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "water_share_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "wifi_share_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "monthly_rental_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "total_amount", precision: 6, scale: 2, default: "0.0"
    t.integer "days_count"
    t.bigint "user_id", null: false
    t.bigint "billing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "extra_charge_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "extra_charge_amount_currency", default: "PHP", null: false
    t.decimal "electricity_share_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "electricity_share_amount_currency", default: "PHP", null: false
    t.decimal "water_share_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "water_share_amount_currency", default: "PHP", null: false
    t.decimal "wifi_share_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "wifi_share_amount_currency", default: "PHP", null: false
    t.decimal "monthly_rental_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "monthly_rental_amount_currency", default: "PHP", null: false
    t.decimal "total_amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "total_amount_currency", default: "PHP", null: false
    t.index ["billing_id"], name: "index_charges_on_billing_id"
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "maintenance_staffs", force: :cascade do |t|
    t.integer "city"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_maintenance_staffs_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "city"
    t.string "barangay"
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
    t.string "name"
    t.integer "upper_deck"
    t.integer "lower_deck"
    t.bigint "property_unit_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "accomodation"
    t.index ["property_id"], name: "index_rooms_on_property_id"
    t.index ["property_unit_id"], name: "index_rooms_on_property_unit_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.datetime "check_in"
    t.integer "deck"
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.bigint "property_unit_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["property_id"], name: "index_tenants_on_property_id"
    t.index ["property_unit_id"], name: "index_tenants_on_property_unit_id"
    t.index ["room_id"], name: "index_tenants_on_room_id"
    t.index ["user_id"], name: "index_tenants_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "category"
    t.integer "status"
    t.string "title"
    t.text "description"
    t.integer "label"
    t.datetime "datetime"
    t.bigint "tenant_id", null: false
    t.string "assigned_to_type"
    t.bigint "assigned_to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_type", "assigned_to_id"], name: "index_tickets_on_assigned_to"
    t.index ["tenant_id"], name: "index_tickets_on_tenant_id"
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
    t.string "first_contact_name"
    t.string "first_contact_number"
    t.string "first_relationship"
    t.string "second_contact_name"
    t.string "second_contact_number"
    t.string "second_relationship"
    t.string "third_contact_number"
    t.string "fourth_contact_number"
    t.integer "age"
    t.date "date_of_birth"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
  end

  create_table "utility_staff", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "property_unit_id", null: false
    t.bigint "room_id", null: false
    t.integer "deck"
    t.index ["property_id"], name: "index_utility_staff_on_property_id"
    t.index ["property_unit_id"], name: "index_utility_staff_on_property_unit_id"
    t.index ["room_id"], name: "index_utility_staff_on_room_id"
    t.index ["user_id"], name: "index_utility_staff_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "billings", "properties"
  add_foreign_key "billings", "users"
  add_foreign_key "charges", "billings"
  add_foreign_key "charges", "users"
  add_foreign_key "maintenance_staffs", "users"
  add_foreign_key "properties", "users"
  add_foreign_key "property_units", "properties"
  add_foreign_key "rooms", "properties"
  add_foreign_key "rooms", "property_units"
  add_foreign_key "tenants", "properties"
  add_foreign_key "tenants", "property_units"
  add_foreign_key "tenants", "rooms"
  add_foreign_key "tenants", "users"
  add_foreign_key "tickets", "tenants"
  add_foreign_key "utility_staff", "properties"
  add_foreign_key "utility_staff", "property_units"
  add_foreign_key "utility_staff", "rooms"
  add_foreign_key "utility_staff", "users"
end
