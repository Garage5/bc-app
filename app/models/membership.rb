class Membership < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :team
  belongs_to :member, :class_name => "User"
  
  validates_uniqueness_of :member_id, :scoped => :tournament_id
  
  before_save do |resource|
    resource.tournament_id = resource.team.tournament_id
  end
end
