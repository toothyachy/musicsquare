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

ActiveRecord::Schema[7.1].define(version: 2024_05_31_074954) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.bigint "listing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_availabilities_on_listing_id"
  end

  create_table "listings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "sound_clip"
    t.string "images", array: true
    t.string "instruments"
    t.string "liked_genres"
    t.string "liked_bands"
    t.string "looking_for"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "requestor_comment"
    t.string "approver_comment"
    t.string "status", default: "pending"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.bigint "user_id", null: false
    t.bigint "listing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_requests_on_listing_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
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

  add_foreign_key "availabilities", "listings"
  add_foreign_key "listings", "users"
  add_foreign_key "requests", "listings"
  add_foreign_key "requests", "users"
end
