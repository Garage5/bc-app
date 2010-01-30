class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer  :participant_id
      t.integer  :tournament_id
      t.datetime :accepted_at
      t.string  :state, :default => 'pending'
      t.timestamps
    end
    
    add_index :participations, :tournament_id
  end
  
  def self.down
    remove_index :participations, :tournament_id
    drop_table :participations
  end
end
