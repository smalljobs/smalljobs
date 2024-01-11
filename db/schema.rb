# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220712074946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "access_tokens", force: :cascade do |t|
    t.string   "access_token",  limit: 255
    t.string   "token_type",    limit: 255
    t.string   "refresh_token", limit: 255
    t.integer  "userable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expire_at"
    t.string   "userable_type",             default: "Seeker"
    t.string   "device_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "allocations", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "seeker_id"
    t.integer  "state"
    t.text     "feedback_seeker"
    t.text     "feedback_provider"
    t.boolean  "contract_returned"
    t.datetime "last_change_of_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
    t.integer  "provider_id"
    t.uuid     "contract_id"
    t.index ["job_id"], name: "index_allocations_on_job_id", using: :btree
    t.index ["provider_id"], name: "index_allocations_on_provider_id", using: :btree
    t.index ["seeker_id"], name: "index_allocations_on_seeker_id", using: :btree
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "status"
    t.integer  "seeker_id"
    t.integer  "provider_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
    t.integer  "duration"
    t.float    "payment"
    t.index ["job_id"], name: "index_assignments_on_job_id", using: :btree
  end

# Could not dump table "brokers" because of following StandardError
#   Unknown type 'user_role' for column 'creator_type'

  create_table "brokers_update_prefs", force: :cascade do |t|
    t.integer "broker_id"
    t.integer "update_pref_id"
    t.index ["broker_id"], name: "index_brokers_update_prefs_on_broker_id", using: :btree
    t.index ["update_pref_id"], name: "index_brokers_update_prefs_on_update_pref_id", using: :btree
  end

  create_table "certificates", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["title"], name: "index_certificates_on_title", using: :btree
  end

  create_table "certificates_seekers", force: :cascade do |t|
    t.integer "seeker_id"
    t.integer "certificate_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "alpha2"
  end

  create_table "default_templates", force: :cascade do |t|
    t.text     "template_name"
    t.text     "template"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "employments", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "broker_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "provider_id",                                                                         null: false
    t.integer  "work_category_id",                                                                    null: false
    t.string   "title",                limit: 255,                                                    null: false
    t.string   "date_type",            limit: 255,                                                    null: false
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "salary",                           precision: 8, scale: 2
    t.string   "salary_type",          limit: 255,                         default: "hourly_per_age", null: false
    t.integer  "manpower",                                                 default: 1,                null: false
    t.integer  "duration",                                                 default: 1,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                limit: 255,                         default: "created"
    t.boolean  "rating_reminder_sent",                                     default: false
    t.text     "long_description"
    t.text     "short_description"
    t.datetime "last_change_of_state"
    t.text     "notes"
    t.integer  "organization_id"
    t.index ["organization_id"], name: "index_jobs_on_organization_id", using: :btree
    t.index ["title"], name: "index_jobs_on_title", using: :btree
  end

  create_table "jobs_certificates", force: :cascade do |t|
    t.integer  "seeker_id"
    t.text     "content"
    t.uuid     "jobs_certificate_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "message"
    t.integer  "broker_id"
    t.integer  "seeker_id"
    t.integer  "provider_id"
    t.integer  "job_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["broker_id"], name: "index_notes_on_broker_id", using: :btree
    t.index ["job_id"], name: "index_notes_on_job_id", using: :btree
    t.index ["provider_id"], name: "index_notes_on_provider_id", using: :btree
    t.index ["seeker_id"], name: "index_notes_on_seeker_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "logo",                          limit: 255
    t.string   "background",                    limit: 255
    t.string   "name",                          limit: 255,                                         null: false
    t.string   "website",                       limit: 255
    t.text     "description"
    t.string   "street",                        limit: 255,                                         null: false
    t.string   "email",                         limit: 255,                                         null: false
    t.string   "phone",                         limit: 255
    t.boolean  "active",                                                            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.decimal  "default_hourly_per_age",                    precision: 8, scale: 2, default: "1.0"
    t.float    "wage_factor"
    t.text     "opening_hours"
    t.text     "welcome_letter_employers_msg"
    t.text     "welcome_app_register_msg"
    t.text     "welcome_chat_register_msg"
    t.text     "not_receive_job_msg"
    t.text     "get_job_msg"
    t.text     "activation_msg"
    t.text     "welcome_email_for_parents_msg"
    t.date     "start_vacation_date"
    t.date     "end_vacation_date"
    t.boolean  "vacation_active",                                                   default: false
    t.string   "vacation_title"
    t.text     "vacation_text"
    t.float    "salary_deduction",                                                  default: 0.0
    t.boolean  "hide_salary",                                                       default: false
    t.boolean  "signature_on_contract",                                             default: true
    t.integer  "default_broker_id"
    t.text     "first_reminder_message"
    t.text     "second_reminder_message"
    t.index ["name"], name: "index_organizations_on_name", unique: true, using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.integer  "region_id"
    t.string   "zip",        limit: 255,                         null: false
    t.string   "name",       limit: 255,                         null: false
    t.string   "state",      limit: 255
    t.string   "province",   limit: 255
    t.decimal  "longitude",              precision: 9, scale: 6, null: false
    t.decimal  "latitude",               precision: 9, scale: 6, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name",  limit: 255
    t.integer  "country_id"
    t.index ["name"], name: "index_places_on_name", using: :btree
    t.index ["zip"], name: "index_places_on_zip", using: :btree
  end

  create_table "providers", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "firstname",              limit: 255,                   null: false
    t.string   "lastname",               limit: 255,                   null: false
    t.string   "street",                 limit: 255,                   null: false
    t.string   "phone",                  limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "contact_preference",     limit: 255, default: "email"
    t.text     "contact_availability"
    t.boolean  "active",                             default: true
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "encrypted_password",     limit: 255, default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.integer  "organization_id"
    t.boolean  "contract",                           default: true
    t.text     "notes"
    t.string   "company",                limit: 255
    t.integer  "state",                              default: 1
    t.index ["confirmation_token"], name: "index_providers_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_providers_on_email", using: :btree
    t.index ["organization_id"], name: "index_providers_on_organization_id", using: :btree
    t.index ["reset_password_token"], name: "index_providers_on_reset_password_token", unique: true, using: :btree
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username",   limit: 255
    t.integer  "item"
    t.string   "table",      limit: 255
    t.integer  "month",      limit: 2
    t.bigint   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",                    limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain",               limit: 255, null: false
    t.string   "logo"
    t.string   "header_image"
    t.text     "content"
    t.text     "contact_content"
    t.string   "ji_location_id"
    t.string   "ji_location_name"
    t.integer  "country_id"
    t.text     "job_contract_rules"
    t.string   "detail_link"
    t.text     "provider_contract_rules"
    t.index ["name"], name: "index_regions_on_name", unique: true, using: :btree
    t.index ["subdomain"], name: "index_regions_on_subdomain", using: :btree
  end

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        default: "file"
  end

# Could not dump table "seekers" because of following StandardError
#   Unknown type 'user_role' for column 'creator_type'

  create_table "seekers_work_categories", force: :cascade do |t|
    t.integer "seeker_id"
    t.integer "work_category_id"
  end

  create_table "todos", force: :cascade do |t|
    t.integer  "record_id"
    t.integer  "record_type"
    t.integer  "todotype_id"
    t.integer  "seeker_id"
    t.integer  "job_id"
    t.integer  "provider_id"
    t.integer  "allocation_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "postponed"
    t.boolean  "manual_completion", default: false
    t.datetime "completed"
    t.index ["allocation_id"], name: "index_todos_on_allocation_id", using: :btree
    t.index ["job_id"], name: "index_todos_on_job_id", using: :btree
    t.index ["provider_id"], name: "index_todos_on_provider_id", using: :btree
    t.index ["seeker_id"], name: "index_todos_on_seeker_id", using: :btree
    t.index ["todotype_id"], name: "index_todos_on_todotype_id", using: :btree
  end

  create_table "todotypes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "table"
    t.string   "where"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "manual_completion", default: false
  end

  create_table "update_prefs", force: :cascade do |t|
    t.string   "name"
    t.integer  "day_of_week"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "work_categories", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_name"
    t.index ["name"], name: "index_work_categories_on_name", using: :btree
  end

  add_foreign_key "todos", "allocations"
  add_foreign_key "todos", "jobs"
  add_foreign_key "todos", "providers"
  add_foreign_key "todos", "seekers"
  add_foreign_key "todos", "todotypes"
end
