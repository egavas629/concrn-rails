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

ActiveRecord::Schema.define(version: 20140725054218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.string   "call_phone"
    t.string   "text_phone"
  end

  create_table "dispatches", force: true do |t|
    t.integer  "report_id"
    t.integer  "responder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rejection_reason"
    t.string   "status",           default: "pending"
    t.datetime "accepted_at"
  end

  add_index "dispatches", ["report_id"], name: "index_dispatches_on_report_id", using: :btree
  add_index "dispatches", ["responder_id"], name: "index_dispatches_on_responder_id", using: :btree

  create_table "logs", force: true do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
  end

  add_index "logs", ["author_id"], name: "index_logs_on_author_id", using: :btree
  add_index "logs", ["report_id"], name: "index_logs_on_report_id", using: :btree

  create_table "reports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "phone"
    t.decimal  "long",               precision: 10, scale: 6
    t.decimal  "lat",                precision: 10, scale: 6
    t.string   "status",                                      default: "pending"
    t.text     "nature"
    t.string   "age"
    t.string   "gender"
    t.string   "race"
    t.string   "address"
    t.string   "setting"
    t.text     "observations"
    t.text     "feedback"
    t.string   "neighborhood"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "completed_at"
    t.integer  "agency_id"
    t.string   "urgency"
  end

  add_index "reports", ["agency_id"], name: "index_reports_on_agency_id", using: :btree

  create_table "shifts", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "start_via"
    t.string   "end_via"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shifts", ["user_id"], name: "index_shifts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",          null: false
    t.string   "encrypted_password",     default: "",          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "phone"
    t.string   "role",                   default: "responder"
    t.integer  "agency_id"
    t.boolean  "active",                 default: true
  end

  add_index "users", ["agency_id"], name: "index_users_on_agency_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
