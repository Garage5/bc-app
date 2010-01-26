Tournament.seed(:slot_count) do |t|
  t.account = Account.first
  t.host = User.first
  t.name = 'Valor Tournament'
  t.game = 'Starcraft 2'
  t.slot_count = 8
  t.rules = 'Do not talk about fight club.'
  t.registration_start_date = 1.days.from_now
  t.registration_end_date = 30.days.from_now
end

User.all(:offset => 1, :limit => 4).each do |u|
  u.join_tournament(Tournament.first).accept!
end