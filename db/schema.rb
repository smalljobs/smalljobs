# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140317213439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["invitation_token"], name: "index_admins_on_invitation_token", unique: true, using: :btree
  add_index "admins", ["invited_by_id"], name: "index_admins_on_invited_by_id", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "allocations", force: true do |t|
    t.integer  "job_id"
    t.integer  "seeker_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: true do |t|
    t.integer  "job_id"
    t.integer  "seeker_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brokers", force: true do |t|
    t.string   "firstname",                             null: false
    t.string   "lastname",                              null: false
    t.string   "phone",                                 null: false
    t.string   "mobile"
    t.boolean  "active",                 default: true
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.text     "contact_availability"
  end

  add_index "brokers", ["confirmation_token"], name: "index_brokers_on_confirmation_token", unique: true, using: :btree
  add_index "brokers", ["email"], name: "index_brokers_on_email", unique: true, using: :btree
  add_index "brokers", ["invitation_token"], name: "index_brokers_on_invitation_token", unique: true, using: :btree
  add_index "brokers", ["invited_by_id"], name: "index_brokers_on_invited_by_id", using: :btree
  add_index "brokers", ["reset_password_token"], name: "index_brokers_on_reset_password_token", unique: true, using: :btree

  create_table "employments", force: true do |t|
    t.integer  "organization_id"
    t.integer  "broker_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.integer  "provider_id",                                                             null: false
    t.integer  "work_category_id",                                                        null: false
    t.string   "title",                                                                   null: false
    t.text     "description",                                                             null: false
    t.string   "date_type",                                                               null: false
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "salary",               precision: 8, scale: 2,                            null: false
    t.string   "salary_type",                                  default: "hourly_per_age", null: false
    t.integer  "manpower",                                     default: 1,                null: false
    t.integer  "duration",                                     default: 1,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                        default: "created"
    t.boolean  "rating_reminder_sent",                         default: false
  end

  add_index "jobs", ["title"], name: "index_jobs_on_title", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "logo"
    t.string   "background"
    t.string   "name",                                                          null: false
    t.string   "website"
    t.text     "description"
    t.string   "street",                                                        null: false
    t.string   "email",                                                         null: false
    t.string   "phone"
    t.boolean  "active",                                         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.decimal  "default_hourly_per_age", precision: 8, scale: 2, default: 1.0
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "places", force: true do |t|
    t.integer  "region_id"
    t.string   "zip",                                null: false
    t.string   "name",                               null: false
    t.string   "state"
    t.string   "province"
    t.decimal  "longitude",  precision: 9, scale: 6, null: false
    t.decimal  "latitude",   precision: 9, scale: 6, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["name"], name: "index_places_on_name", using: :btree
  add_index "places", ["zip"], name: "index_places_on_zip", using: :btree

  create_table "proposals", force: true do |t|
    t.integer  "job_id"
    t.integer  "seeker_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.string   "email"
    t.string   "firstname",                                null: false
    t.string   "lastname",                                 null: false
    t.string   "street",                                   null: false
    t.string   "phone"
    t.string   "mobile"
    t.string   "contact_preference",     default: "email"
    t.text     "contact_availability"
    t.boolean  "active",                 default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "username",               default: "",      null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "place_id"
  end

  add_index "providers", ["confirmation_token"], name: "index_providers_on_confirmation_token", unique: true, using: :btree
  add_index "providers", ["email"], name: "index_providers_on_email", unique: true, using: :btree
  add_index "providers", ["invitation_token"], name: "index_providers_on_invitation_token", unique: true, using: :btree
  add_index "providers", ["invited_by_id"], name: "index_providers_on_invited_by_id", using: :btree
  add_index "providers", ["reset_password_token"], name: "index_providers_on_reset_password_token", unique: true, using: :btree
  add_index "providers", ["username"], name: "index_providers_on_username", unique: true, using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "regions", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain",  null: false
  end

  add_index "regions", ["name"], name: "index_regions_on_name", unique: true, using: :btree
  add_index "regions", ["subdomain"], name: "index_regions_on_subdomain", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "job_id"
    t.integer  "seeker_id"
    t.integer  "rating"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "provider_id"
  end

  create_table "seekers", force: true do |t|
    t.string   "firstname",                                   null: false
    t.string   "lastname",                                    null: false
    t.string   "street"
    t.date     "date_of_birth"
    t.string   "phone"
    t.string   "mobile"
    t.string   "contact_preference",     default: "whatsapp"
    t.text     "contact_availability"
    t.boolean  "active",                 default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.string   "sex"
  end

  add_index "seekers", ["confirmation_token"], name: "index_seekers_on_confirmation_token", unique: true, using: :btree
  add_index "seekers", ["email"], name: "index_seekers_on_email", unique: true, using: :btree
  add_index "seekers", ["reset_password_token"], name: "index_seekers_on_reset_password_token", unique: true, using: :btree

  create_table "seekers_work_categories", force: true do |t|
    t.integer "seeker_id"
    t.integer "work_category_id"
  end

  create_table "work_categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_categories", ["name"], name: "index_work_categories_on_name", using: :btree

end
