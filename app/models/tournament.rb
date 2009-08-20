class Tournament < ActiveRecord::Base
  belongs_to  :instance
  
  belongs_to :host, :class_name => "User", :foreign_key => "host_id"
  
  has_many    :messages, :order => 'created_at DESC'
  has_many    :attachments, :class_name => '::Attachment'
  
  has_many :rounds
  accepts_nested_attributes_for :rounds
  has_many :matches
  has_many :events, :order => 'created_at DESC'
  has_many :comments
  
  has_many :teams, :dependent => :destroy
  
  has_many :participations, :dependent => :destroy
  has_many :participants , :through => :participations,
           :conditions => "state IN ('pending', 'active')"

  has_many :cohosts , :through => :participations,
           :conditions => ['state = ?', 'cohost'], :source => :participant
  
  has_many :pending_participants, :through => :participations, 
           :conditions => ['state = ?', 'pending'], :source => :participant
           
  has_many :active_participants, :through => :participations, 
           :conditions => ['state = ?', 'active'], :source => :participant
  
  
  validates_presence_of :name, :game, :rules, :slot_count, :instance_id
  
  validates_date :registration_start_date, :after => Date.today-1
  validates_date :registration_end_date, :after => :registration_start_date

  validates_numericality_of :entry_fee
  

  def start
    if self.started?
      self.errors.add_to_base("Tournament has already been started")
      return self
    end
    
    participants = self.active_participants
    
    if participants.size < 4
      self.errors.add_to_base("Alteast 4 players are required to start a tournament")
      return self
    end
    
    Tournament.transaction do      
      self.slot_count = calculate_slot_count(participants.size)
    
      calculate_round_count(self.slot_count).times do |r|
        round_number = r + 1
        round = self.rounds.create(:number => round_number)
        couples = (participants / 2).collect {|c| c.collect(&:id)} if round_number == 1
        calculate_number_of_matches_for_round(round_number).times do |m|
          match_players = {}
          if round_number == 1
            p1 = couples.try(:at, m).try(:at, 0)
            p2 = couples.try(:at, m).try(:at, 1)
            match_players = {:player_one_id => p1, :player_two_id => p2}
          end
          round.matches.create(match_players)
        end
      end  
  
      self.started = true
      save
    end # end transaction
  end
  
  private
  def calculate_slot_count(n)
    case n
    when 2..4
      4
    when 5..8
      8
    when 9..16
      16
    when 17..32
      32
    when 33..64
      64
    end
  end
  
  def calculate_round_count(n)
    r = { 4 => 2, 8 => 3, 16 => 4, 32 => 5, 64 => 6 }
    r[n]
  end
  
  def calculate_number_of_matches_for_round(round_number)
    (self.slot_count / (2 ** round_number))
  end
end
