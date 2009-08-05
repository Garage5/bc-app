class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :player_one_id
      t.integer :player_two_id
      t.integer :round_id
      t.integer :winner_id
      t.integer :tournament_id
      t.integer :position
      t.string  :player_one_result
      t.string  :player_two_result
      t.string  :status, :default => 'TBD'
      t.timestamps
    end
  end
  
  def self.down
    drop_table :matches
  end
end
