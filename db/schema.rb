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

ActiveRecord::Schema.define(version: 20170609174921) do

  create_table "admins", force: :cascade do |t|
    t.string "full_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "broadcast_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "broadcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broadcasts", force: :cascade do |t|
    t.integer "congregation_id"
    t.string "broadcast_id"
    t.string "day_label"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "congregations", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.boolean "has_phone_transmission"
    t.boolean "has_video_transmission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "default_ip"
    t.integer "default_day"
    t.integer "default_weekend_time"
    t.index ["email"], name: "index_congregations_on_email", unique: true
  end

  create_table "cron_entries", force: :cascade do |t|
    t.integer "cron_wrapper_id"
    t.string "action_label"
    t.string "day_label"
    t.string "hour_label"
    t.string "minute_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cron_wrappers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_key_maps", force: :cascade do |t|
    t.integer "phone_id"
    t.integer "digit"
    t.string "full_name", default: "", null: false
  end

  create_table "phone_transmissions", force: :cascade do |t|
    t.integer "congregation_id"
    t.string "internal_phone_number"
    t.string "sip_phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phones", force: :cascade do |t|
    t.integer "user_id"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "allow_join_to_any", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "congregation_id"
    t.boolean "auto_invite_to_video", default: false
  end

  create_table "video_transmissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "congregation_id"
    t.string "refresh_token"
    t.string "stream_id"
    t.string "stream_name"
  end

end
