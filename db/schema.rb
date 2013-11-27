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

ActiveRecord::Schema.define(version: 20131127223727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "job_broker_organizations", force: true do |t|
    t.integer  "job_broker_id"
    t.integer  "organization_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_brokers", force: true do |t|
    t.string   "firstname",                             null: false
    t.string   "lastname",                              null: false
    t.string   "phone",                                 null: false
    t.string   "mobile"
    t.boolean  "active",                 default: true
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
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
  end

  add_index "job_brokers", ["confirmation_token"], name: "index_job_brokers_on_confirmation_token", unique: true, using: :btree
  add_index "job_brokers", ["email"], name: "index_job_brokers_on_email", unique: true, using: :btree
  add_index "job_brokers", ["reset_password_token"], name: "index_job_brokers_on_reset_password_token", unique: true, using: :btree

  create_table "job_providers", force: true do |t|
    t.string   "email"
    t.string   "firstname",                                null: false
    t.string   "lastname",                                 null: false
    t.string   "street",                                   null: false
    t.string   "zip",                                      null: false
    t.string   "city",                                     null: false
    t.string   "phone"
    t.string   "mobile"
    t.string   "contact_preference",     default: "email"
    t.text     "contact_availability"
    t.boolean  "active",                 default: true
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "username",               default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
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
  end

  add_index "job_providers", ["confirmation_token"], name: "index_job_providers_on_confirmation_token", unique: true, using: :btree
  add_index "job_providers", ["email"], name: "index_job_providers_on_email", unique: true, using: :btree
  add_index "job_providers", ["reset_password_token"], name: "index_job_providers_on_reset_password_token", unique: true, using: :btree
  add_index "job_providers", ["username"], name: "index_job_providers_on_username", unique: true, using: :btree

  create_table "job_seekers", force: true do |t|
    t.string   "firstname",                                   null: false
    t.string   "lastname",                                    null: false
    t.string   "street",                                      null: false
    t.string   "zip",                                         null: false
    t.string   "city",                                        null: false
    t.date     "date_of_birth",                               null: false
    t.string   "phone"
    t.string   "mobile"
    t.string   "contact_preference",     default: "whatsapp"
    t.text     "contact_availability"
    t.boolean  "active",                 default: true
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
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
  end

  add_index "job_seekers", ["confirmation_token"], name: "index_job_seekers_on_confirmation_token", unique: true, using: :btree
  add_index "job_seekers", ["email"], name: "index_job_seekers_on_email", unique: true, using: :btree
  add_index "job_seekers", ["reset_password_token"], name: "index_job_seekers_on_reset_password_token", unique: true, using: :btree

  create_table "organizations", force: true do |t|
    t.string   "logo"
    t.string   "background"
    t.string   "name",                       null: false
    t.string   "website",                    null: false
    t.text     "description"
    t.string   "street",                     null: false
    t.string   "zip",                        null: false
    t.string   "city",                       null: false
    t.string   "email",                      null: false
    t.string   "phone",                      null: false
    t.boolean  "active",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "places", force: true do |t|
    t.integer  "zip",                                null: false
    t.string   "name",                               null: false
    t.string   "state"
    t.string   "province"
    t.decimal  "longitude",  precision: 9, scale: 6, null: false
    t.decimal  "latitude",   precision: 9, scale: 6, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
  end

  add_index "places", ["name"], name: "index_places_on_name", using: :btree
  add_index "places", ["region_id"], name: "index_places_on_region_id", using: :btree
  add_index "places", ["zip"], name: "index_places_on_zip", using: :btree

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
  end

  add_index "regions", ["name"], name: "index_regions_on_name", using: :btree

  create_table "work_categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_categories", ["name"], name: "index_work_categories_on_name", using: :btree

end
