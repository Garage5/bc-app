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
      t.decimal   :first_place,   :precision => 10, :scale => 2
      t.decimal   :second_place,  :precision => 10, :scale => 2
      t.decimal   :third_place,   :precision => 10, :scale => 2
      t.decimal   :fourth_place,  :precision => 10, :scale => 2
      t.decimal   :entry_fee,     :precision => 10, :scale => 2
      t.text      :other_prizes
      t.integer   :instance_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
