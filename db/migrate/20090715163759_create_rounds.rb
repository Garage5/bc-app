class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.integer :tournament_id
      t.date    :start_date
      t.integer :number
      t.timestamps
    end
  end
  
  def self.down
    drop_table :rounds
  end
end
