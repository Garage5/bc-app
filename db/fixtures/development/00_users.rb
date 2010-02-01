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
    user.username = u
    user.email = "#{u}@thebattlebegins.com"
    user.password = 'tbbdev'
    user.password_confirmation = 'tbbdev'
  end
end