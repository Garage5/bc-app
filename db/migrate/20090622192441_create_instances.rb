class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string  :name
      t.integer :manager_id
      t.timestamps
    end
    
    Instance.create(:name => "Starfeeder")
  end
  
  def self.down
    drop_table :instances
  end
end
