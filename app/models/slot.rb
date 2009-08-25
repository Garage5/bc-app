class Slot < ActiveRecord::Base
  belongs_to :match
  belongs_to :tournament
  belongs_to :player, :class_name => "User", :foreign_key => "user_id"
  
  def advance!
    match = self.match
    unless match.round == self.tournament.rounds.last
      index = match.position.odd? ? 0 : 1
      next_slot = match.next.slots[index]
      next_slot.player = self.player
      next_slot.save
      self.tournament.events.create(
        :target_id     => self.match.id, :target_type => self.match.class.to_s,
        :event_type    => 'result', :action => 'posted',
        :message       => "#{self.player.login} vanquished #{self.opponent.player.login} in round #{self.match.round.number}",
        :actor         => 'someone')
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
      previous_slot  = parent_match.slots.find_by_user_id(self.user_id)
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
  
  def opponent
    opponent_position = self.position.odd? ? 1 : 0
    self.match.slots[opponent_position]
  end
  
  def previous
    parent_match.slots.find_by_user_id(self.user_id)
  end
  
  def parent_match
    pos = (self.match.position * 2) - (self.position == 1 ? 1 : 0)
    self.match.round.higher_item.matches.find_by_position(pos)
  end
end
