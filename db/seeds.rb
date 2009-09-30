[
  ['dev',    'Developer User'],
  ['bryan',  'Bryan Cinman'],
  ['matt',   'James Au'],
  ['james',  'Matt Johnson'],
  ['victor', 'Victor Au'],
  ['david',  'David Nguyen'],
  ['josh',   'Josh Kim'],
  ['jeff',   'Jeff Tang'],
  ['jon',    'Jon Tang']
].each do |u|
  User.create(
    :login => u[0],
    :name => u[1], 
    :email => "#{u[0]}@thebattlebegins.com", :password => 'pass', :password_confirmation => 'pass')
end


Instance.create(:name => "Starfeeder", :host_id => 1, :subdomain => "starfeeder")
Instance.create(:name => "CodeMonkey", :host_id => 1, :subdomain => "codemonkey")


t1 = Tournament.create(
  :instance_id => 1,
  :name => 'Awesomeness', 
  :game => 'Starcraft 2',
  :slot_count => 8,
  :rules => 'Do not talk about fight club.',
  :registration_start_date => 1.days.from_now,
  :registration_end_date => 30.days.from_now
)

t2 = Tournament.create(
  :instance_id => 1,
  :name => 'Plankton', 
  :game => 'Starcraft 2',
  :slot_count => 8,
  :rules => 'Do not talk about fight club.',
  :registration_start_date => 1.days.from_now,
  :registration_end_date => 30.days.from_now,
  :use_teams => true,
  :players_per_team => 2
)

User.all.each do |u|
  u.join_tournament(t1).accept!
end

User.all.each do |u|
  u.join_tournament(t2).accept!
end

t2_participants = t2.participants
4.times do |i|
  team = t2.teams.create :name => "Team #{i}", :captain => t2_participants.shift
  team.members << t2_participants.shift
end
TeamMember.all.each { |m| m.accept! }