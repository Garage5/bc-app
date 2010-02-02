Tournament.seed(:slot_count) do |t|
  t.account = Account.first
  t.host = User.first
  t.name = 'Valor Tournament'
  t.game = 'Starcraft 2'
  t.slot_count = 8
  t.rules = 'Do not talk about fight club.'
end

User.all(:offset => 1, :limit => 4).each do |u|
  #u.join_tournament(Tournament.first).accept!
  Participation.seed(:tournament_id, :participant_id) do |p|
    p.tournament_id = Tournament.first.id
    p.participant_id = u.id
    p.accepted_at = Time.now
  end
end