class Team < Participation
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships
  belongs_to :captain, :class_name => "User", :foreign_key => 'participant_id'
  belongs_to :tournament
  
  validates_presence_of :name
  
  validate_on_create :valid_members?
  
  attr_accessor :battleids
  
  def after_initialize
    if new_record?
      self.memberships.build(:member => self.captain)
    end
  end
  
  def battleids
    @battleids || []
  end
  
  def valid_members?
    if battleids.uniq != battleids
      errors.add_to_base("BattleIDs must be unique")
    else
      battleids.each do |u|
        if user = User.find_by_username(u)
          if Membership.exists?(:tournament_id => self.tournament_id, :member_id => user.id)
            errors.add_to_base("#{user.username} is already participating in this tournament")
          else
            self.memberships.build(:member => user)
          end
        else
          errors.add_to_base("BattleID #{u} doesn't exists")
        end
      end
    end
  end
  
end
