class ChangeTeamsToUseTeamsInTournaments < ActiveRecord::Migration
  def self.up
    rename_column(:tournaments, :teams, :use_teams)
  end

  def self.down
    rename_column(:tournaments, :use_teams, :teams)
  end
end
