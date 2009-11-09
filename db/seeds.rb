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

# SaaS
if SubscriptionPlan.count == 0
  plans = [
    { 'name' => 'Free', 'amount' => 0, 'user_limit' => 2 },
    { 'name' => 'Basic', 'amount' => 10, 'user_limit' => 5 },
    { 'name' => 'Premium', 'amount' => 30, 'user_limit' => nil }
  ].collect do |plan|
    SubscriptionPlan.create(plan)
  end
end

user = User.create(:name => 'Test', :login => 'test', :password => 'test', :password_confirmation => 'test', :email => 'test@example.com')
a = Account.create(:name => 'Test Account', :domain => 'localhost', :plan => plans.first, :admin => user)
p a.admin.email
a.update_attribute(:full_domain, 'localhost')

puts 'Changing secret in environment.rb...'
new_secret = ActiveSupport::SecureRandom.hex(64)
config_file_name = File.join(RAILS_ROOT, 'config', 'environment.rb')
config_file_data = File.read(config_file_name)
File.open(config_file_name, 'w') do |file|
  file.write(config_file_data.sub('9cb7f8ec7e560956b38e35e5e3005adf68acaf1f64600950e2f7dc9e6485d6d9c65566d193204316936b924d7cc72f54cad84b10a70a0257c3fd16e732152565', new_secret))
end
# end Saas


host = User.find_by_login('dev')

Account.create(:name => "Starfeeder", :admin => host, :domain => "starfeeder", :plan => plans.first)
Account.create(:name => "CodeMonkey", :admin => host, :domain => "codemonkey", :plan => plans.first)


3.times do |i|
  t = Tournament.create(
    :host => host,
    :account_id => 1,
    :name => "Valor Tournament #{i+1}", 
    :game => 'Starcraft 2',
    :slot_count => 8,
    :rules => 'Do not talk about fight club.',
    :registration_start_date => 1.days.from_now,
    :registration_end_date => 30.days.from_now
  )
  
  User.all.each do |u|
    u.join_tournament(t).accept!
  end
end


t2 = Tournament.create(
  :host => host,
  :account_id => 1,
  :name => 'Starcraft 2 Invitational', 
  :game => 'Starcraft 2',
  :slot_count => 8,
  :rules => 'Do not talk about fight club.',
  :registration_start_date => 1.days.from_now,
  :registration_end_date => 30.days.from_now,
  :use_teams => true,
  :players_per_team => 2
)

User.all.each do |u|
  u.join_tournament(t2).accept!
end

t2_participants = t2.participants
4.times do |i|
  team = t2.teams.create :name => "Team #{i}", :captain => t2_participants.shift
  team.members << t2_participants.shift
end
TeamMember.all.each { |m| m.accept! }