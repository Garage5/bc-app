class Ability
  include CanCan::Ability
  
  def initialize(user)
    can :view, Message do |message|
      if message.hosts_only?
        is_host_or_cohost?(user, message.tournament) if user
      else
        true
      end
    end
    
    if user
      can :accept, Participation do |participation|
        tournament = participation.tournament
        is_host_or_cohost?(user, tournament) && !tournament.started?
      end
      
      can :destroy, Tournament do |tournament|
        host?(user, tournament)
      end
      
      can :start, Tournament do |tournament|
        is_host_or_cohost?(user, tournament) && !tournament.started?
      end
      
      can :join, Tournament do |tournament|
        !participant?(user, tournament) && !tournament.started? && !is_host_or_cohost?(user, tournament)
      end
      
      can :destroy, Participation do |participation|
        tournament = participation.tournament
        
        unless participation.state == 'cohost'
          (is_host_or_cohost?(user, tournament) || me?(user.id, participation.participant_id)) && !tournament.started?
        else
          host?(user, tournament) || me?(user.id, participation.participant_id)
        end
        
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
          participant?(user, message.tournament)
        end
      end
    
      can [:destroy, :edit], Message do |message|
        is_host_or_cohost?(user, message.tournament)
      end
      
      
      can :advance, Slot do |slot|
        is_host_or_cohost?(user, slot.tournament) && !slot.opponent.player_id.nil?
      end
      
      can :disqualify, Slot do |slot|
        is_host_or_cohost?(user, slot.tournament) && !slot.opponent.player_id.nil?
      end
      
      can :revert, Slot do |slot|
        is_host_or_cohost?(user, slot.tournament) && slot.can_revert?
      end
    end
  end

  def me?(current_id, user_id)
    current_id == user_id
  end

  def participant?(user, tournament)
    is_host_or_cohost?(user, tournament) || tournament.participations.accepted.exists?(:participant_id => user.id)
  end
  
  def host?(user, tournament)
    tournament.account.admin == user
  end
  
  def cohost?(user, tournament)
    tournament.cohosts.exists?(user.id)
  end
  
  def is_host_or_cohost?(user, tournament)
    host?(user, tournament) || cohost?(user, tournament)
  end
end