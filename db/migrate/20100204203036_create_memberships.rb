class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.belongs_to :team
      t.belongs_to :member
      t.belongs_to :tournament
      t.boolean    :captain, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
