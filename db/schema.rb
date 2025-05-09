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

ActiveRecord::Schema[7.1].define(version: 2024_12_02_111451) do
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

  create_table "balances", force: :cascade do |t|
    t.decimal "amount", precision: 6, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "amount_currency", default: "PHP", null: false
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "billings", force: :cascade do |t|
    t.string "number"
    t.decimal "electricity_bill_partial_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "electricity_bill_total_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "water_bill_total_amount", precision: 6, scale: 2, default: "0.0"
    t.decimal "charges_total_amount", precision: 6, scale: 2, default: "0.0"
    t.date "electricity_bill_start_date"
    t.date "electricity_bill_end_date"
    t.date "water_bill_start_date"
    t.date "water_bill_end_date"
    t.date "wifi_and_rental_start_date"
    t.date "wifi_and_rental_end_date"
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
    t.string "billing_type"
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
    t.integer "status", default: 0
    t.decimal "paid_amount", precision: 6, scale: 2, default: "0.0"
    t.bigint "user_id", null: false
    t.bigint "billing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_to_pay", precision: 10, scale: 2, default: "0.0"
    t.decimal "extra_charge_electricity_penalty", precision: 6, scale: 2
    t.decimal "water_sharing_penalty", precision: 6, scale: 2
    t.decimal "wifi_and_monthly_rental_penalty", precision: 6, scale: 2
    t.decimal "total_amount_penalty", precision: 6, scale: 2
    t.boolean "has_penalty", default: false
    t.index ["billing_id"], name: "index_charges_on_billing_id"
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.integer "status", default: 0
    t.decimal "amount", precision: 6, scale: 2
    t.bigint "user_id", null: false
    t.string "reference_number"
    t.datetime "date_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "amount_currency", default: "PHP", null: false
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "maintenance_staffs", force: :cascade do |t|
    t.integer "city"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_maintenance_staffs_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "message"
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.bigint "user_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "suggestion"
    t.decimal "amount", precision: 6, scale: 2
    t.bigint "user_id", null: false
    t.bigint "charge_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "amount_currency", default: "PHP", null: false
    t.index ["charge_id"], name: "index_payments_on_charge_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
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

  create_table "solid_cable_messages", force: :cascade do |t|
    t.text "channel"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "tenants", force: :cascade do |t|
    t.datetime "check_in"
    t.integer "deck"
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.bigint "property_unit_id", null: false
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.datetime "transfer_date"
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
    t.integer "rating"
    t.text "review"
    t.index ["assigned_to_type", "assigned_to_id"], name: "index_tickets_on_assigned_to"
    t.index ["tenant_id"], name: "index_tickets_on_tenant_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type"
    t.decimal "amount", precision: 6, scale: 2
    t.bigint "user_id", null: false
    t.bigint "deposit_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_cents", precision: 10, scale: 2, default: "0.0", null: false
    t.string "amount_currency", default: "PHP", null: false
    t.bigint "payment_id"
    t.text "reason"
    t.string "transfer_from"
    t.string "transfer_to"
    t.index ["deposit_id"], name: "index_transactions_on_deposit_id"
    t.index ["payment_id"], name: "index_transactions_on_payment_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
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
  add_foreign_key "balances", "users"
  add_foreign_key "billings", "properties"
  add_foreign_key "billings", "users"
  add_foreign_key "charges", "billings"
  add_foreign_key "charges", "users"
  add_foreign_key "deposits", "users"
  add_foreign_key "maintenance_staffs", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "payments", "charges"
  add_foreign_key "payments", "users"
  add_foreign_key "properties", "users"
  add_foreign_key "property_units", "properties"
  add_foreign_key "rooms", "properties"
  add_foreign_key "rooms", "property_units"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "tenants", "properties"
  add_foreign_key "tenants", "property_units"
  add_foreign_key "tenants", "rooms", on_delete: :nullify
  add_foreign_key "tenants", "users"
  add_foreign_key "tickets", "tenants"
  add_foreign_key "transactions", "deposits"
  add_foreign_key "transactions", "payments"
  add_foreign_key "transactions", "users"
  add_foreign_key "utility_staff", "properties"
  add_foreign_key "utility_staff", "property_units"
  add_foreign_key "utility_staff", "rooms"
  add_foreign_key "utility_staff", "users"
end
