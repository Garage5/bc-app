class CreateTeamMembers < ActiveRecord::Migration
  def self.up
    create_table :team_members do |t|
      t.belongs_to :team, :null => false
      t.belongs_to :member, :null => false
      t.belongs_to :tournament, :null => false
      t.string :state, :null => false, :default => 'pending'

      t.timestamps
    end
  end

  def self.down
    drop_table :team_members
  end
end
