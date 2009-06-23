class Tournament < ActiveRecord::Base
  belongs_to  :instance
  has_many    :messages
  
  validates_presence_of :name, :game, :rules, :slot_count, :registration_start_date,
    :registration_end_date, :tournament_start_date, :tournament_end_date, :instance_id
end
