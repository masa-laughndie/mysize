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

ActiveRecord::Schema.define(version: 20180305120132) do

  create_table "comments", force: :cascade do |t|
    t.text "comment_content"
    t.integer "user_id"
    t.integer "kickspost_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kickspost_id"], name: "index_comments_on_kickspost_id"
    t.index ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at"
    t.index ["user_id", "kickspost_id", "created_at"], name: "index_comments_on_user_id_and_kickspost_id_and_created_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "goods", force: :cascade do |t|
    t.integer "user_id"
    t.integer "kind_id"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind_id", "kind"], name: "index_goods_on_kind_id_and_kind"
    t.index ["user_id", "created_at"], name: "index_goods_on_user_id_and_created_at"
    t.index ["user_id", "kind_id", "kind"], name: "index_goods_on_user_id_and_kind_id_and_kind", unique: true
    t.index ["user_id"], name: "index_goods_on_user_id"
  end

  create_table "kicksposts", force: :cascade do |t|
    t.text "content"
    t.string "picture"
    t.float "size"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_kicksposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_kicksposts_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.string "kind"
    t.integer "user_id"
    t.integer "kind_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unread_count", default: 1
    t.index ["user_id", "created_at"], name: "index_notices_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mysize_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "image"
    t.float "shoe_size"
    t.string "profile_content"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "uid"
    t.string "provider"
    t.string "reset_digest"
    t.string "e_token"
    t.datetime "reset_sent_at"
    t.integer "notice_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mysize_id"], name: "index_users_on_mysize_id", unique: true
  end

end
