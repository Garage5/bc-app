class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :participation
end
