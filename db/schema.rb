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

ActiveRecord::Schema.define(:version => 20090822011655) do

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
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "target_id"
    t.string   "target_type"
    t.string   "event_type"
    t.string   "action"
    t.string   "actor"
    t.string   "message"
    t.integer  "tournament_id"
    t.datetime "created_at"
  end

  create_table "instances", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "round_id"
    t.integer  "winner_id"
    t.integer  "tournament_id"
    t.integer  "position"
    t.integer  "comments_count"
    t.string   "status",         :default => "TBD"
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
    t.boolean  "hosts_only",      :default => false, :null => false
  end

  create_table "messages_subscribers", :id => false, :force => true do |t|
    t.integer "message_id",    :null => false
    t.integer "subscriber_id", :null => false
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

  create_table "slots", :force => true do |t|
    t.integer "player_id"
    t.string  "player_type"
    t.integer "match_id"
    t.integer "tournament_id"
    t.integer "position"
    t.string  "result"
    t.string  "status"
    t.boolean "can_revert",    :default => true
  end

  create_table "team_members", :force => true do |t|
    t.integer  "team_id",                              :null => false
    t.integer  "member_id",                            :null => false
    t.integer  "tournament_id",                        :null => false
    t.string   "state",         :default => "pending", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name",          :null => false
    t.integer  "tournament_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.string   "game"
    t.text     "rules"
    t.integer  "slot_count"
    t.boolean  "use_teams",               :default => false
    t.integer  "players_per_team"
    t.string   "places"
    t.date     "registration_start_date"
    t.date     "registration_end_date"
    t.string   "first_prize",             :default => "0"
    t.string   "second_prize",            :default => "0"
    t.string   "third_prize",             :default => "0"
    t.integer  "entry_fee",               :default => 0
    t.text     "other_prizes"
    t.boolean  "is_template",             :default => false
    t.integer  "instance_id"
    t.boolean  "started",                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",               :null => false
    t.string   "name",                :null => false
    t.string   "email",               :null => false
    t.string   "crypted_password",    :null => false
    t.string   "password_salt",       :null => false
    t.string   "persistence_token",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_activity"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
