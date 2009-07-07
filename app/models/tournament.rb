class Tournament < ActiveRecord::Base
  belongs_to  :instance
  
  has_one :host, :class_name => "User", :foreign_key => "host_id"
  
  has_many    :messages
  has_many    :attachments, :class_name => '::Attachment'
  
  
  has_many :participations, :dependent => :destroy
  has_many :participants , :through => :participations
  
  has_many :pending_participants, :through => :participations, 
           :conditions => ['state = ?', 'pending'], :source => :participant
           
  has_many :active_participants, :through => :participations, 
           :conditions => ['state = ?', 'active'], :source => :participant
  
  
  validates_presence_of :name, :game, :rules, :slot_count, :registration_start_date,
    :registration_end_date, :tournament_start_date, :tournament_end_date, :instance_id

  validates_numericality_of :first_place_prize, :second_place_prize, :third_place_prize, :entry_fee
end
