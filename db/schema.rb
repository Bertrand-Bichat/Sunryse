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

ActiveRecord::Schema.define(version: 2021_05_26_135336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "blockages", force: :cascade do |t|
    t.bigint "initiator_id"
    t.bigint "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initiator_id"], name: "index_blockages_on_initiator_id"
    t.index ["target_id"], name: "index_blockages_on_target_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.bigint "speaker1_id"
    t.bigint "speaker2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["speaker1_id"], name: "index_chatrooms_on_speaker1_id"
    t.index ["speaker2_id"], name: "index_chatrooms_on_speaker2_id"
  end

  create_table "contact_requests", force: :cascade do |t|
    t.boolean "readed", default: false, null: false
    t.boolean "accepted", default: false, null: false
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible_sender", default: true, null: false
    t.boolean "visible_receiver", default: true, null: false
    t.index ["receiver_id"], name: "index_contact_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_contact_requests_on_sender_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "profile_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player1_id"], name: "index_games_on_player1_id"
    t.index ["player2_id"], name: "index_games_on_player2_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "content"
    t.boolean "readed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.boolean "visible_sender", default: true, null: false
    t.boolean "visible_receiver", default: true, null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "state"
    t.integer "amount_cents", default: 0, null: false
    t.string "checkout_session_id"
    t.bigint "user_id"
    t.string "subscription_id"
    t.string "order_type"
    t.boolean "active", default: false, null: false
    t.string "duration"
    t.integer "camera_credits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoices_number", default: 0, null: false
    t.date "cancel_date"
    t.date "paid_date"
    t.boolean "unsubscribed", default: false, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "tag"
    t.string "title"
    t.string "quote"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_intents", force: :cascade do |t|
    t.string "payment_intent_id"
    t.integer "amount_cents", default: 0, null: false
    t.bigint "order_id"
    t.string "refund_id"
    t.string "refund_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payment_intents_on_order_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "content"
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_posts_on_chatroom_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "publications", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_publications_on_user_id"
  end

  create_table "seeks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "online", default: false, null: false
    t.string "pseudo", null: false
    t.string "address", null: false
    t.date "birthday", null: false
    t.string "gender", null: false
    t.string "hair", null: false
    t.string "eye", null: false
    t.text "description"
    t.text "hobbies"
    t.text "job"
    t.text "qualities"
    t.text "defaults"
    t.text "i_want"
    t.text "i_dont_want"
    t.text "beliefs"
    t.text "projects"
    t.boolean "smoke", null: false
    t.boolean "want_child", null: false
    t.boolean "lives_alone", null: false
    t.text "movies"
    t.text "books"
    t.string "shape", null: false
    t.string "gender_criteria", null: false
    t.string "goal", null: false
    t.integer "min_age", null: false
    t.integer "max_age", null: false
    t.integer "perimeter_criteria", null: false
    t.string "shape_criteria", default: [], array: true
    t.float "longitude"
    t.float "latitude"
    t.string "stripe_id"
    t.string "slug"
    t.string "city_geocoded"
    t.string "bg_color"
    t.string "avatar_border_color"
    t.text "introduction"
    t.integer "ninja_time", default: 30, null: false
    t.boolean "ninja_activated", default: false, null: false
    t.boolean "ninja_reset", default: false, null: false
    t.boolean "notification_profil_seen", default: true, null: false
    t.boolean "notification_favorite_added", default: true, null: false
    t.boolean "notification_contact_request_readed", default: true, null: false
    t.boolean "notification_contact_request_accepted", default: true, null: false
    t.boolean "notification_contact_request_received", default: true, null: false
    t.integer "camera_credits_balance", default: 0, null: false
    t.boolean "authorized", default: false, null: false
    t.boolean "notification_post_received", default: true, null: false
    t.boolean "credit_activated", default: false, null: false
    t.boolean "banned", default: false, null: false
    t.float "current_latitude"
    t.float "current_longitude"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["shape_criteria"], name: "index_users_on_shape_criteria", using: :gin
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blockages", "users", column: "initiator_id"
  add_foreign_key "blockages", "users", column: "target_id"
  add_foreign_key "chatrooms", "users", column: "speaker1_id"
  add_foreign_key "chatrooms", "users", column: "speaker2_id"
  add_foreign_key "contact_requests", "users", column: "receiver_id"
  add_foreign_key "contact_requests", "users", column: "sender_id"
  add_foreign_key "favorites", "users"
  add_foreign_key "games", "users", column: "player1_id"
  add_foreign_key "games", "users", column: "player2_id"
  add_foreign_key "notifications", "users", column: "receiver_id"
  add_foreign_key "notifications", "users", column: "sender_id"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_intents", "orders"
  add_foreign_key "posts", "chatrooms"
  add_foreign_key "posts", "users"
  add_foreign_key "publications", "users"
end
