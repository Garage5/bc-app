class Ability
  include CanCan::Ability
  
  def initialize(user)
    if user
      can :approve, Participation do |participation|
        is_host_or_cohost?(user, participation.tournament)
      end
      
      can :start, Tournament do |tournament|
        is_host_or_cohost?(user, tournament) && !tournament.started?
      end
      
      can :join, Tournament do |tournament|
        user.is_eligible_to_join?(tournament) && !tournament.started? && !is_host_or_cohost?(user, tournament)
      end
      
      can :destroy, Participation do |participation|
        is_host_or_cohost?(user, participation.tournament) || participation.participant == user
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

  def is_participant?(user, tournament)
    is_host_or_cohost?(user, tournament) || tournament.participants.include?(user)
  end

  def is_host_or_cohost?(user, tournament)
    tournament.account.admin == user || tournament.cohosts.include?(user)    
  end
end