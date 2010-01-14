class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string   :event_type
      t.integer  :tournament_id
      t.datetime :created_at
      t.text     :data
    end
    
    add_index :events, :tournament_id
  end

  def self.down
    remove_index :events, :tournament_id
    drop_table :events
  end
end
