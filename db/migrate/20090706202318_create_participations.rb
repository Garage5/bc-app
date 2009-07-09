class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer :participant_id
      t.integer :tournament_id
      t.string  :state, :default => 'pending'
      t.timestamps
    end
  end
  
  def self.down
    drop_table :participations
  end
end