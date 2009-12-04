class Event < ActiveRecord::Base
  belongs_to :tournament, :touch => true
  belongs_to :target, :polymorphic => true
end
