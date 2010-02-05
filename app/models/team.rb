class Team < ActiveRecord::Base
  belongs_to :tournament
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships
  
  validates_presence_of :name
end
