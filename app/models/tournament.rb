class Tournament < ActiveRecord::Base
  belongs_to  :instance
  has_many    :messages
  has_many    :attachments, :class_name => '::Attachment'
  
  validates_presence_of :name, :game, :rules, :slot_count, :registration_start_date,
    :registration_end_date, :tournament_start_date, :tournament_end_date, :instance_id

  validates_numericality_of :first_place_prize, :second_place_prize, :third_place_prize, :entry_fee
end
