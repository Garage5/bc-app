# User.seed_many(:username, :email, [
#     ['dev',    'Developer User'],
#     ['bryan',  'Bryan Cinman'],
#     ['matt',   'Matt Johnson'],
#     ['james',  'James Au'],
#     ['victor', 'Victor Au'],
#     ['david',  'David Nguyen'],
#     ['josh',   'Josh Kim'],
#     ['jeff',   'Jeff Tang'],
#     ['jon',    'Jon Tang'],
#     ['john',    'John Smith'],
#     ['jake',    'Jake Sully']
#   ].collect do |u|
#     { :username => u[0], 
#       :email => "#{u[0]}@thebattlebegins.com", 
#       :password => 'pass', 
#       :password_confirmation => 'pass' }
#   end
# )

users = [
  'dev',
  'bryan',
  'matt',
  'james',
  'victor',
  'david',
  'josh',
  'jeff',
  'jon', 
  'john',
  'jake',
]

users.each do |u|
  User.seed(:username) do |user|
    user.username = u,
    user.email = "#{u}@thebattlebegins.com"
    user.password = 'tbbdev'
    user.password_confirmation = 'tbbdev'
  end
end