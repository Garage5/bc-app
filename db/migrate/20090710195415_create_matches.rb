class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :player_one_id
      t.integer :player_two_id
      t.integer :round_id
      t.integer :winner_id
      t.integer :tournament_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :matches
  end
end
