class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string  :name
      t.string  :subdomain
      t.integer :host_id
      t.timestamps
    end
    
    Instance.create(:name => "Starfeeder", :host_id => 1, :subdomain => "starfeeder")
    Instance.create(:name => "CodeMonkey", :host_id => 1, :subdomain => "codemonkey")
  end
  
  def self.down
    drop_table :instances
  end
end
