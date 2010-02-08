class Team < ActiveRecord::Base
  belongs_to :tournament
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships
  belongs_to :captain, :class_name => "User"
  
  validates_presence_of :name
  
  def after_initialize
    if new_record?
      self.memberships.build(:member => self.captain)
    end
  end
end
