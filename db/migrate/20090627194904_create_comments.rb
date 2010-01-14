class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :body
      t.string :commentable_type
      t.integer :commentable_id
      t.integer :author_id
      t.integer :tournament_id
      
      t.timestamps
    end
    
    add_index :comments, [:commentable_id, :commentable_type]
  end
  
  def self.down
    remove_index :comments, [:commentable_id, :commentable_type]
    drop_table :comments
  end
end
