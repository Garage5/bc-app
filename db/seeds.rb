if SubscriptionPlan.count == 0
  plans = [
    { 'name' => 'Free', 'amount' => 0,  'tournament_limit' => 1,  'slot_limit' => 8   },
    { 'name' => 'Noob', 'amount' => 12, 'tournament_limit' => 2,  'slot_limit' => 32  },
    { 'name' => 'Pro',  'amount' => 24, 'tournament_limit' => 5,  'slot_limit' => 64  },
    { 'name' => 'Leet', 'amount' => 49, 'tournament_limit' => 12, 'slot_limit' => 64  }
  ].collect do |plan|
    SubscriptionPlan.create(plan)
  end
end

# puts 'Changing secret in environment.rb...'
# new_secret = ActiveSupport::SecureRandom.hex(64)
# config_file_name = File.join(RAILS_ROOT, 'config', 'environment.rb')
# config_file_data = File.read(config_file_name)
# File.open(config_file_name, 'w') do |file|
#   file.write(config_file_data.sub('9cb7f8ec7e560956b38e35e5e3005adf68acaf1f64600950e2f7dc9e6485d6d9c65566d193204316936b924d7cc72f54cad84b10a70a0257c3fd16e732152565', new_secret))
# end