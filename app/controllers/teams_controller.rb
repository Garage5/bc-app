class TeamsController < InheritedResources::Base
  before_filter :authenticate_user!

  actions :all, :except => [:index, :show]
  belongs_to :tournament

  def new
    @team = parent.teams.new
    unauthorized! if cannot? :create, @team
    new!
  end

  def create
    @team = parent.teams.new(params[:team].merge(:captain => current_user))
    unauthorized! if cannot? :create, @team
    create!
  end
  
  def edit
    unauthorized! if cannot? :edit, resource
  end
  
  def update
    unauthorized! if cannot? :edit, resource
    update!
  end
  
  def destroy
    unauthorized! if cannot? :destroy, resource
    destroy!
  end
end
