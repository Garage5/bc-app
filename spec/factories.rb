Factory.define :user do |u|
  u.sequence(:login) {|n| "user-#{n}"}
  u.sequence(:email) {|n| "user-#{n}@example.com"}
  u.sequence(:name) {|n| "name-#{n}"}
  u.password 'pass'
  u.password_confirmation 'pass'
end

Factory.define :account do |a|
  a.name        'Starfeeder'
  a.association :admin_id, :factory => :user
  a.sequence(:subdomain) {|n| "subdomain-#{n}"}
end

Factory.define :tournament do |t|
  t.name                    'Awesomeness'
  t.game                    'Starcraft 2'
  t.rules                   'These are the rules...'
  t.slot_count              8
  t.registration_start_date Date.today
  t.registration_end_date   Date.today + 1
  t.association             :account_id, :factory => :account
end

Factory.define :plan do |p|
  p.name        'Test'
  p.amount      0
  p.user_limit  100
end

Factory.define :participations do |p|
  p.association :user_id, :factory => :user
  p.association :tournament_id, :factory => :tournament
end

Factory.define :team do |t|
  t.association :tournament_id, :factory => :tournament
  t.sequence(:name) {|n| "team-#{n}"}
end