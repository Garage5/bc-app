Factory.define :user do |u|
  u.sequence(:login) {|n| "user-#{n}"}
  u.sequence(:email) {|n| "user-#{n}@example.com"}
  u.sequence(:name) {|n| "name-#{n}"}
  u.password 'pass'
  u.password_confirmation 'pass'
end

Factory.define :instance do |i|
  i.name        'Starfeeder'
  i.association :host_id, :factory => :user
  i.sequence(:subdomain) {|n| "subdomain-#{n}"}
  i.domain 'tbblive.com'
end

Factory.define :tournament do |t|
  t.name                    'Awesomeness'
  t.game                    'Starcraft 2'
  t.rules                   'These are the rules...'
  t.slot_count              8
  t.registration_start_date Date.today
  t.registration_end_date   Date.today + 1
  t.association             :instance_id, :factory => :instance
end

Factory.define :participations do |p|
  p.association :user_id, :factory => :user
  p.association :tournament_id, :factory => :tournament
end