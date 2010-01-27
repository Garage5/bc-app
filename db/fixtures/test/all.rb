Dir[File.join(RAILS_ROOT, "db/fixtures/development", '*.rb')].sort.each {|fixture| load fixture }

tournament = Tournament.first
ids = tournament.participants.map(&:id).push(tournament.account.admin.id)
cohost = User.first(:conditions => ['id NOT IN (?)', ids])

Participation.create do |p|
  p.tournament_id = Tournament.first.id
  p.participant_id = cohost.id
  p.state = 'cohost'
end