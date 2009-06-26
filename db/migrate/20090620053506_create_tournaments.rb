class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string    :name
      t.string    :game
      t.text      :rules
      t.integer   :slot_count
      t.boolean   :teams
      t.integer   :players_per_team
      t.string    :prizes
      t.date      :registration_start_date
      t.date      :registration_end_date
      t.date      :tournament_start_date
      t.date      :tournament_end_date
      t.datetime  :tournament_start_time
      t.integer   :first_place_prize,  :default => 0
      t.integer   :second_place_prize, :default => 0
      t.integer   :third_place_prize,  :default => 0
      t.integer   :entry_fee,          :default => 0
      t.text      :other_prizes
      t.integer   :instance_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end