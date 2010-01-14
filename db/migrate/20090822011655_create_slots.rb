class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.integer :player_id
      t.string  :player_type
      t.integer :match_id
      t.integer :tournament_id
      t.integer :position
      t.string  :result
      t.string  :status
      t.boolean :can_revert, :default => true
    end
    
    add_index :slots, :match_id
  end

  def self.down
    remove_index :slots, :match_id
    drop_table :slots
  end
end
