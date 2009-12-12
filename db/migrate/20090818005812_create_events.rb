class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string   :event_type
      t.integer  :tournament_id
      t.datetime :created_at
      t.text     :data
    end
  end

  def self.down
    drop_table :events
  end
end
