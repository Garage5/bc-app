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

ActiveRecord::Schema.define(:version => 20091111204149) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.integer  "admin_id"
    t.datetime "deleted_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain"

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
    t.string   "event_type"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.text     "data"
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
    t.string   "winner_type"
    t.integer  "tournament_id"
    t.integer  "position"
    t.integer  "comments_count", :default => 0
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
    t.integer  "comments_count",  :default => 0
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

  create_table "password_resets", :force => true do |t|
    t.string   "email"
    t.integer  "user_id",    :limit => 11
    t.string   "remote_ip"
    t.string   "token"
    t.datetime "created_at"
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

  create_table "subscription_affiliates", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",       :precision => 6, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "subscription_affiliates", ["token"], :name => "index_subscription_affiliates_on_token"

  create_table "subscription_discounts", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",                 :precision => 6, :scale => 2, :default => 0.0
    t.boolean  "percent"
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "apply_to_setup",                                       :default => true
    t.boolean  "apply_to_recurring",                                   :default => true
    t.integer  "trial_period_extension",                               :default => 0
  end

  create_table "subscription_payments", :force => true do |t|
    t.integer  "account_id",                :limit => 11
    t.integer  "subscription_id",           :limit => 11
    t.decimal  "amount",                                  :precision => 10, :scale => 2, :default => 0.0
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "setup"
    t.boolean  "misc"
    t.integer  "subscription_affiliate_id"
    t.decimal  "affiliate_amount",                        :precision => 6,  :scale => 2, :default => 0.0
  end

  add_index "subscription_payments", ["account_id"], :name => "index_subscription_payments_on_account_id"
  add_index "subscription_payments", ["subscription_id"], :name => "index_subscription_payments_on_subscription_id"

  create_table "subscription_plans", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",                         :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_limit", :limit => 11
    t.integer  "slot_limit",       :limit => 3
    t.integer  "renewal_period",   :limit => 11,                                :default => 1
    t.decimal  "setup_amount",                   :precision => 10, :scale => 2
    t.integer  "trial_period",     :limit => 11,                                :default => 1
  end

  create_table "subscriptions", :force => true do |t|
    t.decimal  "amount",                                  :precision => 10, :scale => 2
    t.datetime "next_renewal_at"
    t.string   "card_number"
    t.string   "card_expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                                                  :default => "trial"
    t.integer  "subscription_plan_id",      :limit => 11
    t.integer  "account_id",                :limit => 11
    t.integer  "tournament_limit",          :limit => 11
    t.integer  "slot_limit",                :limit => 3
    t.integer  "renewal_period",            :limit => 11,                                :default => 1
    t.string   "billing_id"
    t.integer  "subscription_discount_id",  :limit => 11
    t.integer  "subscription_affiliate_id"
  end

  add_index "subscriptions", ["account_id"], :name => "index_subscriptions_on_account_id"

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
    t.integer  "first_place_id"
    t.string   "first_place_type"
    t.date     "registration_start_date"
    t.date     "registration_end_date"
    t.string   "first_prize",             :default => "0"
    t.string   "second_prize",            :default => "0"
    t.string   "third_prize",             :default => "0"
    t.integer  "entry_fee",               :default => 0
    t.text     "other_prizes"
    t.boolean  "is_template",             :default => false
    t.integer  "account_id"
    t.string   "state",                   :default => "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                 :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_activity"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin",               :default => true
    t.integer  "account_id"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"

end
