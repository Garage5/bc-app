class CreateMessageSubscribersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :messages_subscribers, :id => false do |t|
      t.belongs_to :message, :null => false
      t.belongs_to :subscriber, :null => false
    end
  end

  def self.down
    drop_table :messages_subscribers
  end
end
