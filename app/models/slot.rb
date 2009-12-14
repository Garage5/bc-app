class Slot < ActiveRecord::Base
  belongs_to :match
  belongs_to :tournament
  belongs_to :player, :polymorphic => true
  
  acts_as_list :scope => :match_id
  
  def advance!(byed = nil)
    match = self.match
    # if not last match
    
    match_event = self.tournament.events.new(
      :event_type    => 'result',
      :data => Hashie::Mash.new({
        :opponents => [self.player.login, self.opponent.player.login]
      }))
    
    unless match.round.position == self.tournament.calculate_round_count
      index = match.position.odd? ? 0 : 1
      next_match = match.next
      
      if next_match.nil?
        next_match = match.round.lower_item.matches.create!(:position => (match.find_child_match_position))
        2.times { next_match.slots.create!(:tournament => self.tournament) }
      end
      
      next_slot = next_match.slots[index]

      if byed
        next_slot.can_revert = false
      end
      
      next_slot.player = self.player
      next_slot.save!
      match_event.save! unless byed
    else
      self.tournament.first_place = self.player
      self.tournament.save!
      match_event.save! unless byed
      self.tournament.events.create!(
        :event_type    => 'places',
        :data => Hashie::Mash.new({
          :player => self.player.name
        })
      ) unless byed
    end
    match.status = 'resolved'
    match.winner = self.player
    match.save!
  end
  
  def won!
    self.result = 'won'
    self.advance! if opponent.result == 'lost'
    self.match.dispute! if opponent.result == 'won'
    save
  end
  
  def lost!
    self.result = 'lost'
    opponent.advance! if opponent.result == 'won'
    self.match.dispute! if opponent.result == 'lost'
    save
  end
  
  def disqualify!
    self.status = 'disqualified'
    self.opponent.advance!
    save
    self.tournament.events.create(
      :event_type    => 'disqualified',
      :data => Hashie::Mash.new({
        :opponent => self.player.login
      })
    )
  end
  
  def revert!
    if self.can_revert?
      previous_slot  = parent_match.slots.find_by_player_id(self.player_id)
      previous_match = parent_match

      self.player = nil
      previous_match.winner = nil
      previous_slot.can_revert = false
    
      previous_match.save
      previous_slot.save
      save
    else
      false
    end
  end

  def bye?
    status == 'bye'
  end
  
  def opponent
    opponent_position = self.position.odd? ? 1 : 0
    self.match.slots[opponent_position]
  end
  
  def previous
    parent_match.slots.find_by_player_id(self.player_id)
  end
  
  def parent_match
    pos = (self.match.position * 2) - (self.position == 1 ? 1 : 0)
    self.match.round.higher_item.matches.find_by_position(pos)
  end
end
