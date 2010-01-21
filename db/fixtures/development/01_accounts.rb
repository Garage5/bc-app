# Account.seed(:admin_id) do |a|
#   a.name = 'Starfeeder'
#   a.subdomain = 'starfeeder'
#   a.plan = SubscriptionPlan.find_by_name('Free')
#   a.admin = User.first
# end

Account.create(
  :name => 'Starfeeder', 
  :subdomain => 'starfeeder', 
  :plan => SubscriptionPlan.find_by_name('Free'), 
  :admin => User.first
)