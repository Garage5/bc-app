class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :round_id
      t.integer :winner_id
      t.string  :winner_type
      t.integer :tournament_id
      t.integer :position
      t.integer :comments_count, :default => 0
      t.string  :status, :default => 'TBD'
      t.timestamps
    end
    
    add_index :matches, :tournament_id
    add_index :matches, :round_id
  end
  
  def self.down
    remove_index :matches, :round_id
    remove_index :matches, :tournament_id
    drop_table :matches
  end
end
