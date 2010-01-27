class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user
      can :accept, Participation do |participation|
        is_host_or_cohost?(user, participation.tournament)
      end
      
      can :start, Tournament do |tournament|
        is_host_or_cohost?(user, tournament) && !tournament.started?
      end
      
      can :join, Tournament do |tournament|
        user.is_eligible_to_join?(tournament) && !tournament.started? && !is_host_or_cohost?(user, tournament)
      end
      
      can :destroy, Participation do |participation|
        participation.participant_id == user.id && !participation.tournament.started?
        # if cohost?(user, participation.tournament)
        #   participation.state != 'cohost' || participation.participant == user
        # else
        #   host?(user, participation.tournament) || participation.participant == user && !participation.tournament.started?
        # end
      end
      
      can :add_cohost, Tournament do |tournament|
        tournament.account.admin == user
      end
      
      can :create, Message do |message|
        if message.is_announcement? || message.hosts_only?
          is_host_or_cohost?(user, message.tournament)
        else
          is_participant?(user, message.tournament)
        end
      end
      
      can :view, Message do |message|
        message.hosts_only? ? is_host_or_cohost?(user, message.tournament) : true
      end
    end
  end

  def participant?(user, tournament)
    is_host_or_cohost?(user, tournament) || tournament.participants.include?(user)
  end
  
  def host?(user, tournament)
    tournament.account.admin == user
  end
  
  def cohost?(user, tournament)
    tournament.cohosts.include?(user)
  end
  
  def is_host_or_cohost?(user, tournament)
    host?(user, tournament) || cohost?(user, tournament)
  end
end