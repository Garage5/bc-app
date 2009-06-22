class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :top_user_id
      t.integer :bottom_user_id
      t.integer :round_id
    end
  end

  def self.down
    drop_table :matches
  end
end
