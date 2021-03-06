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

ActiveRecord::Schema.define(version: 20160318200808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "owner_id"
    t.string   "action_taken_by_id"
    t.string   "kind"
    t.datetime "created_at"
    t.json     "payload"
  end

  add_index "events", ["action_taken_by_id"], name: "index_events_on_action_taken_by_id", using: :btree
  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree
  add_index "events", ["kind"], name: "index_events_on_kind", using: :btree
  add_index "events", ["owner_id"], name: "index_events_on_owner_id", using: :btree

  create_table "registered_users", force: :cascade do |t|
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "registered_users", ["user_id"], name: "index_registered_users_on_user_id", unique: true, using: :btree

end
