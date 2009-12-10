class Event < ActiveRecord::Base
  default_scope :order => 'created_at DESC'
  
  serialize :data, Hashie::Mash
  
  belongs_to :tournament, :touch => true
  belongs_to :target, :polymorphic => true
end
