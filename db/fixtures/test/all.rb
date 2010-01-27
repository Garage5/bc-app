Dir[File.join(RAILS_ROOT, "db/fixtures/development", '*.rb')].sort.each {|fixture| load fixture }

tournament = Tournament.first
ids = tournament.participants.map(&:id).push(tournament.account.admin.id)
cohosts = User.all(:conditions => ['id NOT IN (?)', ids], :limit => 2)

cohosts.each do |cohost|
  Participation.seed(:tournament_id, :participant_id) do |p|
    p.tournament_id = tournament.id
    p.participant_id = cohost.id
    p.state = 'cohost'
  end 
end