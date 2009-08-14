class AddHostsOnlyToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :hosts_only, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :messages, :hosts_only
  end
end
