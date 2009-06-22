class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text    :body
      t.integer :author_id
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
