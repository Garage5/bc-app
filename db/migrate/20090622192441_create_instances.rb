class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string  :name
      t.integer :host_id
      t.timestamps
    end
    
    Instance.create(:name => "Starfeeder", :host_id => 1)
  end
  
  def self.down
    drop_table :instances
  end
end
