# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090622192441) do

  create_table "comments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instances", :force => true do |t|
    t.string   "name"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer "top_user_id"
    t.integer "bottom_user_id"
    t.integer "round_id"
  end

  create_table "messages", :force => true do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "title"
    t.string   "game"
    t.text     "rules"
    t.integer  "slot_count"
    t.integer  "players_per_team"
    t.string   "prizes"
    t.date     "registration_start_date"
    t.date     "registration_end_date"
    t.date     "tournament_start_date"
    t.date     "tournament_end_date"
    t.datetime "tournament_start_time"
    t.integer  "instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",             :null => false
    t.string   "email",             :null => false
    t.string   "crypted_password",  :null => false
    t.string   "password_salt",     :null => false
    t.string   "persistence_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
