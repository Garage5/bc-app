# [
#   ['dev',    'Developer User'],
#   ['bryan',  'Bryan Cinman'],
#   ['matt',   'Matt Johnson'],
#   ['james',  'James Au'],
#   ['victor', 'Victor Au'],
#   ['david',  'David Nguyen'],
#   ['josh',   'Josh Kim'],
#   ['jeff',   'Jeff Tang'],
#   ['jon',    'Jon Tang']
# ].each do |u|
#   User.create(
#     :login => u[0], 
#     :email => "#{u[0]}@thebattlebegins.com", :password => 'pass', :password_confirmation => 'pass')
# end

# SaaS
if SubscriptionPlan.count == 0
  plans = [
    { 'name' => 'Free',    'amount' => 0,  'tournament_limit' => 1,  'slot_limit' => 8   },
    { 'name' => 'Noob',   'amount' => 12, 'tournament_limit' => 2,  'slot_limit' => 32  },
    { 'name' => 'Pro',    'amount' => 24, 'tournament_limit' => 5,  'slot_limit' => 64  },
    { 'name' => 'Leet', 'amount' => 49, 'tournament_limit' => 12, 'slot_limit' => 64  }
  ].collect do |plan|
    SubscriptionPlan.create(plan)
  end
end

# user = User.first
# a = Account.create(:name => 'Starfeeder', :subdomain => 'starfeeder', :plan => SubscriptionPlan.find_by_name('Free'), :admin => user)

puts 'Changing secret in environment.rb...'
new_secret = ActiveSupport::SecureRandom.hex(64)
config_file_name = File.join(RAILS_ROOT, 'config', 'environment.rb')
config_file_data = File.read(config_file_name)
File.open(config_file_name, 'w') do |file|
  file.write(config_file_data.sub('9cb7f8ec7e560956b38e35e5e3005adf68acaf1f64600950e2f7dc9e6485d6d9c65566d193204316936b924d7cc72f54cad84b10a70a0257c3fd16e732152565', new_secret))
end
# end Saas


# host = User.find_by_login('dev')
# 
# Account.create(:name => "Starfeeder", :admin => host, :subdomain => "starfeeder", :plan => plans.first)


# 1.times do |i|
#   t = a.tournaments.create(
#     :host => user,
#     :name => "Valor Tournament #{i+1}", 
#     :game => 'Starcraft 2',
#     :slot_count => 8,
#     :rules => 'Do not talk about fight club.',
#     :registration_start_date => 1.days.from_now,
#     :registration_end_date => 30.days.from_now
#   )
#   
#   User.all.each do |u|
#     u.join_tournament(t).accept!
#   end
# end


# t2 = Tournament.create(
#   :host => user,
#   :account_id => 1,
#   :name => 'Starcraft 2 Invitational', 
#   :game => 'Starcraft 2',
#   :slot_count => 8,
#   :rules => 'Do not talk about fight club.',
#   :registration_start_date => 1.days.from_now,
#   :registration_end_date => 30.days.from_now,
#   :use_teams => true,
#   :players_per_team => 2
# )
# 
# User.all.each do |u|
#   u.join_tournament(t2).accept!
# end
# 
# t2_participants = t2.participants
# 4.times do |i|
#   team = t2.teams.create :name => "Team #{i}", :captain => t2_participants.shift
#   team.members << t2_participants.shift
# end
# TeamMember.all.each { |m| m.accept! }