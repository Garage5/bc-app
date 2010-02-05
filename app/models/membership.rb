class Membership < ActiveRecord::Base
  belongs_to :team
  belongs_to :member, :class_name => "User"
  
  validates_uniqueness_of :member_id, :scoped => :tournament_id
end
