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

ActiveRecord::Schema.define(version: 20150421010641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "events", force: true do |t|
    t.string   "title"
    t.boolean  "active"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "friendships", force: true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "accepted",   default: false
  end

  create_table "invitations", force: true do |t|
    t.string  "user_id"
    t.integer "event_id"
    t.string  "sender_id"
    t.integer "reply",     default: 0
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "auth_id"
    t.text     "auth_token"
    t.string   "device_id"
    t.string   "phone_number"
    t.boolean  "visible"
    t.datetime "updated_at"
    t.spatial  "loc",          limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end

end
