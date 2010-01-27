class Tournament < ActiveRecord::Base
  default_scope :order => 'updated_at DESC'
  named_scope :active, :conditions => {:state => 'active'}
  
  serialize   :places, Hash

  acts_as_textile :rules
  acts_as_textile :other_prizes

  belongs_to  :account
  belongs_to  :host, :class_name => "User", :foreign_key => "host_id"
  
  has_many    :messages, :order => 'created_at DESC', :dependent => :destroy
  has_many    :attachments, :class_name => '::Attachment', :dependent => :destroy
  
  has_many :rounds, :dependent => :destroy
  has_many :matches, :dependent => :destroy
  has_many :events, :order => 'created_at DESC', :dependent => :destroy
  has_many :public_events, :class_name => "Event", :conditions => ['event_type = ?', 'message']
  has_many :comments, :dependent => :destroy
  
  has_many :participations, :dependent => :destroy
  has_many :participants , :through => :participations

  belongs_to :first_place, :polymorphic => true

  has_many :cohosts , :through => :participations,
           :conditions => ['participations.state = ?', 'cohost'], :source => :participant
  has_many :pending_participants, :through => :participations, 
           :conditions => ['participations.state = ?', 'pending'], :source => :participant
  has_many :active_participants, :through => :participations, 
           :conditions => ['participations.state = ?', 'active'], :source => :participant
  
  accepts_nested_attributes_for :rounds
  
  validates_presence_of :name, :game, :rules, :slot_count, :account_id
  
  validates_date :registration_start_date, :after => Date.today-1, :on => :create
  validates_date :registration_end_date, :after => :registration_start_date, :on => :create

  validates_numericality_of :entry_fee
  
  validate_on_create :check_slot_limit
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def check_slot_limit
    errors.add_to_base('Invalid slot limit.') if !self.account.slot_multiples.include?(slot_count)
  end
  
  def officials
    [self.account.admin] + self.cohosts
  end
  
  def open_slots
    slot_count - self.active_participants.count
  end

  def start
    if self.started?
      self.errors.add_to_base("Tournament has already been started")
      return self
    end
    
    participants = self.use_teams? ? self.teams : self.active_participants
    
    if participants.size < 4
      self.errors.add_to_base("Alteast 4 slots are required to start a tournament")
      return self
    end
    
    Tournament.transaction do
      self.slot_count = calculate_slot_count(participants.size)
      byed = []
      num_byes = slot_count - participants.size
      # for each round expected
      calculate_round_count.times do |r|
        round_number = r + 1
        round = self.rounds.create!(:number => round_number)

        matches_per_round(round_number).times do
          match = round.matches.create!(:tournament => self)
          
          2.times do |index|
            slot = match.slots.new(:tournament => self)
            slot.can_revert = false if round_number == 1
            unless num_byes > 0 and index == 1
              slot.player = participants.shift
            else
              slot.status = 'bye'
              byed << match
              num_byes -= 1
            end
            slot.save!
          end # end ceate slots
        end # end ceate matches
      end #end create rounds
      
      byed.each do |byed_match|
        byed_match.slots[0].advance!(:bye)
      end
      
      # num_byes = slot_count - participants.size
      # first_round = self.rounds.first
      # 
      # (slot_count / 2).times do |m|
      #   match = first_round.matches.create(:tournament => self)
      #   p1 = match.slots.create(:player => participants.shift, :position => 1, :can_revert => false, :tournament => self)
      #   if num_byes > 0
      #     match.slots.create(:position => 2, :tournament => self, :status => 'bye', :can_revert => false)
      #     p1.advance!(:bye)
      #     num_byes -= 1
      #   else
      #     match.slots.create(:player => participants.shift, :position => 2, :can_revert => false, :tournament => self)
      #   end
      # end
      
      self.state = 'started'
      save
    end # end transaction
  end

  def started?
    state == 'started'
  end
  
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
  
  def calculate_round_count
    n = slot_count
    r = { 4 => 2, 8 => 3, 16 => 4, 32 => 5, 64 => 6 }
    r[n]
  end
  
  def matches_per_round(round_number)
    (self.slot_count / (2 ** round_number))
  end
end
