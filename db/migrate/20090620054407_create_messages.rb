class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string  :subject
      t.text    :body
      t.integer :author_id
      t.integer :tournament_id
      t.boolean :is_announcement, :default => false
      t.integer :comments_count, :default => 0
      
      t.timestamps
    end
    
    add_index :messages, :tournament_id
  end

  def self.down
    remove_index :messages, :tournament_id
    drop_table :messages
  end
end
