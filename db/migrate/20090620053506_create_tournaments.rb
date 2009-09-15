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
      
      t.date      :registration_start_date
      t.date      :registration_end_date
      
      t.string    :first_prize,  :default => 0
      t.string    :second_prize, :default => 0
      t.string    :third_prize,  :default => 0
      t.integer   :entry_fee,          :default => 0
      t.text      :other_prizes
      
      t.boolean   :is_template, :default => false
      t.integer   :instance_id
      t.boolean   :started, :default => false
      t.timestamps
    end
    
    t = Tournament.create(
      :instance_id => 1,
      :name => 'Awesomeness', 
      :game => 'Starcraft 2',
      :slot_count => 8,
      :rules => 'Do not talk about fight club.',
      :registration_start_date => Time.now - 100,
      :registration_end_date => 30.days.from_now
      )
  end

  def self.down
    drop_table :tournaments
  end
end
