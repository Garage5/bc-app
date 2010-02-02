class RemoveRegistrationDatesFromTournaments < ActiveRecord::Migration
  def self.up
    remove_column :tournaments, :registration_start_date
    remove_column :tournaments, :registration_end_date
  end

  def self.down
    add_column :tournaments, :registration_end_date, :date
    add_column :tournaments, :registration_start_date, :date
  end
end
