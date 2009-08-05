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

ActiveRecord::Schema.define(:version => 20090715163759) do

  create_table "attachments", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.integer  "tournament_id"
    t.integer  "uploader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instances", :force => true do |t|
    t.string   "name"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "player_one_id"
    t.integer  "player_two_id"
    t.integer  "round_id"
    t.integer  "winner_id"
    t.integer  "tournament_id"
    t.integer  "position"
    t.string   "player_one_result"
    t.string   "player_two_result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "author_id"
    t.integer  "tournament_id"
    t.boolean  "is_announcement", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "tournament_id"
    t.string   "state",          :default => "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "tournament_id"
    t.date     "start_date"
    t.integer  "number"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.string   "game"
    t.text     "rules"
    t.integer  "slot_count"
    t.boolean  "teams",                   :default => false
    t.integer  "players_per_team"
    t.string   "prizes"
    t.date     "registration_start_date"
    t.date     "registration_end_date"
    t.integer  "first_place_prize",       :default => 0
    t.integer  "second_place_prize",      :default => 0
    t.integer  "third_place_prize",       :default => 0
    t.integer  "entry_fee",               :default => 0
    t.text     "other_prizes"
    t.boolean  "is_template"
    t.integer  "instance_id"
    t.boolean  "started",                 :default => false
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
