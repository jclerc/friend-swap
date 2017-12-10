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

ActiveRecord::Schema.define(version: 20171210161415) do

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.boolean "is_active"
    t.integer "friend1_id"
    t.integer "friend2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend1_id"], name: "index_exchanges_on_friend1_id"
    t.index ["friend2_id"], name: "index_exchanges_on_friend2_id"
  end

  create_table "friends", force: :cascade do |t|
    t.string "first_name"
    t.date "birthday"
    t.boolean "is_male"
    t.string "description"
    t.integer "city_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_friends_on_city_id"
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "tag_relations", force: :cascade do |t|
    t.integer "exchange_id"
    t.integer "tag_id"
    t.integer "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exchange_id"], name: "index_tag_relations_on_exchange_id"
    t.index ["friend_id"], name: "index_tag_relations_on_friend_id"
    t.index ["tag_id"], name: "index_tag_relations_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "label_male"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label_female"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "phone"
    t.boolean "is_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
