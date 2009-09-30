class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string  :name
      t.string  :subdomain
      t.integer :host_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :instances
  end
end
