class MembershipsController < InheritedResources::Base
  before_filter :authenticate_user!
  
  actions :new, :create, :destroy
  belongs_to :team
end
