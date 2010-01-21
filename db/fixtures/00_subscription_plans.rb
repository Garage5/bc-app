if SubscriptionPlan.count == 0
  SubscriptionPlan.seed_many([
    { 'name' => 'Free',    'amount' => 0,  'tournament_limit' => 1,  'slot_limit' => 8   },
    { 'name' => 'Noob',   'amount' => 12, 'tournament_limit' => 2,  'slot_limit' => 32  },
    { 'name' => 'Pro',    'amount' => 24, 'tournament_limit' => 5,  'slot_limit' => 64  },
    { 'name' => 'Leet', 'amount' => 49, 'tournament_limit' => 12, 'slot_limit' => 64  }
  ])
end