class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :null => false
      t.belongs_to :tournament, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
