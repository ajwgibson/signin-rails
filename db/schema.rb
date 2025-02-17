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

ActiveRecord::Schema.define(version: 20171018184956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sign_in_record_imports", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "success_count"
    t.integer "error_count"
    t.string "upload_file_file_name"
    t.string "upload_file_content_type"
    t.integer "upload_file_file_size"
    t.datetime "upload_file_updated_at"
    t.string "error_file_file_name"
    t.string "error_file_content_type"
    t.integer "error_file_file_size"
    t.datetime "error_file_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sign_in_records", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "room", null: false
    t.datetime "sign_in_time", null: false
    t.string "label", null: false
    t.boolean "newcomer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
