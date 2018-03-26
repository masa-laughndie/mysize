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

ActiveRecord::Schema.define(version: 20180314034222) do

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "kickspost_id"
    t.integer "reply_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kickspost_id"], name: "index_comments_on_kickspost_id"
    t.index ["reply_id"], name: "index_comments_on_reply_id"
    t.index ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at"
    t.index ["user_id", "kickspost_id", "created_at"], name: "index_comments_on_user_id_and_kickspost_id_and_created_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods", force: :cascade do |t|
    t.integer "gooder_id"
    t.integer "gooded_id"
    t.string "post_type"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gooded_id"], name: "index_goods_on_gooded_id"
    t.index ["gooder_id", "post_id", "post_type"], name: "index_goods_on_gooder_id_and_post_id_and_post_type", unique: true
    t.index ["gooder_id"], name: "index_goods_on_gooder_id"
    t.index ["post_type", "post_id"], name: "index_goods_on_post_type_and_post_id"
  end

  create_table "kicksposts", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.string "picture"
    t.float "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_kicksposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_kicksposts_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.integer "user_id"
    t.string "kind_type"
    t.integer "kind_id"
    t.integer "unread_count", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind_type", "kind_id"], name: "index_notices_on_kind_type_and_kind_id"
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
    t.string "password_digest"
    t.string "image"
    t.float "size"
    t.string "content"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "uid"
    t.string "provider"
    t.string "reset_digest"
    t.string "e_token"
    t.datetime "reset_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mysize_id"], name: "index_users_on_mysize_id", unique: true
  end

end
