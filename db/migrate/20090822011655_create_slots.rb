class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :tournament_id
      t.integer :position
      t.string  :result
      t.string  :status
      t.boolean :can_revert, :default => true
    end
  end

  def self.down
    drop_table :slots
  end
end
