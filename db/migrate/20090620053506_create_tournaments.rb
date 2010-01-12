class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string    :name
      t.string    :game
      t.text      :rules
      t.integer   :slot_count
      t.boolean   :teams, :default => false
      t.integer   :players_per_team
      t.string    :places
      
      t.integer   :first_place_id
      t.string    :first_place_type
      
      t.date      :registration_start_date
      t.date      :registration_end_date
      
      t.string    :first_prize,  :default => 0
      t.string    :second_prize, :default => 0
      t.string    :third_prize,  :default => 0
      t.integer   :entry_fee,    :default => 0
      t.text      :other_prizes
      
      t.boolean   :is_template, :default => false
      t.integer   :account_id
      t.string    :state, :default => 'active'
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
