class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.integer :tournament_id
      t.date    :start_date
      t.integer :number
      t.integer :position
      t.timestamps
    end
    
    add_index :rounds, :tournament_id
  end
  
  def self.down
    remove_index :rounds, :tournament_id
    drop_table :rounds
  end
end
