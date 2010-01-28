Factory.define :user do |u|
  u.sequence(:username) {|n| "user-#{n}"}
  u.sequence(:email) {|n| "user-#{n}@example.com"}
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :account do |a|
  a.name        'Starfeeder'
  a.association :admin_id, :factory => :user
  a.plan        SubscriptionPlan.find_by_name('Free')
  a.sequence(:subdomain) {|n| "subdomain#{n}"}
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

Factory.define :participations do |p|
  p.association :participant_id, :factory => :user
  p.association :tournament_id, :factory => :tournament
end