# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_24_151618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "after_arrangement_photos", force: :cascade do |t|
    t.string "url", null: false
    t.bigint "arrangement_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["arrangement_id"], name: "index_after_arrangement_photos_on_arrangement_id"
  end

  create_table "arrangements", force: :cascade do |t|
    t.string "title", null: false
    t.text "context", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "likes_count", default: 0
    t.bigint "comments_count", default: 0
    t.index ["user_id"], name: "index_arrangements_on_user_id"
  end

  create_table "authentications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "user_id"
    t.bigint "arrangement_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["arrangement_id"], name: "index_comments_on_arrangement_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "arrangement_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "arrangement_id"], name: "index_likes_on_user_id_and_arrangement_id", unique: true
  end

  create_table "parameters", force: :cascade do |t|
    t.integer "taste", default: 3, null: false
    t.integer "spiciness", default: 3, null: false
    t.integer "sweetness", default: 3, null: false
    t.integer "satisfaction", default: 3, null: false
    t.bigint "arrangement_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["arrangement_id"], name: "index_parameters_on_arrangement_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar_url", default: "/images/default_avatar.png"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.bigint "likes_count", default: 0
    t.bigint "arrangements_count", default: 0
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "after_arrangement_photos", "arrangements"
  add_foreign_key "arrangements", "users"
  add_foreign_key "comments", "arrangements"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "arrangements"
  add_foreign_key "likes", "users"
  add_foreign_key "parameters", "arrangements"
end
