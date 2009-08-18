class Event < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :target, :polymorphic => true
end
