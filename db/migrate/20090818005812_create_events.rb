class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string   :target_id
      t.string   :target_type     
      t.string   :event_type
      t.string   :action
      t.string   :actor
      t.string   :message
      t.integer  :tournament_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :events
  end
end
