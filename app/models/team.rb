class Team < ActiveRecord::Base
  belongs_to :tournament
  
  has_many :memberships
  has_many :members, :through => :memberships, :dependent => :destroy
  
  validates_presence_of :name
end
