class Slot < ActiveRecord::Base
  belongs_to :match
  belongs_to :tournament
  belongs_to :player, :polymorphic => true
  
  acts_as_list :scope => :match_id
  
  def advance!(byed = nil)
    match = self.match
    unless match.round.position == self.tournament.calculate_round_count
      index = match.position.odd? ? 0 : 1
      next_match = match.next
      
      if next_match.nil?
        next_match = match.round.lower_item.matches.create(:position => (match.find_child_match_position))
        2.times { next_match.slots.create(:tournament => self.tournament) }
      end
      
      next_slot = next_match.slots[index]

      if byed
        next_slot.can_revert = false
      end
      
      next_slot.player = self.player
      next_slot.save
      self.tournament.events.create(
        :target_id     => self.match.id, :target_type => self.match.class.to_s,
        :event_type    => 'result', :action => 'posted',
        :message       => "#{self.player.login} vanquished #{self.opponent.player.login} in round #{self.match.round.number}",
        :actor         => 'someone') unless byed
    else
      serialized = OpenStruct.new({:id => self.player.id, :name => self.player.login})
      self.tournament.places.nil? ? self.tournament.places = {0 => serialized} : self.tournament.places[0] = serialized
      self.tournament.save
    end
    match.winner = self.player
    match.save
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
      :target_id     => self.match.id, :target_type => self.match.class.to_s,
      :event_type    => 'disqualified',:action => 'posted',
      :message       => "#{self.player.login} has been disqualified",
      :actor         => 'someone')
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
