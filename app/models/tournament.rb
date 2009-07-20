class Tournament < ActiveRecord::Base
  belongs_to  :instance
  
  belongs_to :host, :class_name => "User", :foreign_key => "host_id"
  
  has_many    :messages
  has_many    :attachments, :class_name => '::Attachment'
  
  has_many :matches
  
  has_many :participations, :dependent => :destroy
  has_many :participants , :through => :participations
  
  has_many :pending_participants, :through => :participations, 
           :conditions => ['state = ?', 'pending'], :source => :participant
           
  has_many :active_participants, :through => :participations, 
           :conditions => ['state = ?', 'active'], :source => :participant
  
  
  validates_presence_of :name, :game, :rules, :slot_count, :registration_start_date,
    :registration_end_date, :instance_id

  validates_numericality_of :first_place_prize, :second_place_prize, :third_place_prize, :entry_fee

  def start
    if self.started?
      self.errors.add_to_base("Tournament has already been started")
    else
      participants = self.active_participants
      if participants.size > 2
        couples = participants / 2
        couples.each do |users|
          self.matches.create(:player_one_id => users[0].id, :player_two_id => users[1].id, :round => 1)
        end
        self.started = true
        save
      else
        self.errors.add_to_base("Alteast 2 players are required to start a tournament")
      end
    end
  end
end