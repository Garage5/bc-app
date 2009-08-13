class ChangeTournamentPrizesToString < ActiveRecord::Migration
  def self.up
    change_column :tournaments, :first_place_prize, :string, :null => false, :default => ''
    change_column :tournaments, :second_place_prize, :string, :null => false, :default => ''
    change_column :tournaments, :third_place_prize, :string, :null => false, :default => ''
  end

  def self.down
    change_column :tournaments, :first_place_prize, :integer, :null => false, :default => 0
    change_column :tournaments, :second_place_prize, :integer, :null => false, :default => 0
    change_column :tournaments, :third_place_prize, :integer, :null => false, :default => 0
  end
end
