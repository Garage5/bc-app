class CreateTeams < ActiveRecord::Migration
  def self.up
    add_column :participations, :name, :string
    add_column :participations, :captain_id, :integer
    add_column :participations, :type, :string
  end

  def self.down
    remove_column :participations, :type
    remove_column :participations, :captain_id
    remove_column :participations, :name
    drop_table :teams
  end
end
